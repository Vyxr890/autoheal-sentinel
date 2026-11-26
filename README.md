# 🛡️ AutoHeal Sentinel

**A Self-Healing Linux System Monitoring and Automation Suite Built with Bash**

AutoHeal Sentinel is a modular Bash-based Linux automation project designed to monitor system health, detect potential issues, execute configurable remediation actions, and generate automated health reports.

Built and tested on **Ubuntu running inside Windows Subsystem for Linux (WSL)**, this project demonstrates practical Linux system administration, shell scripting, monitoring, troubleshooting, and automation.

---

## 📌 1. The Problem

System administrators regularly deal with operational issues such as:

- High CPU and memory utilization.
- Insufficient disk space.
- Runaway processes consuming system resources.
- Failed or inactive services.
- Lack of regular system health reports.
- Manual and repetitive troubleshooting tasks.

Detecting these problems manually can be time-consuming and may delay incident response.

## 💡 2. The Solution

**AutoHeal Sentinel** automates essential Linux system monitoring and recovery operations through modular Bash scripts.

### Core Features

| Feature | Description |
|---|---|
| System Monitoring | Collects CPU load, memory utilization, disk usage, and top resource-consuming processes. |
| Threshold Detection | Identifies abnormal resource utilization using configurable thresholds. |
| Automated Remediation | Performs predefined recovery actions when configured conditions are met. |
| Disk Management | Identifies and cleans eligible old log files when disk usage exceeds the configured threshold. |
| Process Monitoring | Detects processes exceeding configured CPU utilization limits. |
| Service Monitoring | Checks configured services and attempts recovery when supported. |
| Incident Logging | Maintains timestamped records of detected incidents and remediation activities. |
| Health Reporting | Generates daily system health reports in Markdown format. |
| Dry-Run Mode | Simulates remediation actions without executing destructive changes. |
| Modular Architecture | Separates configuration, monitoring, logging, remediation, and reporting logic. |

---

## 🏗️ 3. Project Architecture

```text
```
autoheal-sentinel/
│
├── bin/
│   └── autoheal-sentinel.sh
│
├── config/
│   ├── thresholds.conf
│   └── services.list
│
├── lib/
│   ├── logger.sh
│   ├── metrics.sh
│   ├── remediation.sh
│   └── reporter.sh
│
├── logs/
│   └── incidents.log
│
├── reports/
│   └── health-YYYY-MM-DD.md
│
├── tests/
│   └── test_autoheal.bats
│
├── install.sh
├── Makefile
├── .gitignore
└── README.md
```
```
### Component Responsibilities
```
```
| Component | Responsibility |
|---|---|
| autoheal-sentinel.sh | Main execution script and workflow orchestration. |
| thresholds.conf | User-defined monitoring thresholds and configuration. |
| services.list | List of services configured for monitoring. |
| logger.sh | Incident logging and timestamp management. |
| metrics.sh | CPU, memory, disk, and process metrics collection. |
| remediation.sh | Automated recovery and cleanup operations. |
| reporter.sh | Generates Markdown-based system health reports. |
| install.sh | Installation and scheduled execution setup. |
| tests/ | Automated testing using BATS. |

---
## ⚙️ 4. Technology Stack

| Technology | Purpose |
|---|---|
| Bash Shell Scripting | Automation and system administration. |
| Ubuntu Linux | Operating system and execution environment. |
| WSL2 | Linux development and testing environment on Windows. |
| Cron | Scheduled monitoring and reporting. |
| Linux Utilities | System metrics and process management. |
| Git & GitHub | Version control and project management. |
| ShellCheck | Shell script static analysis. |
| BATS | Automated Bash testing. |
| Make | Test and lint task automation. |

---

## 🚀 5. Installation and Setup

### Prerequisites

- Windows with WSL2 enabled.
- Ubuntu Linux installed in WSL.
- Bash shell.
- Git.
- Cron.
- Appropriate permissions for configured remediation operations.

### Step 1: Clone the Repository

```bash
```
git clone https://github.com/Vyxr890/autoheal-sentinel.git

