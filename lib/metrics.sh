#!/usr/bin/env bash
# lib/metrics.sh – system metric collection

get_disk_usage() {
    # Returns usage percentage of the root filesystem
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

get_memory_usage() {
    free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

get_load_average() {
    awk '{print $1}' /proc/loadavg
}

get_top_cpu_process() {
    ps -eo pid,pcpu,comm --sort=-pcpu | awk 'NR==2 {print $1, $2, $3}'
}

check_disk() {
    local usage
    usage=$(get_disk_usage)
    if (( usage > DISK_USAGE_THRESHOLD )); then
        log_warn "Disk usage is ${usage}% (threshold: ${DISK_USAGE_THRESHOLD}%)"
        record_incident "disk" "high" "pending" "Usage=${usage}%"
        return 1
    fi
    return 0
}

check_memory() {
    local usage
    usage=$(get_memory_usage)
    if (( usage > MEMORY_USAGE_THRESHOLD )); then
        log_warn "Memory usage is ${usage}% (threshold: ${MEMORY_USAGE_THRESHOLD}%)"
        record_incident "memory" "high" "pending" "Usage=${usage}%"
        return 1
    fi
    return 0
}

check_load() {
    local load
    load=$(get_load_average)
    # Use awk for floating-point comparison
    if awk "BEGIN {exit !($load > $CPU_LOAD_THRESHOLD)}"; then
        log_warn "Load average is ${load} (threshold: ${CPU_LOAD_THRESHOLD})"
        record_incident "load" "high" "pending" "Load=${load}"
        return 1
    fi
    return 0
}
