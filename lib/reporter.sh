#!/usr/bin/env bash
# lib/reporter.sh – daily health report

generate_report() {
    local report_file="${REPORT_DIR}/health-$(date '+%Y-%m-%d').md"
    {
        echo "# AutoHeal Sentinel – Daily Health Report"
        echo "**Generated:** $(date)"
        echo
        echo "## Current Metrics"
        echo "- CPU Load (1m): $(get_load_average)"
        echo "- Memory Usage: $(get_memory_usage)%"
        echo "- Disk Usage: $(get_disk_usage)%"
        echo
        echo "## Incidents (last 24h)"
        grep "$(date '+%Y-%m-%d')" "$LOG_FILE" || echo "No incidents recorded."
    } > "$report_file"
    log_info "Report generated: ${report_file}"
}
