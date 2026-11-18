#!/usr/bin/env bash
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT" || exit 1

echo "==================================================="
echo "  Job Search and Application Automation Engine"
echo "==================================================="
echo

WARNINGS=0

# 1. Check Node.js & npx
if command -v node >/dev/null 2>&1; then
    NODE_VERSION="$(node -v)"
    NODE_MAJOR="${NODE_VERSION#v}"
    NODE_MAJOR="${NODE_MAJOR%%.*}"
    if [ "$NODE_MAJOR" -ge 22 ] 2>/dev/null; then
        echo "[OK] Node.js detected: $NODE_VERSION"
    else
        echo "[WARNING] Node.js $NODE_VERSION detected; v22 or higher is recommended."
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "[WARNING] Node.js not found in PATH. Install Node.js v22+ (required for Playwright MCP via npx)."
    WARNINGS=$((WARNINGS + 1))
fi

if command -v npx >/dev/null 2>&1; then
    echo "[OK] npx detected: $(npx -v 2>/dev/null || echo 'available')"
else
    echo "[WARNING] npx not found in PATH. Install npm/Node.js for @playwright/mcp."
    WARNINGS=$((WARNINGS + 1))
fi

# 2. Check SQLite CLI
if command -v sqlite3 >/dev/null 2>&1; then
    echo "[OK] sqlite3 CLI detected: $(sqlite3 --version)"
else
    echo "[WARNING] sqlite3 CLI not found in PATH (install on Debian/Ubuntu: sudo apt install sqlite3)."
    WARNINGS=$((WARNINGS + 1))
fi

# 3. Check Brave Browser
BRAVE_BIN=""
for candidate in brave-browser brave-browser-stable brave /usr/bin/brave-browser; do
    if command -v "$candidate" >/dev/null 2>&1; then
        BRAVE_BIN="$(command -v "$candidate")"
        break
    elif [ -x "$candidate" ]; then
        BRAVE_BIN="$candidate"
        break
    fi
done

if [ -n "$BRAVE_BIN" ]; then
    echo "[OK] Brave Browser detected: $BRAVE_BIN"
else
    BRAVE_BIN="/usr/bin/brave-browser"
    echo "[WARNING] Brave Browser not found in PATH (expected /usr/bin/brave-browser)."
    WARNINGS=$((WARNINGS + 1))
fi

# 4. Check LaTeX (optional)
if command -v pdflatex >/dev/null 2>&1; then
    echo "[OK] pdflatex detected: $(pdflatex --version | head -n 1)"
else
    echo "[INFO] pdflatex not found (optional; needed only to recompile tailored CVs from master.tex)."
fi

# 5. Ensure runtime directories exist
mkdir -p "$REPO_ROOT/job-skill/data" "$REPO_ROOT/job-skill/cv/out" "$REPO_ROOT/_pw-output"

# 6. Check / Initialize SQLite Database
DB_PATH="$REPO_ROOT/job-skill/data/career.sqlite"
SCHEMA_PATH="$REPO_ROOT/job-skill/schema.sql"
if [ ! -f "$DB_PATH" ]; then
    echo "[INFO] Initializing new SQLite database from job-skill/schema.sql..."
    if command -v sqlite3 >/dev/null 2>&1; then
        sqlite3 "$DB_PATH" < "$SCHEMA_PATH"
    elif command -v node >/dev/null 2>&1; then
        node -e "const { DatabaseSync } = require('node:sqlite'); const fs = require('node:fs'); const db = new DatabaseSync(process.argv[1]); db.exec(fs.readFileSync(process.argv[2], 'utf8'));" "$DB_PATH" "$SCHEMA_PATH"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c "import pathlib, sqlite3, sys; conn = sqlite3.connect(sys.argv[1]); conn.executescript(pathlib.Path(sys.argv[2]).read_text(encoding='utf-8')); conn.close()" "$DB_PATH" "$SCHEMA_PATH"
    else
        echo "[ERROR] Cannot initialize career.sqlite: neither sqlite3, node, nor python3 is available."
        exit 1
    fi
    echo "[OK] career.sqlite created and schema applied."
else
    echo "[OK] SQLite database exists: job-skill/data/career.sqlite"
fi

# 7. Ensure profile.json exists
PROFILE_PATH="$REPO_ROOT/job-skill/profile.json"
if [ ! -f "$PROFILE_PATH" ]; then
    echo "[NOTICE] No candidate profile detected. Copying profile.template.json..."
    cp "$REPO_ROOT/job-skill/profile.template.json" "$PROFILE_PATH"
    echo "[INFO] Created job-skill/profile.json. Please edit with candidate truth details."
