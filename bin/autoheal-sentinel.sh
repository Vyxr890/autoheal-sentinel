#!/usr/bin/env bash
set -euo pipefail

# Determine project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PROJECT_ROOT

# Source configuration and libraries
source "${PROJECT_ROOT}/config/thresholds.conf"
source "${PROJECT_ROOT}/lib/logger.sh"
source "${PROJECT_ROOT}/lib/metrics.sh"
source "${PROJECT_ROOT}/lib/remediation.sh"
source "${PROJECT_ROOT}/lib/reporter.sh"

main() {
    log_info "AutoHeal Sentinel started (DRY_RUN=${DRY_RUN})"

    # 1. Collect & check metrics
    if ! check_disk; then
        clean_disk
    fi

    if ! check_memory; then
        # If memory is high, restart a known memory-hungry service if configured
        # (extend as needed)
        log_warn "Memory high – no automatic action configured yet."
    fi

    if ! check_load; then
        read -r pid cpu comm <<< "$(get_top_cpu_process)"
        if awk "BEGIN {exit !($cpu > $PROCESS_CPU_THRESHOLD)}"; then
            kill_runaway_process "$pid" "$cpu" "$comm"
        fi
    fi

    # 2. Check monitored services
    while IFS= read -r svc; do
        [[ -z "$svc" ]] && continue
        restart_failed_service "$svc"
    done < "${PROJECT_ROOT}/config/services.list"

    # 3. Generate daily report
    generate_report

    log_info "AutoHeal Sentinel finished."
}

main "$@"
