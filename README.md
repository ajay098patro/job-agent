# Job Search & Outreach Automation Engine

Autonomous multi-platform job application and recruitment outreach pipeline tailored for Data Engineering, Database Engineering, and Python Backend roles across India and Remote.

The engine operates on a **Pure AI Agent Architecture** (Zero Hardcoded Scraping Scripts). It automates candidate discovery, ATS application submission, personalized recruiter outreach, intent-driven conversational classification, and referrer circle-back re-engagement, strictly adhering to candidate truth, Markdown operational protocols, and database integrity triggers.

---

## Unified 8-Topic Architecture

All operations are organized into 8 distinct operational topics:

1. **Topic 1: Job Boards**: Native applications across high-speed platforms (Naukri: 35/day, LinkedIn Easy Apply: 25/day, Indeed: 15/day).
2. **Topic 2: ATS Portals**: Direct corporate ATS platforms (Ashby, Greenhouse, Lever, Workable, SmartRecruiters, Workday) and external job links (40/day).
3. **Topic 3: Post-Based Job Mail**: Targeted email applications sent directly to recruiters from live hiring posts (No Limit).
4. **Topic 4: HR Cold Mail**: Proactive high-density cold emails sent to HR and Talent Acquisition leads via Outlook Webmail (No Limit).
5. **Topic 5: Connect People**: High-leverage LinkedIn connection requests sent to senior engineering decision-makers (Senior, Lead, Manager, Director, Head, Principal) using the mandatory `titleFreeText` filter (No Limit).
6. **Topic 6: Inbound Communications (Top Priority Always)**: Sweeps active LinkedIn message drawers, incoming connection requests with notes, and Outlook Webmail inbox. Answers all pending recruiter inquiries, screening questions, and referral follow-ups before any outbound action is taken (No Limit).
7. **Topic 7: New Connection Outreach Dispatch**: Dedicated outbound capabilities notes dispatched to newly connected LinkedIn members from the database boundary (No Limit).
8. **Topic 8: Circle Back**: Continuous monitoring and re-engagement of contacts who explicitly agreed to refer the candidate, auditing company career pages without visiting LinkedIn profiles during periodic background sweeps.

---

## User Invocation Commands

The engine is triggered using 5 grouped conversational commands:

| Command | Operational Topics Executed | Scope & Purpose |
| :--- | :--- | :--- |
| `Handle inbound communications` | **Topic 6** | Sweeps and handles all incoming messages, chats, connection notes, and recruiter emails across LinkedIn and Outlook Webmail. Top priority always. |
| `run job apply` | **Topic 1 & Topic 2** | Job Boards (Naukri, LinkedIn Easy Apply, Indeed) + Direct ATS Portals & external redirect links. |
| `run connet` (or `run connect`) | **Topic 5** | LinkedIn connection requests to senior engineering decision-makers with `titleFreeText` filter. |
| `run dispath messages and email` | **Topic 7, Topic 3 & Topic 4** | Intro notes to newly connected LinkedIn members from DB boundary + Targeted job posting emails & HR cold emails via Outlook. |
| `circle back` | **Topic 8** | Willing referrers monitoring on company career pages; checks for fresh 0–6 yr openings without touching LinkedIn profiles. |
| `complete all topic` (or `run all`) | **All Topics (6 -> 1 -> 2 -> 5 -> 7 -> 3 -> 4 -> 8)** | Sequentially runs the complete job search and outreach lifecycle. |
| `status` | **Monitoring** | Reports daily action counts, circle back referrers, active queues, and system state. |

---

## Quick Start (3 Standard Commands)

All routine tasks are unified into 3 simple npm scripts:

### 1. Initialize the Environment
```bash
npm run init
```
*(or run `./init.sh` directly)*

Validates Node.js v22+, `sqlite3` CLI, Brave Browser, ensures directory structures exist, bootstraps `job-skill/data/career.sqlite` from `job-skill/schema.sql`, verifies candidate profile and CV, and generates local gitignored `mcp_config.json`.