fi

# Display active candidate
ACTIVE_CANDIDATE="Unknown"
CV_PATH=""
if command -v python3 >/dev/null 2>&1; then
    ACTIVE_CANDIDATE="$(python3 -c "import json,sys; p=json.load(open(sys.argv[1], encoding='utf-8')); print(f\"{p.get('identity',{}).get('full_name','Unknown')} ({p.get('identity',{}).get('email','')})\")" "$PROFILE_PATH" 2>/dev/null || echo 'Unknown')"
    CV_PATH="$(python3 -c "import json,sys; p=json.load(open(sys.argv[1], encoding='utf-8')); print(p.get('cv',{}).get('existing_pdf',''))" "$PROFILE_PATH" 2>/dev/null || echo '')"
elif command -v node >/dev/null 2>&1; then
    ACTIVE_CANDIDATE="$(node -e "const p=require(process.argv[1]); console.log(p.identity.full_name + ' (' + p.identity.email + ')')" "$PROFILE_PATH" 2>/dev/null || echo 'Unknown')"
    CV_PATH="$(node -e "const p=require(process.argv[1]); console.log((p.cv && p.cv.existing_pdf) || '')" "$PROFILE_PATH" 2>/dev/null || echo '')"
fi
echo "[OK] Active Candidate Profile: $ACTIVE_CANDIDATE"

# 8. Verify Master CV exists
if [ -n "$CV_PATH" ] && [ -f "$REPO_ROOT/$CV_PATH" ]; then
    echo "[OK] Master CV verified: $CV_PATH"
elif [ -f "$REPO_ROOT/job-skill/cv/Ajay_Patro_CV.pdf" ]; then
    echo "[OK] Master CV verified: job-skill/cv/Ajay_Patro_CV.pdf"
else
    echo "[WARNING] Master CV not found at job-skill/cv/Ajay_Patro_CV.pdf."
    WARNINGS=$((WARNINGS + 1))
fi

# 9. Verify single-source architecture (no redundant duplicate folders)
mkdir -p "$REPO_ROOT/.agents/skills"
if [ ! -L "$REPO_ROOT/.agents/skills/job-skill" ]; then
    if [ -d "$REPO_ROOT/.agents/skills/job-skill" ]; then
        rm -rf "$REPO_ROOT/.agents/skills/job-skill"
    fi
    ln -s ../../job-skill "$REPO_ROOT/.agents/skills/job-skill"
fi
echo "[OK] Unified workspace verified: single folder architecture active (.agents/skills/job-skill -> job-skill/)"

# 10. Generate local gitignored mcp_config.json for this Linux workspace
PROFILE_DIR="$HOME/.config/BraveSoftware/Brave-Browser/PlaywrightProfile"
PW_OUTPUT_DIR="$REPO_ROOT/_pw-output"
LOCAL_MCP="$REPO_ROOT/mcp_config.json"

cat > "$LOCAL_MCP" <<EOF
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@playwright/mcp@0.0.83",
        "--browser=chromium",
        "--executable-path=$BRAVE_BIN",
        "--user-data-dir=$PROFILE_DIR",
        "--no-sandbox",
        "--allow-unrestricted-file-access",
        "--output-dir=$PW_OUTPUT_DIR"
      ]
    }
  }
}
EOF
echo "[OK] Generated local MCP config: mcp_config.json (gitignored)"

MCP_FOUND=0
for cfg in "$HOME/.gemini/antigravity/mcp_config.json" "$HOME/.gemini/config/mcp_config.json"; do
    if [ -f "$cfg" ]; then
        MCP_FOUND=1
        echo "[OK] Global Antigravity MCP config found: $cfg"
    fi
done
if [ "$MCP_FOUND" -eq 0 ]; then
    echo "[INFO] No Antigravity mcp_config.json detected in ~/.gemini/antigravity/ or ~/.gemini/config/."
    echo "       Copy or merge $LOCAL_MCP into your Antigravity MCP settings."
fi

echo
echo "==================================================="
if [ "$WARNINGS" -eq 0 ]; then
    echo "  Initialization Complete! Project is ready."
else
    echo "  Initialization Complete with $WARNINGS warning(s)."
fi
echo "==================================================="
echo
echo "Useful commands:"
echo "  Database inspection:  sqlite3 \"job-skill/data/career.sqlite\" \".tables\""
echo "  Run validation suite: npm run validate"
echo "  Operational rules:    AGENTS.md"
echo
