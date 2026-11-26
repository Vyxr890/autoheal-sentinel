#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make scripts executable
chmod +x "${PROJECT_ROOT}/bin/autoheal-sentinel.sh"
chmod +x "${PROJECT_ROOT}/lib/"*.sh

# Create required directories
mkdir -p "${PROJECT_ROOT}/logs" "${PROJECT_ROOT}/reports"

# Install cron job (runs every 5 minutes)
CRON_JOB="*/5 * * * * ${PROJECT_ROOT}/bin/autoheal-sentinel.sh >/dev/null 2>&1"
(crontab -l 2>/dev/null | grep -vF "${PROJECT_ROOT}/bin/autoheal-sentinel.sh"; echo "$CRON_JOB") | crontab -

echo "✅ AutoHeal Sentinel installed. Cron job added – running every 5 minutes."
echo "   Check logs at: ${PROJECT_ROOT}/logs/incidents.log"
echo "   Reports at:   ${PROJECT_ROOT}/reports/"
