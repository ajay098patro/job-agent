#!/usr/bin/env bash
# Validation Test Suite for Autonomous Job Search Engine (Linux/macOS)
# Mirrors job-skill/test_validation.ps1: tests deduplication, qualification gate,
# granular lifecycle states, database integrity triggers, dynamic source scoring,
# and execution concurrency.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_PATH="${DB_PATH:-$SCRIPT_DIR/data/career.sqlite}"
SQLITE_BIN="${SQLITE_BIN:-$(command -v sqlite3 || true)}"

PASS_COUNT=0
FAIL_COUNT=0

assert_test() {
    local test_name="$1"
    local condition="$2"
    local details="${3:-}"
    if [ "$condition" -eq 0 ]; then
        printf '\033[0;32mPASS: %s\033[0m\n' "$test_name"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        printf '\033[0;31mFAIL: %s (%s)\033[0m\n' "$test_name" "$details"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

run_sql() {
    "$SQLITE_BIN" "$DB_PATH" "$1"
}

echo "=== STARTING AUTONOMOUS JOB SEARCH ENGINE VALIDATION SUITE ==="

# ---------------------------------------------------------------------------
# Test 1: SQLite CLI and Database Availability
# ---------------------------------------------------------------------------
if [ -n "$SQLITE_BIN" ] && [ -x "$SQLITE_BIN" ]; then
    SQLITE_VER="$("$SQLITE_BIN" --version 2>&1)"
    if [[ "$SQLITE_VER" == 3.* ]]; then
        assert_test "SQLite CLI Executable Available" 0 "$SQLITE_VER"
    else
        assert_test "SQLite CLI Executable Available" 1 "$SQLITE_VER"
    fi
else
    assert_test "SQLite CLI Executable Available" 1 "sqlite3 not found in PATH (install via: sudo apt install sqlite3)"
    echo
    echo "=== VALIDATION RESULTS ==="
    echo "Total Passed: $PASS_COUNT"
    echo "Total Failed: $FAIL_COUNT"
    exit 1
fi

if [ ! -f "$DB_PATH" ]; then
    assert_test "Production Database Accessible & Populated" 1 "Database file missing: $DB_PATH"
    exit 1
fi

JOB_COUNT="$(run_sql "SELECT COUNT(*) FROM jobs;")"
if [ "${JOB_COUNT:-0}" -ge 300 ] 2>/dev/null; then
    assert_test "Production Database Accessible & Populated" 0 "Job count: $JOB_COUNT"
else
    assert_test "Production Database Accessible & Populated" 1 "Job count: $JOB_COUNT"
fi

# ---------------------------------------------------------------------------
# Test 2: Job ID 310 Audit Verification (Tekion Corp)
# ---------------------------------------------------------------------------
JOB310_STATUS="$(run_sql "SELECT status FROM jobs WHERE id = 310;")"
JOB310_SCORE="$(run_sql "SELECT fit_score FROM jobs WHERE id = 310;")"
JOB310_SKIP_REASON="$(run_sql "SELECT skip_reason FROM jobs WHERE id = 310;")"

if [ "${JOB310_SCORE:-999}" -le 30 ] 2>/dev/null; then
    assert_test "Job 310 Re-Scored Below Threshold" 0 "Score: $JOB310_SCORE"
else
    assert_test "Job 310 Re-Scored Below Threshold" 1 "Score: $JOB310_SCORE"
fi

if [ "$JOB310_STATUS" = "skipped" ]; then
    assert_test "Job 310 Status Skipped" 0 "Status: $JOB310_STATUS"
else
    assert_test "Job 310 Status Skipped" 1 "Status: $JOB310_STATUS"
fi

if [[ "$JOB310_SKIP_REASON" == *experience_mismatch* ]]; then
    assert_test "Job 310 Skip Reason Documents Experience Mismatch" 0 "Reason: $JOB310_SKIP_REASON"
else
    assert_test "Job 310 Skip Reason Documents Experience Mismatch" 1 "Reason: $JOB310_SKIP_REASON"
fi

# ---------------------------------------------------------------------------
# Test 3: Deduplication Constraint Verification
# ---------------------------------------------------------------------------
TEST_DEDUPE_KEY="test_comp|test_engineer|remote"
EXISTING_TEST_JOB="$(run_sql "SELECT count(*) FROM jobs WHERE dedupe_key = '$TEST_DEDUPE_KEY';")"
if [ "${EXISTING_TEST_JOB:-0}" -eq 0 ] 2>/dev/null; then
    run_sql "INSERT INTO jobs (company_name, company_key, title, dedupe_key, source_board, fit_score, status) VALUES ('Test Company', 'test_comp', 'Test Engineer', '$TEST_DEDUPE_KEY', 'company_portal', 75, 'discovered');" >/dev/null
fi

DUP_ERROR="$(run_sql "INSERT INTO jobs (company_name, company_key, title, dedupe_key, source_board, fit_score, status) VALUES ('Test Company', 'test_comp', 'Test Engineer', '$TEST_DEDUPE_KEY', 'company_portal', 75, 'discovered');" 2>&1 || true)"
if [[ "$DUP_ERROR" == *"UNIQUE constraint failed"* ]]; then
    assert_test "Deduplication Enforcement (Unique dedupe_key rejects duplicate)" 0 "$DUP_ERROR"
else
    assert_test "Deduplication Enforcement (Unique dedupe_key rejects duplicate)" 1 "$DUP_ERROR"
fi

# ---------------------------------------------------------------------------
# Test 4: Database Integrity Trigger (No Deletes)
# ---------------------------------------------------------------------------
DELETE_ERROR="$(run_sql "DELETE FROM jobs WHERE dedupe_key = '$TEST_DEDUPE_KEY';" 2>&1 || true)"
if [[ "$DELETE_ERROR" == *"no deletes"* ]]; then
    assert_test "No-Delete Trigger Enforcement (trg_nodelete_jobs)" 0 "$DELETE_ERROR"
else
    assert_test "No-Delete Trigger Enforcement (trg_nodelete_jobs)" 1 "$DELETE_ERROR"
fi

# ---------------------------------------------------------------------------
# Test 5: Dynamic Sources Catalog & 5-Factor Evaluation
# ---------------------------------------------------------------------------
SOURCE_COUNT="$(run_sql "SELECT COUNT(*) FROM sources;")"
if [ "${SOURCE_COUNT:-0}" -ge 8 ] 2>/dev/null; then
    assert_test "Dynamic Sources Catalog Populated" 0 "Source count: $SOURCE_COUNT"
else
    assert_test "Dynamic Sources Catalog Populated" 1 "Source count: $SOURCE_COUNT"
fi

DEPRIORITIZED_CHECK="$(run_sql "SELECT yield_status FROM sources WHERE domain = 'getmereferred.com';")"
if [ "$DEPRIORITIZED_CHECK" = "deprioritized" ]; then
    assert_test "Deprioritized Sources Classified Correctly" 0 "Yield status: $DEPRIORITIZED_CHECK"
else
    assert_test "Deprioritized Sources Classified Correctly" 1 "Yield status: $DEPRIORITIZED_CHECK"
fi

PROMOTED_CHECK="$(run_sql "SELECT yield_status FROM sources WHERE domain = 'naukri.com';")"
if [ "$PROMOTED_CHECK" = "promoted" ]; then
    assert_test "Promoted Sources Classified Correctly" 0 "Yield status: $PROMOTED_CHECK"
else
    assert_test "Promoted Sources Classified Correctly" 1 "Yield status: $PROMOTED_CHECK"
fi

EVALUATION_HISTORY="$(run_sql "SELECT COUNT(*) FROM source_evaluations;")"
if [ "${EVALUATION_HISTORY:-0}" -ge 3 ] 2>/dev/null; then
    assert_test "Source Evaluations History Recorded" 0 "Evaluations count: $EVALUATION_HISTORY"
else
    assert_test "Source Evaluations History Recorded" 1 "Evaluations count: $EVALUATION_HISTORY"
fi

# ---------------------------------------------------------------------------
# Test 6: Granular Status Lifecycle & Evidentiary Standard
# ---------------------------------------------------------------------------
GRANULAR_DIST="$(run_sql "SELECT COUNT(DISTINCT granular_status) FROM jobs WHERE granular_status IS NOT NULL;")"
if [ "${GRANULAR_DIST:-0}" -ge 4 ] 2>/dev/null; then
    assert_test "Granular Statuses Assigned" 0 "Distinct granular statuses: $GRANULAR_DIST"
else
    assert_test "Granular Statuses Assigned" 1 "Distinct granular statuses: $GRANULAR_DIST"
fi

CONFIRMED_EVIDENCE="$(run_sql "SELECT count(*) FROM jobs WHERE granular_status = 'submission_confirmed' AND submission_evidence IS NOT NULL;")"
if [ "${CONFIRMED_EVIDENCE:-0}" -ge 2 ] 2>/dev/null; then
    assert_test "Submission Confirmed Jobs Require Verifiable Evidence" 0 "Confirmed with evidence: $CONFIRMED_EVIDENCE"
else
    assert_test "Submission Confirmed Jobs Require Verifiable Evidence" 1 "Confirmed with evidence: $CONFIRMED_EVIDENCE"
fi

# ---------------------------------------------------------------------------
# Test 7: Concurrency & State Locking
# ---------------------------------------------------------------------------
STATE_TASKS="$(run_sql "SELECT COUNT(*) FROM execution_state;")"
if [ "${STATE_TASKS:-0}" -ge 4 ] 2>/dev/null; then
    assert_test "Execution State Tasks Configured" 0 "Tasks count: $STATE_TASKS"
else
    assert_test "Execution State Tasks Configured" 1 "Tasks count: $STATE_TASKS"
fi

LOCK_TEST="$(run_sql "SELECT is_running FROM execution_state WHERE task_name = 'vacancy_discovery';")"
if [ "$LOCK_TEST" = "0" ]; then
    assert_test "Task Lock Idle & Unlocked" 0 "is_running: $LOCK_TEST"
else
    assert_test "Task Lock Idle & Unlocked" 1 "is_running: $LOCK_TEST"
fi

# ---------------------------------------------------------------------------
# Test 8: Blocklist Trigger Enforcement
# ---------------------------------------------------------------------------
SAMPLE_BLOCK="$(run_sql "SELECT value_key FROM blocklist WHERE kind = 'company' LIMIT 1;")"
if [ -n "$SAMPLE_BLOCK" ]; then
    BLOCK_TEST_ERR="$(run_sql "INSERT INTO jobs (company_name, company_key, title, dedupe_key, source_board, fit_score, status) VALUES ('Blocked Co', '$SAMPLE_BLOCK', 'Data Engineer', 'blocked|de|india', 'company_portal', 80, 'discovered');" 2>&1 || true)"
    if [[ "$BLOCK_TEST_ERR" == *"company is blocklisted"* ]]; then
        assert_test "Blocklist Trigger Enforcement (trg_jobs_blocked)" 0 "$BLOCK_TEST_ERR"
    else
        assert_test "Blocklist Trigger Enforcement (trg_jobs_blocked)" 1 "$BLOCK_TEST_ERR"
    fi
fi

# ---------------------------------------------------------------------------
# Test Summary
# ---------------------------------------------------------------------------
echo
echo "=== VALIDATION RESULTS ==="
echo "Total Passed: $PASS_COUNT"
echo "Total Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "ALL VALIDATION CHECKS PASSED!"
    exit 0
else
    echo "SOME CHECKS FAILED. PLEASE REVIEW."
    exit 1
fi
