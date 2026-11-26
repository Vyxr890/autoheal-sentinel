#!/usr/bin/env bats
#
# tests/test_metrics.bats
# Unit tests for lib/metrics.sh and lib/remediation.sh

setup() {
    export PROJECT_ROOT="$(mktemp -d)"
    mkdir -p "${PROJECT_ROOT}/logs" "${PROJECT_ROOT}/reports"

    source "${BATS_TEST_DIRNAME}/../lib/logger.sh"
    source "${BATS_TEST_DIRNAME}/../lib/metrics.sh"

    DISK_USAGE_THRESHOLD=85
    MEMORY_USAGE_THRESHOLD=90
    CPU_LOAD_THRESHOLD=8.0
    PROCESS_CPU_THRESHOLD=90
}

teardown() {
    rm -rf "${PROJECT_ROOT}"
}

@test "get_disk_usage returns a number between 0 and 100" {
    run get_disk_usage
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9]+$ ]]
    [ "$output" -ge 0 ]
    [ "$output" -le 100 ]
}

@test "get_memory_usage returns a number between 0 and 100" {
    run get_memory_usage
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9]+$ ]]
    [ "$output" -ge 0 ]
    [ "$output" -le 100 ]
}

@test "get_load_average returns a positive float" {
    run get_load_average
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9]+(\.[0-9]+)?$ ]]
}

@test "get_top_cpu_process returns pid cpu comm (3 fields)" {
    run get_top_cpu_process
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | wc -w)" -eq 3 ]
}

@test "check_disk passes when threshold is 100" {
    DISK_USAGE_THRESHOLD=100
    run check_disk
    [ "$status" -eq 0 ]
}

@test "check_disk fails when threshold is 0" {
    DISK_USAGE_THRESHOLD=0
    run check_disk
    [ "$status" -ne 0 ]
}

@test "check_disk writes an incident line when threshold breached" {
    DISK_USAGE_THRESHOLD=0
    run check_disk
    [ "$status" -ne 0 ]
    grep -q "|disk|" "${PROJECT_ROOT}/logs/incidents.log"
}

@test "check_memory passes when threshold is 100" {
    MEMORY_USAGE_THRESHOLD=100
    run check_memory
    [ "$status" -eq 0 ]
}

@test "check_load passes when threshold is very high" {
    CPU_LOAD_THRESHOLD=9999.0
    run check_load
    [ "$status" -eq 0 ]
}

@test "kill_runaway_process does nothing in DRY_RUN mode" {
    source "${BATS_TEST_DIRNAME}/../lib/remediation.sh"
    DRY_RUN=true

    sleep 60 &
    local pid=$!

    run kill_runaway_process "$pid" 99 "sleep"
    [ "$status" -eq 0 ]

    kill -0 "$pid"
    kill "$pid" 2>/dev/null || true
}