cd autoheal-sentinel
```
```
### Step 2: Install Dependencies

```bash
```
sudo apt update

sudo apt install -y \
    git \
    cron \
    shellcheck \
    bats \
    make
```
```
### Step 3: Set Script Permissions

```bash
```
chmod +x bin/autoheal-sentinel.sh
chmod +x install.sh
chmod +x lib/*.sh
```
```
### Step 4: Configure Monitoring Thresholds
Edit the configuration file:

```bash
```
nano config/thresholds.conf
```
```
Example configuration:

```bash
```
DISK_USAGE_THRESHOLD=85
MEMORY_USAGE_THRESHOLD=90
CPU_LOAD_THRESHOLD=8.0
PROCESS_CPU_THRESHOLD=90
DRY_RUN=true
```
```
**Note:** CPU_LOAD_THRESHOLD represents system load average, not CPU utilization percentage. Its appropriate value depends on the number of available CPU cores.

### Step 5: Run the Monitoring Script

```bash
```
./bin/autoheal-sentinel.sh
```
```
### Step 6: Configure Scheduled Monitoring

Run the installation script:

```bash
```
./install.sh
```
```
Verify the scheduled cron jobs:

```bash
```
crontab -l
```
```
**WSL Note:** Cron jobs execute only while the WSL environment is running. For reliable scheduled execution, configure and enable systemd or start the cron service appropriately in WSL.

---

## 🧪 6. Testing and Code Quality

AutoHeal Sentinel uses ShellCheck for static analysis and BATS for automated testing.

### Run ShellCheck

```bash
```
make lint
```
```
### Run Automated Tests

```bash
```
make test
```
```
### Install Testing Dependencies

```bash
```
sudo apt install -y shellcheck bats make
```

```

## 🔐 7. Safety and Reliability

System automation must be predictable and safe.

AutoHeal Sentinel is designed around the following safety principles:

- **Dry-Run Mode:** Simulates remediation before actual execution.
- **Configurable Thresholds:** Monitoring limits can be adjusted without modifying the main scripts.
- **Controlled Cleanup:** Only explicitly configured log directories and eligible files should be considered for deletion.
- **Process Protection:** Critical system processes and the automation script itself must be excluded from termination.
- **Incident Logging:** Every detection and remediation attempt should be recorded.
- **Idempotency:** Repeated execution should not produce unintended changes.
- **Error Handling:** Failed commands and remediation attempts should be reported.
- **Least Privilege:** Execute only the operations that require elevated permissions.

---

## 📊 8. Expected Project Output

### Incident Logs

```text
```
2026-11-26 10:30:00 [INFO] System monitoring started
2026-11-26 10:30:02 [INFO] Disk usage: 72%
2026-11-26 10:30:03 [WARN] Memory usage exceeded threshold
2026-11-26 10:30:04 [INFO] Remediation check completed
```
```
### Daily Health Reports

Reports are generated in Markdown format:

```text
```
reports/
└── health-2026-11-26.md
```
```
The report should contain:

- System health summary.
- CPU load information.
- Memory utilization.
- Disk utilization.
- Top resource-consuming processes.
- Detected incidents.
- Remediation actions and their results.

---

## 🎯 9. Project Objectives

This project demonstrates practical experience in:

- Linux System Administration.
- Advanced Bash Scripting.
- Linux Process Management.
- System Monitoring and Troubleshooting.
- Cron Job Automation.
- Incident Management.
- Automated Recovery.
- Shell Script Testing and Debugging.
- Git and GitHub.

---

## 🔮 10. Future Enhancements

Potential improvements for future versions:

- Email-based incident notifications.
- Telegram alert integration.
- Historical system metrics.
- Resource utilization trend analysis.
- JSON-based monitoring output.
- Configurable alert severity levels.
- Additional Linux distribution support.
- Centralized monitoring dashboard.

---

## 👨‍💻 Author

**Vyankatesh Pande**

Linux System Administration | Bash Automation | DevOps Enthusiast

GitHub: https://github.com/Vyxr890

---

*AutoHeal Sentinel — Detect. Analyze. Remediate. Report.*
