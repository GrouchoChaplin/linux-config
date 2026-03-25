#!/bin/bash

# ─────────────────────────────────────────────
# Git Branch Pattern Search Tool (Production-Grade)
# 🔹 Supports: branch filter, file pattern, author regex
# 🔹 Output: JSON, CSV, table, per-branch
# 🔹 Flags: verbose, cpu-limit, date range, interrupt-resilient
# Requires: jq
# ─────────────────────────────────────────────

# ─── Check Dependencies ───────────────────────
if ! command -v jq &>/dev/null; then
    echo "❌ 'jq' is required. Install it with: sudo apt install jq"
    exit 1
fi

# ─── Parse Arguments ──────────────────────────
REPO_PATH=""
FILE_PATTERN=""
BRANCH_PATTERN=""
AUTHOR_REGEX=""
SINCE_DATE=""
UNTIL_DATE=""
OUTPUT_FILE=""
CSV_FILE=""
CPUS=0
SCOPE=""
SHOW_TABLE=false
VERBOSE=false
SPLIT_OUTPUT=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repopath) shift; REPO_PATH="$1" ;;
        --file-pattern) shift; FILE_PATTERN="$1" ;;
        --branch-pattern) shift; BRANCH_PATTERN="$1" ;;
        --author) shift; AUTHOR_REGEX="$1" ;;
        --since) shift; SINCE_DATE="$1" ;;
        --until) shift; UNTIL_DATE="$1" ;;
        --output) shift; OUTPUT_FILE="$1" ;;
        --csv) shift; CSV_FILE="$1" ;;
        --cpus) shift; CPUS="$1" ;;
        --table) SHOW_TABLE=true ;;
        --verbose) VERBOSE=true ;;
        --split-output) SPLIT_OUTPUT=true ;;
        --local) SCOPE="local" ;;
        --remote) SCOPE="remote" ;;
        --both) SCOPE="both" ;;
        *) echo "❌ Unknown argument: $1"; exit 1 ;;
    esac
    shift
done

# ─── Validate ─────────────────────────────────
[[ -z "$REPO_PATH" || -z "$FILE_PATTERN" || -z "$SCOPE" ]] && {
    echo "❌ Missing required arguments."
    echo "Usage: $0 --repopath <path> --file-pattern \"<glob>\" --local|--remote|--both [--branch-pattern <glob>] [--author <regex>] [--since <YYYY-MM-DD>] [--until <YYYY-MM-DD>] [--output <file.json>] [--csv <file.csv>] [--table] [--split-output] [--cpus N] [--verbose]"
    exit 1
}
[[ ! -d "$REPO_PATH/.git" ]] && {
    echo "❌ '$REPO_PATH' is not a Git repo."; exit 1;
}

cd "$REPO_PATH" || exit 1

# ─── Collect and Filter Branches ──────────────
if [[ "$SCOPE" == "local" ]]; then
    BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/heads/)
elif [[ "$SCOPE" == "remote" ]]; then
    BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/remotes/)
else
    BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/heads/ refs/remotes/)
fi

# Apply branch filter if specified
if [[ -n "$BRANCH_PATTERN" ]]; then
    FILTERED=()
    for BR in $BRANCHES; do
        [[ "$BR" == $BRANCH_PATTERN ]] && FILTERED+=("$BR")
    done
    BRANCHES="${FILTERED[*]}"
fi

# ─── Setup ────────────────────────────────────
TMP_DIR="/tmp/branch_search_tmp_$$"
RESULT_DIR="/tmp/branch_search_results_$$"
SPLIT_DIR="./branch_search_split_output"
mkdir -p "$TMP_DIR" "$RESULT_DIR"
[[ "$SPLIT_OUTPUT" == true ]] && mkdir -p "$SPLIT_DIR"

# ─── Cleanup on Interrupt ─────────────────────
trap "echo '⚠️  Interrupted. Saving partial results...'; break" SIGINT

# ─── Time Filtering ───────────────────────────
since_ts=0
until_ts=9999999999
[[ -n "$SINCE_DATE" ]] && since_ts=$(date -d "$SINCE_DATE" +%s 2>/dev/null || echo 0)
[[ -n "$UNTIL_DATE" ]] && until_ts=$(date -d "$UNTIL_DATE 23:59:59" +%s 2>/dev/null || echo 9999999999)

# ─── Concurrency Control ──────────────────────
wait_for_jobs() {
    if [[ "$CPUS" -gt 0 ]]; then
        while (( $(jobs -rp | wc -l) >= CPUS )); do sleep 0.3; done
    fi
}

