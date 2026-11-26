#!/usr/bin/env bash
# lib/logger.sh – logging utilities for AutoHeal Sentinel

LOG_FILE="${PROJECT_ROOT}/logs/incidents.log"
REPORT_DIR="${PROJECT_ROOT}/reports"

log_info() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $msg" | tee -a "$LOG_FILE"
}

log_warn() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $msg" | tee -a "$LOG_FILE"
}

log_error() {
    local msg="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $msg" | tee -a "$LOG_FILE" >&2
}

record_incident() {
    local type="$1"
    local severity="$2"
    local action="$3"
    local details="$4"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${timestamp}|${type}|${severity}|${action}|${details}" >> "$LOG_FILE"
    log_warn "Incident recorded: ${type} (${severity}) – action: ${action}"
}
