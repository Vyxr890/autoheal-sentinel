#!/usr/bin/env bash
# lib/remediation.sh – safe automated remediation

clean_disk() {
    log_info "Attempting disk cleanup..."
    for path in $CLEAN_PATHS; do
        if [[ -d "$path" ]]; then
            # Remove files older than 7 days in /tmp and old logs
            find "$path" -type f -mtime +7 -delete 2>/dev/null
            log_info "Cleaned files older than 7 days in ${path}"
        fi
    done
    # Truncate large log files (keep last 1000 lines)
    find /var/log -type f -name "*.log" -size +10M -exec sh -c 'tail -n 1000 "$1" > "$1.tmp" && mv "$1.tmp" "$1"' _ {} \;
    record_incident "disk" "high" "cleaned" "Removed old files and truncated large logs"
}

restart_failed_service() {
    local service="$1"
    if systemctl is-failed --quiet "$service" 2>/dev/null; then
        log_info "Service ${service} is failed – attempting restart"
        if [[ "$DRY_RUN" == "false" ]]; then
            sudo systemctl restart "$service"
            record_incident "service" "critical" "restarted" "Service=${service}"
        else
            log_info "[DRY-RUN] Would restart ${service}"
        fi
    fi
}

kill_runaway_process() {
    local pid="$1"
    local cpu="$2"
    local comm="$3"
    log_warn "Process ${comm} (PID ${pid}) using ${cpu}% CPU – terminating"
    if [[ "$DRY_RUN" == "false" ]]; then
        kill -TERM "$pid" 2>/dev/null || kill -KILL "$pid" 2>/dev/null
        record_incident "process" "high" "killed" "PID=${pid} CPU=${cpu}% COMM=${comm}"
    else
        log_info "[DRY-RUN] Would kill PID ${pid}"
    fi
}