# ─── Branch Processing Function ───────────────
process_branch() {
    local BRANCH="$1"
    local SAFE_BRANCH=$(echo "$BRANCH" | sed 's|/|__|g')
    local UNIQUE_ID="${SAFE_BRANCH}_$$_$RANDOM"
    local OUTPUT_PATH="$RESULT_DIR/${UNIQUE_ID}.json"
    local WORKTREE_PATH="$TMP_DIR/$UNIQUE_ID"

    $VERBOSE && echo "🔍 Searching branch: $BRANCH"

    git worktree add --quiet --detach "$WORKTREE_PATH" "$BRANCH" 2>/dev/null || return
    pushd "$WORKTREE_PATH" > /dev/null || return

    FILES=$(find . -type f -name "$FILE_PATTERN")
    [[ -z "$FILES" ]] && {
        popd > /dev/null
        git worktree remove --force "$WORKTREE_PATH" > /dev/null
        return
    }

    echo "[" > "$OUTPUT_PATH"
    local FIRST=1
    for FILE in $FILES; do
        FILE="${FILE#./}"
        INFO=$(git log -1 --format="%ct|%h|%ad|%an|%s" --date=short -- "$FILE")
        [[ -z "$INFO" ]] && continue
        IFS="|" read -r COMMIT_TS COMMIT_HASH COMMIT_DATE COMMIT_AUTHOR COMMIT_MSG <<< "$INFO"

        if (( COMMIT_TS < since_ts || COMMIT_TS > until_ts )); then continue; fi
        if [[ -n "$AUTHOR_REGEX" && ! "$COMMIT_AUTHOR" =~ $AUTHOR_REGEX ]]; then continue; fi

        [[ $FIRST -eq 0 ]] && echo "," >> "$OUTPUT_PATH"; FIRST=0

        jq -n \
            --arg branch "$BRANCH" \
            --arg file "$FILE" \
            --arg date "$COMMIT_DATE" \
            --arg hash "$COMMIT_HASH" \
            --arg author "$COMMIT_AUTHOR" \
            --arg message "$COMMIT_MSG" \
            --arg timestamp "$COMMIT_TS" \
            '{
                branch: $branch,
                file: $file,
                commit_date: $date,
                commit_hash: $hash,
                author: $author,
                message: $message,
                commit_timestamp: ($timestamp | tonumber)
            }' >> "$OUTPUT_PATH"
    done
    echo "]" >> "$OUTPUT_PATH"

    # Split output
    if [[ "$SPLIT_OUTPUT" == true ]]; then
        jq '.' "$OUTPUT_PATH" > "$SPLIT_DIR/$SAFE_BRANCH.json"
        jq -r '.[] | [.branch, .file, .commit_date, .commit_hash, .author, .message] | @csv' "$OUTPUT_PATH" > "$SPLIT_DIR/$SAFE_BRANCH.csv"
        $VERBOSE && echo "📁 Output saved for $BRANCH → $SPLIT_DIR/$SAFE_BRANCH.{json,csv}"
    fi

    popd > /dev/null
    git worktree remove --force "$WORKTREE_PATH" > /dev/null
}

# ─── Execute Branch Loop ──────────────────────
for BRANCH in $BRANCHES; do
    wait_for_jobs
    process_branch "$BRANCH" &
done
wait

# ─── Merge JSON Results ───────────────────────
ALL_JSON=$(mktemp)
echo "[" > "$ALL_JSON"
FIRST=1
for f in "$RESULT_DIR"/*.json; do
    [[ -f "$f" ]] || continue
    jq -c '.[]' "$f" | while read -r line; do
        [[ $FIRST -eq 0 ]] && echo "," >> "$ALL_JSON"
        FIRST=0
        echo "$line" >> "$ALL_JSON"
    done
done
echo "]" >> "$ALL_JSON"

# ─── Output Formats ───────────────────────────
[[ -n "$OUTPUT_FILE" ]] && cp "$ALL_JSON" "$OUTPUT_FILE" && echo "✅ JSON → $OUTPUT_FILE"
[[ -n "$CSV_FILE" ]] && {
    echo "branch,file,commit_date,commit_hash,author,message" > "$CSV_FILE"
    jq -r '.[] | [.branch, .file, .commit_date, .commit_hash, .author, .message] | @csv' "$ALL_JSON" >> "$CSV_FILE"
    echo "✅ CSV  → $CSV_FILE"
}
if $SHOW_TABLE; then
    printf "\n📋 Results Table:\n"
    printf "%-30s %-30s %-12s %-10s %-20s\n" "Branch" "File" "Date" "Hash" "Author"
    printf "%s\n" "-----------------------------------------------------------------------------------------------------------------------"
    jq -r '.[] | [.branch, .file, .commit_date, .commit_hash, .author] | @tsv' "$ALL_JSON" | \
    while IFS=$'\t' read -r branch file date hash author; do
        printf "%-30s %-30s %-12s %-10s %-20s\n" "$branch" "$file" "$date" "$hash" "$author"
    done
fi

# ─── Cleanup ──────────────────────────────────
rm -rf "$TMP_DIR" "$RESULT_DIR" "$ALL_JSON"