### 2. Compile CV Variants
```bash
npm run cv:build
```
Compiles ATS-optimized PDF resume variants from `job-skill/cv/master.tex` using `pdflatex`:
- Master Baseline CV: `job-skill/cv/Ajay_Patro_CV.pdf`
- Data Engineer Variant: `job-skill/cv/variants/Ajay_Patro_Data_Engineer.pdf`
- Database Engineer Variant: `job-skill/cv/variants/Ajay_Patro_Database_Engineer.pdf`
- Python Backend Developer Variant: `job-skill/cv/variants/Ajay_Patro_Python_Backend.pdf`

### 3. Run Validation Suite
```bash
npm run validate
```
*(or run `bash ./job-skill/test_validation.sh` directly)*

Executes the automated 16-point test suite verifying SQLite CLI availability, database integrity triggers (no-delete, company blocklist), unique deduplication keys, 5-factor source scoring, granular status transitions, and state locking.

---

## Directory Architecture

```text
job-search/
├── .agents/                    # Agent skill definitions (.agents/skills/job-skill -> job-skill/)
├── .gitattributes              # Cross-platform line-ending rules
├── .gitignore                  # Git exclusion rules (databases, logs, build artifacts)
├── AGENTS.md                   # Authoritative operational rules, candidate truth, and guardrails
├── init.sh                     # Linux/macOS initializer and environment validator
├── package.json                # 3 unified script shortcuts (init, cv:build, validate)
├── README.md                   # Complete project documentation
└── job-skill/                  # Core automation engine & candidate truth
    ├── cv/                     # LaTeX CV source, active master PDF, variants & playbooks
    │   ├── Ajay_Patro_CV.pdf   # Active master CV
    │   ├── master.tex          # ATS-friendly LaTeX source
    │   ├── build_variants.py   # Compiles tailored resume variants
    │   ├── variants/           # Tailored PDFs (Data Eng, Database Eng, Python Backend)
    │   ├── playbooks/          # LinkedIn & Naukri career playbooks
    │   └── out/                # Build output directory
    ├── data/
    │   └── career.sqlite       # Authoritative SQLite production database
    ├── discovery/
    │   └── signatures.json     # Role search query signatures & keyword combinations
    ├── migrations/             # Database migrations (001_dynamic_sources_and_execution.sql)
    ├── boards.md               # Dynamic sources catalog and platform-specific guidelines
    ├── mcp-config-snippet.json # Playwright MCP configuration template
    ├── pillars.md              # Workflow execution playbooks
    ├── profile.json            # Active candidate truth profile & messaging templates
    ├── profile.template.json   # Pristine candidate profile schema template
    ├── schema.sql              # Complete SQLite database schema & triggers
    ├── SKILL.md                # Agent instruction set and execution procedures
    └── test_validation.sh      # 16-point automated validation test suite
```

---

## Candidate Truth & Operational Guardrails

- **Candidate Name**: Ajay Kumar Patro
- **Contact Details**: Phone: +91-7894464335, Email: `ajay789patro@outlook.com`
- **Workday / SSO Login**: Google SSO (`ajay0patro@gmail.com`)
- **Experience Truth**: 2.5 Years hands-on experience in PostgreSQL, PostGIS, SQL query optimization, Apache Airflow ETL, and Python backend engineering.
- **Authorized Experience Bracket**: 0–6 Years (rejects only strictly > 6 years).
- **Current CTC / Expected CTC**: ₹3.6 LPA / ₹10–13 LPA.
- **Notice Period**: 30 Days.
- **Zero-Emoji Professional Standard**: Strict prohibition of emojis across all outreach messages, connection notes, emails, and database records.
- **Direct Message Dispatch Mode (`approval_mode = 'none'`)**: Outbound messages, referral follow-ups, and connection notes are dispatched directly by the agent upon generation without requiring manual review gates.
- **Mandatory Historical Inspection**: Every conversation thread is inspected from Turn 1 to the end before formulating any response.
- **Strict CV De-Duplication**: If `Ajay_Patro_CV.pdf` was already shared anywhere in the previous thread history, it is never re-attached.
- **Queued Job Prefill Protocol**: All jobs queued for manual candidate completion (`awaiting_user_info`) are actively opened and 100% prefilled by the agent before handoff.
