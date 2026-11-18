# Project & Agent Operational Rules

## 1. Browser & Automation Rules (Exclusive Playwright MCP Policy)
- **Mandatory Exclusive Interface**: All browser interaction MUST happen exclusively through the existing `playwright` MCP server.
  - Available tools:
    - `browser_tabs`
    - `browser_navigate`
    - `browser_navigate_back`
    - `browser_snapshot`
    - `browser_take_screenshot`
    - `browser_click`
    - `browser_type`
    - `browser_press_key`
    - `browser_fill_form`
    - `browser_hover`
    - `browser_select_option`
    - `browser_handle_dialog`
    - `browser_console_messages`
    - `browser_network_requests`
    - `browser_evaluate`
- **Strictly Prohibited for Browser Control**:
  - Do NOT use custom Python browser automation.
  - Do NOT use standalone Playwright navigation scripts.
  - Do NOT use Puppeteer, Selenium, or alternative browser-control frameworks.
  - Do NOT use direct CDP HTTP requests or direct CDP WebSocket connections.
  - Do NOT create or use custom Chrome DevTools Protocol helpers (e.g. `cdp_helper.py`).
  - Do NOT use manual browser debugging ports (e.g. port 9222).
  - Do NOT use BAT files to start browsers for automation.
  - Do NOT use alternative browser-control MCP servers.
  - Do NOT generate scripts to perform routine actions already supported by MCP tools.
- **Dedicated Tab / Page Isolation**: When opening a new flow or external application, create a clean dedicated tab via `browser_tabs(action='new', url=...)`. NEVER navigate or hijack active candidate tabs. Close auxiliary tabs when finished.
- **Direct Message Dispatch Mode (`approval_mode = 'none'`)**:
  - Per candidate directive ("no review need to msg sending"), ALL outbound messages, referral follow-ups, recruiter cold emails, and personalized connection notes are dispatched directly by the agent upon generation without requiring manual review gates.
  - The agent reserves the action in `actions`, dispatches directly via Playwright MCP or Outlook, and records `status = 'sent'` in `messages` and `actions`.
- **Failure Policy**:
  - If Playwright MCP is unavailable or fails:
    1. Inspect the MCP error.
    2. Report the failure.
    3. Diagnose the existing MCP configuration.
    4. Ask for intervention if required.
  - Never silently switch to another browser automation mechanism.
- **Browser Session & State Policy**:
  - Reuse the existing Brave browser session.
  - Reuse the configured persistent profile (`PlaywrightProfile`).
  - Do not unnecessarily create new browser instances.
  - Do not clear cookies or browser storage.
  - Do not interfere with the user's active sessions (LinkedIn, Naukri, Instahyre).
  - Verify important interactions using snapshots or screenshots.
- **Clean Overlays**: Always clear overlays or popups before attempting clicks.
- **Form Filling Boundaries**: Form filling must use standard inputs and keys; direct DOM mutation without triggering events is prohibited.

## 2. Communication & Messaging Rules
- **ZERO EMOJIS**: NEVER use emojis in any message, cold outreach, LinkedIn note, or email.
- **Messages Priority**: Stage 1 (Inbox Sweep & Replies) is always processed first.
- **Ultra-Slim Email Template**: Recruiter cold emails must be ultra-slim and high-density:
  - 1-line hook/context.
  - Quick overview of relevant experience (specifically highlight 2.5+ years hands-on experience in PostgreSQL & PostGIS, spatial schemas, GiST indexing, query optimization, and Python backend ETL).
  - NO bulky "Key Details" (CTC/Notice) block in the cold email body.
  - Resume attachment (`Ajay_Patro_CV.pdf`).
  - Single consistent signature:
    Regards  
    Ajay Kumar Patro  
    +91-7894464335  
    ajay789patro@outlook.com

## 3. Candidate Truth & Credentials
- **Name**: Ajay Kumar Patro
- **Phone**: +91-7894464335 (matching resume and Outlook signature)
- **Email**: ajay789patro@outlook.com (dispatched from Outlook)
- **Current CTC**: ₹3.6 LPA
- **Expected CTC**: ₹10–13 LPA
- **Notice Period**: 30 days
- **CV Path**: `job-skill/cv/Ajay_Patro_CV.pdf` (relative to workspace root)

## 4. Location & Relocation Behavioral Protocol
- **Primary Preferences**: Hyderabad, Bengaluru, Chennai, Remote/Hybrid (immediately open and flexible at baseline ₹10–13 LPA).
- **All Other Locations Across India (e.g., Guwahati, Delhi/NCR, Pune, Mumbai, Kolkata, etc.)**: Do NOT reject any location. The candidate is permissive and open to relocating anywhere in India, but moving outside the primary South hubs requires a higher budget/compensation package than the standard baseline to justify the relocation.
- **Negotiation Response**: When asked *"Can you relocate to [City]?"* (outside HYD/BLR/Chennai), respond permissively: express openness to consider it depending on the overall opportunity, and inquire about the role scope, budget/compensation package on offer, and relocation assistance so we can evaluate and decide.
- **Trigger Condition**: Only bring up this relocation/compensation evaluation inquiry if the recruiter or hiring manager specifically asks about location/relocation.

## 5. Mandatory Historical Message Inspection & Intent-Driven Conversational Classification Gate
- **NEVER Message Without Full History Inspection**: The agent must **NEVER** send a message or reply to ANY contact without reading, parsing, and inspecting the **entire historical conversation transcript** from Turn 1 to the end. This prevents misinterpreting messages, contradicting past statements, or missing critical invitations.
- **Intent-Driven Conversational Classification (Not Scriptable/Regex Rules)**:
  Conversational responses require deep, nuanced intent understanding. The agent must evaluate the contact's tone, actual context, and underlying intent, classifying the interaction into one of 4 dedicated categories:
  1. **Category A: Immediate Active Referral Lead (Direct Referrer Action)**:
     - **Intent**: The contact actively invites Ajay to share job links, check their portal/LinkedIn for vacancies, or explicitly offers to refer him (e.g. Shivam Parashari saying *"Please check the vacancies on the portal or linkedin and let me know if there is anything that matches your skillset"*).
     - **Protocol**: NEVER treat as Circle Back and NEVER ask to circle back later. Immediately search the company's active openings on LinkedIn / ATS portal for roles matching the 0–6 yr bracket (prioritizing PostgreSQL/PostGIS DBA, Data Engineer, Python Backend).
     - **Immediate Action**: Dispatch an immediate peer message with the exact Job Title, Job ID, and direct link, attach `Ajay_Patro_CV.pdf`, and respectfully request the referral. Set `contacts.stage = 'links_sent'`, retain conversation star on LinkedIn, and record the action.
  2. **Category B: Circle Back Potential Lead (Circumstantial / No Current Openings)**:
     - **Intent**: The contact is polite, respectful, or encouraging, but declines solely due to team/company limitations (*"We do not have any current openings"*, *"I am hiring for different profiles"*, *"Sure will let you know if any openings come up"*, *"I will keep your skills in mind"*).
     - **The Non-Pushy Professional Conversion Bridge**: Respect their limitation completely without arguing, pushing, or spamming. Send a concise, polite, 1–2 sentence human peer inquiry asking permission to circle back:
       *"thanks [Name]. is it ok if I circle back to you? I will keep an eye on open roles, and if anything relevant comes up that matches my profile, I'll reach back out to you for a referral if that works for you."*
     - **The Addition & Star Trigger**: If they respond with **YES of any kind** (*"Sure"*, *"Yes"*, *"Definitely"*, *"Feel free"*, *"Sounds good"*, *"Anytime"*, *"Sure thing"*):
       1. Immediately add them to **Topic 8: Circle Back** (`contacts.stage = 'agreed_to_refer'`).
       2. Star their conversation in LinkedIn messaging using the "Star conversation" button so they are tracked under the **Starred** filter.
       3. Record company details and career page in `career.sqlite` (`research_notes`).
       4. Conversation transitions to **REST** (no redundant messages sent).
  3. **Category C: Mentorship & Overly Helpful Contacts (Personal Engagement Queue)**:
     - **Intent**: The contact goes beyond a referral or polite response—offering guidance, career advice, personal mentorship, portfolio/mock review, or interview preparation.
     - **Protocol**: Star their conversation in LinkedIn messaging (`Starred` filter). Do NOT automate outbound replies with canned templates.
     - **Human Review Reporting**: Add them to a dedicated **Mentorship & Personal Engagement Queue** report at the end of the run (alongside the manual job application queue) so Ajay can personally review and interact with them directly.
  4. **Category D: Terminal Rest (Hard Stops & Conversational Closures)**:
     - **Intent**: The contact displays explicit disinterest (*"Not interested"*, *"Please don't message me"*, rude rejections), or sends only a standalone emoji reaction (`👍`, `🙏`, `👏`, `😊`) with no text.
     - **Protocol**: Say a brief polite thank you or remain at strict **TERMINAL REST**. Do NOT reply. If the contact has ALREADY agreed to circle back (e.g., Sanyam Singhi), the conversation remains at **REST**.
- **Strict CV De-Duplication**: If `Ajay_Patro_CV.pdf` was already shared anywhere in the previous history of the conversation, **NEVER** re-attach or re-send the CV.

## 6. Multi-Platform Job Application Protocol, LinkedIn External Link Mandate & Limit Failover
- **LinkedIn Dual-Route Mandate (Easy Apply + External Job Links)**:
  - Applications on LinkedIn must **NOT** be restricted to Easy Apply alone. Applying to external job links (where the "Apply" button redirects to direct company career sites or ATS portals such as Ashby, Greenhouse, Lever, Workable, SmartRecruiters, Workday) is **MANDATORY**.
  - When evaluating LinkedIn listings, process both Easy Apply openings (`apply_linkedin`) and external job link openings (`apply_portal`).
  - For external job links, follow Rule 11: open in a dedicated tab, prefill candidate truth (Ajay Kumar Patro, ajay789patro@outlook.com, +91-7894464335, attach `Ajay_Patro_CV.pdf`, 2.5 yrs experience, ₹3.6 LPA / ₹10–13 LPA, 30 days notice), submit autonomously if public, or leave 100% prefilled in the queue if gated by SSO/CAPTCHA.
- **LinkedIn Limit Detection & Immediate Failover**: When LinkedIn displays *"We limit daily submissions to maintain quality and prevent bots"*, or when Easy Apply modals fail to open due to account caps, halt LinkedIn Easy Apply for the day and immediately shift to LinkedIn external job links, direct ATS portals, and Naukri.
- **Execution Order**:
  1. **Naukri First**: Process matching applications on Naukri.com across Data Engineering, Database Engineering, Python Backend, and PostGIS openings.
  2. **LinkedIn Dual Stream**: Process Easy Apply (`apply_linkedin`) up to cap (25) AND external job links (`apply_portal`) up to portal cap (40).
  3. **Direct Company ATS Portals**: Search direct company career portals (Ashby, Greenhouse, Lever, Workable). Never apply through 3rd-party spam aggregators; only consider direct company career portals.
- **Dedicated Tab Rule**: Always open dedicated tabs (`await context.newPage()`) and close them when finished.

## 7. Hard Reject Roles & Qualification Gates
- **Hard Reject List**: Land Surveyor, Drone Pilot, Surveyor, SDET, QA, Chaos Engineer, Frontend, PHP, Mainframe, Machine Learning Engineer, Data Scientist, AI Engineer, Deep Learning Engineer, ML Engineer, Research Scientist, DevOps Engineer, Cloud Engineer, QA Engineer, Test Engineer, and anything unrelated. Skip immediately with `skip_reason = 'hard_reject'`. Never shortlist or apply to these roles.
- **Experience Requirement Gate**:
  - Candidate truth: **2.5 Years Experience**, backed by exceptional depth in PostgreSQL, PostGIS, spatial schemas, query optimization, Apache Airflow ETL, and Python backend engineering.
  - **Permitted Experience Bracket**: Candidate explicitly authorizes targeting roles up to **5–6 years experience** based on qualification quality, technical depth, and hands-on production engineering delivery.
  - Reject only roles strictly requiring **> 6 years experience** (e.g., 7–10+ years, Principal, Director, VP) with `fit_score <= 30`, `status = 'skipped'`, `granular_status = 'skipped'`, and `skip_reason = 'seniority_beyond_6yr_limit'`.
  - Openly shortlist and apply to matching roles in the **0–6 years experience bracket**.
- **Record Inspection Boundary**: Each job vacancy and company record in `career.sqlite` must reflect a page actually visited, read, and evaluated in the browser. Never perform bulk inserts or ingest lists of uninspected job links. If 10 jobs are evaluated, visit each page and record each evaluated vacancy individually.

## 8. Seniority & LinkedIn Connect Search Filter Protocol
- **Mandatory `titleFreeText` Search Parameter**: For all connect searches on LinkedIn, ALWAYS include the `titleFreeText` filter in the search URL to restrict results to senior level people:
  - Parameter: `&titleFreeText=Senior%20OR%20Lead%20OR%20Manager%20OR%20Director%20OR%20Head%20OR%20Principal`
  - **Hard Gate**: NEVER search for connections without this filter.
- **LinkedIn Direct Dispatch Protocol**: Connection requests and personalized notes are dispatched directly by the agent via Playwright MCP using human-like delays, reserving the action in `actions` (`type = 'connect'`), navigating to the candidate profile, clicking Connect -> Add a note, filling the personalized note, and sending. Record status as `sent` in `messages` and `stage = 'requested'` in `contacts`.

## 9. Mandatory End-of-Run Reporting Protocol (Manual Applications & Mentorship Queues)
- **Explicit Manual Apply Queue**: After every single run or session, the agent MUST output a dedicated, clear report of all jobs that require manual application (`status = 'needs_input'` or `granular_status = 'awaiting_user_info' / 'awaiting_authorization'`).
  - **Required Details per Job**:
    - Job ID
    - Job Title
    - Company Name
    - Direct Application / Portal URL (direct ATS or external link, not generic aggregator)
    - Exact Blocker / Reason (e.g. requires candidate account login/SSO, visual CAPTCHA, complex candidate-specific screening questions)
- **Dedicated Mentorship & Personal Engagement Queue**:
  - After every run, explicitly report all contacts identified as Category C (contacts who offered mentorship, career guidance, advice, or interview preparation).
  - List Name, Company/Headline, LinkedIn thread link, and their specific offer/message.
  - These contacts are **Starred** on LinkedIn and reserved exclusively for Ajay's personal human interaction (no automated replies).
- **Hard Gate**: Never finish a run without presenting both the manual application queue and the mentorship queue so the candidate can immediately act.

## 11. Queued Job Opening & Prefill Protocol
- **Mandatory Prefill for ALL Queued Jobs**: Every single job placed into the manual application queue (`status = 'needs_input'` or `granular_status = 'awaiting_user_info' / 'awaiting_authorization'`) MUST be actively opened, inspected, and 100% prefilled by the agent before handing off to the candidate. Never leave a queued job without prefilling all permissible fields.
- **Dedicated Tab per Queued Role**: For jobs in the manual application queue (`granular_status = 'awaiting_user_info'`), open a dedicated browser tab (`await context.newPage()`) for each actionable job application URL.
- **Maximum Autonomous Prefill**: Wherever an external portal or ATS (such as Keka, Lever, Greenhouse, SmartRecruiters, Workable, or public web forms) permits input before authentication, autofill and prefill all candidate data (Full Name: Ajay Kumar Patro, Email: ajay789patro@outlook.com, Phone: +91-7894464335, Location: Nashik / India, LinkedIn URL, Experience: 2.5 Years, technical screening essays, CTC: ₹3.6 LPA / ₹10–13 LPA, Notice: 30 days, and attach `Ajay_Patro_CV.pdf`).
- **Actionable User Hand-Off**: For portals requiring candidate registration or SSO (e.g., Workday, Oracle Cloud HCM, iCIMS), navigate directly to the application sign-in / registration screen so the user can immediately log in and complete submission without searching for links.

## 12. Role Hierarchy & 8-Pillar Optimization Playbook Protocol
- **Role Priority Hierarchy**: **Data Engineer (DE) > Database Engineer (DBE) > Python Developer (PyE) > SDE Backend / Data Platform Engineer**.
- **GIS Status**: GIS/Geospatial is secondary domain evidence, NOT the primary filter or identity. Always prioritize general Data Engineering, Database Engineering, and Python backend engineering openings across all platforms.
- **Experience Truth**: 2.5 Years hands-on experience.
- **8 Pillars Alignment (Naukri, LinkedIn, Instahyre, Portals)**:
  1. *Research & Role Alignment*: Target roles: Data Engineer, Database Engineer, Python Backend Developer, ETL Developer, SDE Backend.
  2. *Resume Headline*: High-density keyword headline: `Data Engineer | Database Engineer | Python Backend Developer | PostgreSQL, SQL Query Optimization, Airflow, ETL Pipelines, FastAPI, OAuth2/OIDC | 2.5 Yrs Exp | Notice: 15-30 Days`.
  3. *Profile Summary*: "About Me" and "What I Build" structure with concrete technical evidence (Airflow pipelines, PostgreSQL/PostGIS architecture, GiST/B-tree indexing, query optimization, pgBackRest PITR, FastAPI backend, Keycloak/APISIX auth integration).
  4. *Key Skills*: Data Engineering, ETL, PostgreSQL, SQL Query Optimization, Apache Airflow, Python, PostGIS, FastAPI, Docker, OAuth2/OIDC, Keycloak, OpenFGA, APISIX.
  5. *Employment Framing*: Frame responsibilities to highlight backend ETL, data pipelines, schema optimization, and database architecture.
  6. *Projects & Career Evidence*: Present the automated Airflow ETL ingestion pipelines, vector tile API integration (APISIX + Keycloak + OpenFGA), and high-throughput PostgreSQL query optimization as primary proof points.
  7. *Career Profile Preferences*: Preferred Roles: Data Engineer, Database Engineer, Python Developer, SDE Backend, ETL Developer; Preferred Locations: Hyderabad, Bengaluru, Chennai, Remote; Salary: ₹10–13 LPA.
  8. *Basic Details & Availability*: 2.5 Years, 15–30 Days notice period (negotiable for early release).

## 13. Database Administration & Interaction Policy (Native SQLite CLI)
- **Primary Database Path**: `job-skill/data/career.sqlite` (relative to workspace root; single authoritative production database).
- **Executable**: `sqlite3` (native SQLite CLI in `PATH` on Linux/macOS, or `sqlite3.exe` on Windows).
- **Mandatory Database Interaction Rules**:
  1. Use the native `sqlite3` CLI (`sqlite3` on Linux/macOS, `sqlite3.exe` on Windows) for all routine agent-driven SQLite inspection and administration.
  2. Execute SQL directly through the native SQLite CLI.
  3. Use `.tables`, `.schema`, `SELECT`, `INSERT`, `UPDATE`, `DELETE`, and other native SQLite commands directly.
  4. Avoid creating temporary JavaScript or Python scripts for routine database queries.
  5. Do not create custom database wrappers when native SQLite CLI commands are sufficient.
  6. Use explicit transactions (`BEGIN TRANSACTION; ... COMMIT;`) for multi-step modifications.
  7. Verify all modifications using read-only `SELECT` queries.
  8. Preserve the production database and all existing records.
  9. Always verify that the target database exists at `job-skill/data/career.sqlite` before executing commands; never create accidental new database files.
  10. Report database errors explicitly rather than silently attempting alternative database files.

## 14. Guardian Operational Protocols (Markdown-Governed Architecture)
- **Unified 8-Topic Operational Architecture**:
  Per candidate directive, all search, outreach, and application channels are consolidated into 8 dedicated operational topics:
  1. **Topic 1: Job Boards (Naukri + LinkedIn Easy Apply + Indeed)**: Active high-speed native job board applications (`apply_naukri`: 35/day, `apply_linkedin`: 25/day, `apply_indeed`: 15/day). Indeed is an active primary board, NOT standby. Standby reserve boards: Instahyre (`apply_instahyre`: 15/day), Wellfound (`apply_wellfound`: 10/day), and secondary boards (Foundit, Hirist, Shine, iimjobs).
  2. **Topic 2: ATS Portals (Company Career Portals & LinkedIn External Job Links)**: Direct corporate ATS platforms (Ashby, Greenhouse, Lever, Workable) and external redirect links (`apply_portal`: 40/day).
  3. **Topic 3: Post-Based Job Mail**: Targeted email applications sent directly to recruiters/hiring teams from live hiring posts that request resumes via email (priority email track).
  4. **Topic 4: HR Cold Mail**: Proactive high-density cold emails sent to HR and Talent Acquisition leads at target tech firms via Outlook Webmail.
  5. **Topic 5: Connect People**: High-leverage LinkedIn connection requests sent to senior engineering decision-makers (`connect`: 60/day).
  6. **Topic 6: Inbound Communications (Dedicated Channel for LinkedIn Chat, Connection Inbound & Outlook Inbound Emails)**:
     - **Top Priority Always**: Dedicated exclusively to handling all incoming inbound communication across all channels.
     - Sweeps active LinkedIn message drawers, incoming connection requests with notes, and Outlook Webmail inbox for recruiter inquiries, screening questions, referral follow-ups, assessment links, and interview invitations.
     - Answers all pending questions directly and accurately in authentic human peer style before any new outbound actions are executed.
  7. **Topic 7: New Connection Outreach Dispatch (Dedicated Outbound Channel)**:
     - Dedicated solely to sending introductory/capabilities notes (`message`: 50/day) to newly connected members on LinkedIn.
     - Operates from the database boundary: tracks the last messaged contact in `career.sqlite` and continues systematically through newly connected members who have 0 prior messages.
  8. **Topic 8: Circle Back (Willing Referrers Monitoring & Re-Engagement)**:
     - Dedicated to tracking and re-engaging contacts who explicitly offered/agreed to refer the candidate, but for whom no active 0–3 / 1–3 / 2–4 year opening currently exists at their company.
     - **The Circle Back Agreement Protocol**:
       - When an employee or senior engineer indicates willingness to refer, but all active roles strictly require higher seniority (> 3–5 years), send an authentic human peer inquiry:
         *"is it ok if I circle back to you? I will keep an eye on open roles, and if anything relevant comes up that matches my profile, I'll reach back out to you for a referral if that works for you."*
       - **Trigger Condition**: If the contact responds with **YES of any kind** (e.g., *"Sure"*, *"Yes"*, *"Definitely"*, *"Feel free"*, *"Sounds good"*, *"Anytime"*, *"Sure thing"*, or any affirmative acknowledgment), immediately add them to **Topic 8: Circle Back** (`contacts.stage = 'agreed_to_refer'`).
       - Retain all referrer metadata, company details, and career portal link in `career.sqlite` (`research_notes`).
     - **LinkedIn Starred Identification**: When a contact agrees to refer or enters Circle Back, star their conversation in LinkedIn messaging so they remain highlighted under the Starred filter for instant visual reference.
     - **Profile Viewing Scope & Distinction**:
       - **Active Chat Exception**: When an active conversation thread is already open with a contact (e.g., they just messaged saying to check vacancies), opening their profile directly from the chat to identify their current company and headline is 100% permitted, natural, and expected.
       - **The Strict Prohibition (Periodic Audits Only)**: Do NOT visit, open, or inspect a contact's LinkedIn profile page (`/in/<slug>/`) during periodic **Topic 8: Circle Back** audits when months have elapsed without a conversation. Navigating to their profile out of the blue triggers an automatic "Ajay Patro viewed your profile" notification, which must be strictly avoided.
     - **Direct External Career Portal Audits**: Monitors the company's external career site / ATS (e.g., maersk.com/careers, greenhouse, lever, workday) directly in the background—completely outside of LinkedIn—for newly posted 0–6 year openings across Indian tech hubs.
     - **Re-Engagement & Human Approval Gate**: ONLY when a genuinely aligned role opens:
       1. Capture exact Job Requisition ID, Title, and Portal URL.
       2. Present the role to the candidate along with a drafted human peer-model LinkedIn message for explicit user approval.
       3. Upon candidate approval, reach back out in the existing LinkedIn chat thread to request the referral.

- **Grouped Command Execution Architecture (5 Operational Commands + Complete All)**:
  Per candidate directive, the 8 topics are triggered using 5 clear operational commands:
  1. `"Handle inbound communications"` (or `"handle inbound communications"` / `"run topic"`): Executes **Topic 6** (Inbound Communications across LinkedIn chat, incoming connection notes, and Outlook Webmail; top priority always; sweeps and handles all inbound inquiries; No Limit).
  2. `"run job apply"`: Executes **Topic 1 & Topic 2** (Job Boards: Naukri, LinkedIn Easy Apply, Indeed + ATS Portals & External Job Links).
  3. `"run connet"` (or `"run connect"`): Executes **Topic 5** (LinkedIn connection requests to senior engineering decision-makers; No Limit).
  4. `"run dispath messages and email"` (or `"run dispatch messages and email"`): Executes **Topic 7, Topic 3 & Topic 4** (Direct intro capabilities messages to newly connected members on LinkedIn from DB boundary + Targeted job posting emails & HR cold emails via Outlook; No Limit).
  5. `"circle back"` (or `"circle around"` / `"circle round"`): Executes **Topic 8** (Willing referrers monitoring on company career pages; checks for fresh 0–3 / 1–3 / 2–4 yr openings on company career sites without touching LinkedIn profiles; presents matches for candidate approval before dispatching).
  - General orchestration: `"complete all topic"` (or `"run all"`): Sequentially executes all operational commands (`Handle inbound communications` -> `run job apply` -> `run connet` -> `run dispath messages and email` -> `circle back`).
  - Monitoring: `status` reports current action counts, active queues, circle back referrers, and system state.

- **The "No Limit" Mandate for Topics 3 to 7 (Uncapped Outreach & Replies)**:
  Per candidate directive, **all daily limits are eliminated for Topics 3 through 7**:
  - **Topic 6 (Inbound Communications)**: **NO LIMIT** (100% of all incoming recruiter inquiries, referral chats, screening questions, assessment invites, and emails are answered).
  - **Topic 5 (Connect People)**: **NO LIMIT** (`cap_connect = 9999` in `settings`; send connection requests to all identified senior engineering decision-makers).
  - **Topic 7 (New Connection Outreach Dispatch)**: **NO LIMIT** (`cap_message = 9999` in `settings`; every newly connected member on LinkedIn receives an introductory capabilities note).
  - **Topic 3 & 4 (Post-Based Job Mail & HR Cold Mail)**: **NO LIMIT** (`cap_email = 9999` in `settings`; all matching post-based hiring leads and targeted HR leads are messaged).
  - **Topics 1 & 2 (Calibrated Application Caps Retained)**:
    - `apply_naukri`: **35 per day** (`cap_apply_naukri = 35`).
    - `apply_linkedin`: **25 per day** (`cap_apply_linkedin = 25`).
    - `apply_portal`: **40 per day** (`cap_apply_portal = 40`, direct ATS portal submissions and LinkedIn external links).
    - `apply_indeed`: **15 per day** (`cap_apply_indeed = 15`).
    - `apply_instahyre`: **15 per day** (`cap_apply_instahyre = 15`).
    - Secondary boards (`apply_foundit`, `apply_hirist`, `apply_iimjobs`, `apply_shine`, `apply_wellfound`): **10 per day each**.

- **Human Peer Chat Behaviour Protocol (LinkedIn Chat vs Formal Email)**:
  - **LinkedIn Chat Message Behaviour (Human Peer Model)**:
    - LinkedIn messaging is a direct 1-on-1 peer conversation, NOT a formal email letter.
    - Write like an authentic, professional peer engineer chatting on Slack or LinkedIn.
    - Keep messages concise, natural, and conversational (1 to 3 sentences).
    - Answer questions directly first (e.g. CTC, notice period, location) without unnecessary corporate preambles.
    - Do NOT dump formal resumes, long bulleted skill checklists, or email-style headers/footers into LinkedIn chat boxes.
    - ZERO EMOJIS: Maintain crisp, authentic, professional tone without emojis.
  - **Email Behaviour (Outlook Webmail)**:
    - Retain ultra-slim email structure: 1-line hook/context, 2-line technical overview (PostgreSQL/PostGIS, SQL optimization, Airflow ETL, Python backend), resume attached (`Ajay_Patro_CV.pdf`), and standard signature.

- **Referral Discovery & Multi-Location Investigation Protocol**:
  - When an employee or senior engineer at a target company offers to refer the candidate:
    1. **Identify Company & Full Indian Scope**:
       - Candidate is open to relocate anywhere in India (Bengaluru, Hyderabad, Chennai, Pune, Gurgaon/Delhi-NCR, Airoli/Mumbai, Remote).
       - Never restrict the search only to the city where the referrer works; evaluate all Indian locations of that company.
    2. **Exhaustive Career Page Audit**:
       - Scan the company's direct careers portal across all relevant technical domains (Software Engineering, Data Engineering, Database Engineering, Platform, Backend, Python, ETL, Business Intelligence / Analytics).
       - When hubs have 100+ or 200+ listings, audit all technical listings.
    3. **Experience & Technical Weighting**:
       - Compare requirements against candidate truth (2.5 years experience).
       - Target roles in the 0–3, 1–3, 2–4, or 3–5 year bracket where hands-on engineering skills align.
       - Discard / Do NOT request referral for senior/lead roles (5–8+, 7–10+ years, Principal, Architect) where internal ATS referral filters strictly reject sub-3 or sub-5 year applicants.
    4. **Actionable Resolution Paths**:
       - *Match Found*: Present the specific Job Requisition ID, exact Title, and Location, explaining technical alignment.
       - *No Match Found*: If all active openings strictly demand 3+ to 5+ years, honestly and respectfully inform the referrer that an exhaustive scan was completed, confirm that all active data roles currently require 3+ to 5+ years, thank them warmly for their offer, and propose: *"is it ok if I circle back to you? I will keep an eye on open roles, and if anything relevant comes up that matches my profile, I'll reach back out to you for a referral if that works for you."* If they reply with YES of any kind, transition the contact into **Topic 8: Circle Back** (`stage = 'agreed_to_refer'`), keep their metadata in `career.sqlite`, and monitor their company career site without ever visiting their LinkedIn profile.
    5. **Referral Message Approval Gate**:
       - Outbound referral responses require explicit candidate approval before dispatching.

- **Database-Boundary Message Dispatch Tracking Protocol**:
  - When dispatching new connection outreach (Topic 7):
    - Do NOT start re-checking from connection card #1 down every session.
    - Inspect `career.sqlite` to identify the boundary of the last contacted contact ID and already-contacted LinkedIn profile URLs.
    - Advance systematically through uncontacted connections whose `messages` record for `kind = 'first'` is 0.
- **Mandatory Action Reservation Protocol**:
  - Before initiating any external browser click or submission, the agent must reserve the action via SQL:
    ```sql
    INSERT INTO actions (type, ref_table, ref_id) VALUES ('apply_naukri', 'jobs', <job_id>);
    ```
  - If the insert succeeds, the reservation is confirmed. If rejected by trigger (`daily cap reached`), the agent must immediately halt that action category for the day.
- **Granular Application Status Lifecycle & Evidentiary Standard**:
  - `discovered` -> `shortlisted` -> `application_prepared` -> `submitted` -> `submission_confirmed`.
  - Blocked paths: `awaiting_user_info` (SSO/CAPTCHA), `awaiting_authorization` (outreach approval), `failed`, `rejected_or_closed`.
  - `submission_confirmed` requires recorded evidence in `submission_evidence` (confirmation screen message, reference ID, or dashboard entry). Never mark `submission_confirmed` without evidence.
- **Dynamic Job-Source Discovery**:
  - Dynamic discovery evaluates recruitment sources via the 5-factor model (Relevance, Freshness, Accessibility, Uniqueness, Listing Quality) stored in `sources` and `source_evaluations`.
  - Yield status transitions: `evaluating` -> `active` / `promoted` / `deprioritized` / `deprecated`.
- **Human Approval & Dispatch Requirements**:
  - `approval_mode = 'none'`: Standard outbound connection notes, recruiter cold emails, and new connection capabilities messages are dispatched directly upon generation, reserving the action in `actions` and updating `status = 'sent'`.
  - Referral follow-ups and custom candidate responses require user approval before dispatching.

## 15. Candidate Onboarding & Truth Profile Protocol
- **Configuration Schema & Templates**:
  - Pristine Schema Template: `job-skill/profile.template.json`.
  - Active Candidate Truth Profile: `job-skill/profile.json`.
- **Configured Candidate Dimensions**:
  1. *Identity & Contact*: Legal Full Name, Preferred First Name, Email, Phone Number, Calling Availability, Location, LinkedIn URL, Portfolio URL.
  2. *Compensation Truth*: Current CTC (₹3.6 LPA), Expected CTC Range (Min ₹10 – Target ₹13 LPA), Notice Period (30 days), Current Employer, Current Title.
  3. *Target Roles & Technical Stack*: Role hierarchy priority (DE > DBE > PyE), core technical skills (PostgreSQL, PostGIS, Airflow, FastAPI, Docker).
  4. *Locations & Relocation*: Primary target hubs (Hyderabad, Bengaluru, Chennai, Remote) and nationwide relocation budget evaluation protocol.
  5. *CV Asset*: Active PDF resume path in `job-skill/cv/Ajay_Patro_CV.pdf`.
  6. *Communication Templates*: Standardized outreach templates (`connect_note`, `recruiter_email`, and parameterized replies for notice, CTC, and location).
- **Synchronized Locations**:
  - When onboarding or updating candidate parameters, the agent must update:
    1. `job-skill/profile.json`
    2. `job-skill/data/career.sqlite` (`answers` table: current CTC, expected CTC, notice period, total experience)
    3. `AGENTS.md` (Sections 2, 3, 4, 12)

## 16. Operational Enforcement Boundaries & Technical Limitations
- **Markdown Is Policy, Not Technical Enforcement**:
  - Markdown instructions govern agent behavior and execution rules. They do NOT provide operating system-level process sandboxing or network traffic interception.
- **Technical Database Enforcements (SQLite Triggers & Constraints)**:
  - Daily action caps: Enforced by `trg_actions_cap` on the `actions` table.
  - Paused and cooldown states: Enforced by `trg_actions_paused`.
  - Blocklisted entities: Enforced by `trg_jobs_blocked`, `trg_contacts_blocked`, and `trg_leads_blocked`.
  - Closed contacts: Enforced by `trg_msg_closed`.
  - Locked answers: Enforced by `trg_answers_locked` and `trg_answers_nodelete`.
  - Deletion prevention: Enforced by `trg_nodelete_*` triggers across all core tables.
- **Agent-Governed Operational Policies (Non-Database Enforced)**:
  - The following rules rely on the AI agent strictly adhering to Markdown policies:
    1. Pausing between browser actions and introducing natural human jitter.
    2. Enforcing human approval gates before sending messages in `draft` status.
    3. Maintaining dedicated browser tabs and never hijacking existing user tabs.
    4. Reading full historical conversation transcripts before sending replies (Rule 5).
    5. Compiling and presenting the `needs_input` manual application queue at run completion.

## 17. Autonomous Job Search & Career Outreach Strategy Protocol
- **Agent Ownership Principle**:
  - The candidate owns their career truth (`profile.json`), target role priority, compensation boundaries, and explicit approvals.
  - The agent completely owns the execution: which boards to search, what queries to generate, which companies to investigate, which senior decision-makers to approach, and how to adapt search strategy.
  - The agent never asks the user for routine search directions or queries.
- **Autonomous Query Generation Matrix**:
  - Sourced from candidate target roles (DE > DBE > PyE > SDE Backend) and technical specializations:
    - *Data Engineering & ETL*: `Data Engineer Python PostgreSQL`, `Data Engineer Airflow ETL`, `Data Pipeline Engineer SQL`, `ETL Developer Airflow Python`, `Data Platform Engineer Python Airflow`, `Junior Data Engineer PostgreSQL`.
    - *Database Engineering*: `Database Engineer PostgreSQL`, `PostgreSQL Developer Query Optimization`, `Database Developer PostgreSQL PostGIS`, `SQL Performance Engineer`.
    - *Python Backend & Integration*: `Python Backend Developer FastAPI`, `Python Developer ETL Pipelines`, `Backend Engineer Python SQL Docker`, `SDE Backend Python SQL`, `Python Integration Engineer OAuth2 Keycloak`.
  - Target Hubs: Hyderabad, Bengaluru, Chennai, Remote, India.
  - Query Rotation: Dynamically alternate queries across boards to maintain high lead velocity and avoid stale search results.
- **Autonomous Referral & Outreach Protocol**:
  - When target companies are identified in job searches, the agent automatically identifies senior engineering managers, lead architects, and recruiters on LinkedIn (`titleFreeText=Senior%20OR%20Lead%20OR%20Manager%20OR%20Director%20OR%20Head%20OR%20Principal`).
  - Outreach messages are generated using candidate facts in `profile.json`, saved as `draft` in `messages`, and submitted to the user for one-click approval.
- **Autonomous Yield Optimization**:
  - If a particular board or query exhibits low yield or exhausted listings, the agent autonomously expands to alternative search permutations and adjacent ATS portals without stopping or asking the user what to search next.

## 18. Execution Concurrency & State Locking Protocol
- **Concurrency Control**:
  - Every autonomous execution task (vacancy discovery, application pipeline, inbox monitor, source evaluation) must check and acquire a lock in `execution_state`:
    ```sql
    UPDATE execution_state 
    SET is_running = 1, locked_at = strftime('%Y-%m-%dT%H:%M:%SZ','now'), locked_by = 'antigravity' 
    WHERE task_name = '<task>' AND is_running = 0;
    ```
  - If 0 rows updated, task is already running; abort to prevent overlapping execution.
- **Recovery from Interrupted Runs**:
  - If a task has `is_running = 1` but `locked_at` is older than 30 minutes, it is classified as crashed or interrupted. The lock is safely reset and recovery checkpoints from `checkpoint_data` are loaded.
- **Global Pause Check**:
  - Tasks check `SELECT value FROM settings WHERE key = 'paused';`. If `'1'`, halt immediately.

## 19. Pure AI Agent Operating Architecture (Zero Script-Based Automation)
- **Zero Script-Driven Intelligence**:
  - Absolutely NO custom JavaScript, Python, or PowerShell scripts for query generation, company discovery, scraping pipelines, vacancy scoring, or decision-making.
  - All strategic search decisions, page comprehension, suitability evaluation, and outreach drafting are made dynamically at runtime by the AI agent using LLM reasoning and native tools.
- **Three-Tier Architecture**:
  1. *Candidate Truth & Directives*: `job-skill/profile.json` (facts, constraints, compensation, notice period), `job-skill/cv/Ajay_Patro_CV.pdf`, and Markdown operational rules.
  2. *The AI Agent (Worker)*: Operates browser tools via Playwright MCP and the native command shell. Uses multimodal/text reasoning to interpret complex web pages and ATS forms.
  3. *Persistent Memory (SQLite)*: `job-skill/data/career.sqlite` tracks all discovered vacancies, investigated companies, evaluated sources, granular application states, and conversation history via the native `sqlite3` CLI.
- **Detached Execution Capability**:
  - The AI agent runtime can run interactively within Antigravity or autonomously outside it via the OpenAI Codex CLI (`codex exec` with native Playwright MCP and shell access).
  - Background scheduling triggers the agent CLI directly with operational prompts; no custom script middleman is permitted.

## 20. End-to-End Autonomous Multi-Tier Outreach & Application Loop Protocol ("Gold Standard Loop")
- **Standard Autonomous Execution Cycle**:
  The agent must execute this comprehensive multi-tier loop during every continuous or high-velocity run:
  1. **Tier 1: High-Velocity Direct Applications (50+ Target)**:
     - Uncapped volume targeting **50+ minimum daily applications** across target role hierarchy: **Data Engineer > Database Engineer > Python Developer**.
     - Openly target openings in the authorized **0–6 years experience bracket**.
     - Reserve action via SQLite CLI (`INSERT INTO actions (type, ref_table, ref_id) VALUES ('apply_naukri'|'apply_portal', 'jobs', <id>)`).
     - Submit applications via 1-click apply, interactive questionnaire chatbot answering (using candidate facts in `profile.json` and `answers` table), or portal link follow-through.
     - Record confirmed evidence in `jobs.submission_evidence` (HTTP 200/202 `multiApplyResp`, confirmation URL, reference number) and update `granular_status = 'submission_confirmed'`.
  2. **Tier 2: Social/LinkedIn Hiring Posts Scrape & Recruiter Cold Email Dispatch**:
     - Dynamically search LinkedIn content posts for active recruiter/hiring posts requesting resumes (`"share your resume"`, `"send your resume to"`, email addresses).
     - Extract recruiter contact details, company name, email address, and target role.
     - Reserve action in `actions` (`type = 'email'`) and register in `companies` and `contacts`.
     - Compose ultra-slim cold email strictly adhering to Rule 2 (ZERO emojis, 1-line hook, 2.5+ yrs hands-on PostgreSQL/PostGIS, Airflow ETL, Python backend, consistent signature, NO bulky CTC/Notice blocks).
     - Dispatch via Outlook Webmail on Tab 0:
       - Fill recipient into `div[aria-label="To"]` and click `button:has-text("Use this address: ...")` to resolve the chip and enable the Send button.
       - Fill subject into `input[aria-label="Subject"]`.
       - Fill body into `textarea.dFCbN`.
       - Click `button[aria-label="Attach file"]` and select recent file `Ajay_Patro_CV.pdf` (`button[role="menuitem"]:has-text("Ajay_Patro_CV.pdf") >> nth=0`) to attach without OS file picker modals.
       - Click `button[aria-label="Send"]`, verify dispatch in Sent Items, and update SQLite `messages.status = 'sent'`.
  3. **Tier 3: Senior Decision-Maker & Hiring Manager Outreach (Direct Dispatch)**:
     - Search LinkedIn people using the mandatory `titleFreeText` filter (`&titleFreeText=Senior%20OR%20Lead%20OR%20Manager%20OR%20Director%20OR%20Head%20OR%20Principal`).
     - Target Engineering Managers, Tech Leads, Directors of Engineering, and Talent Acquisition Leads in primary South hubs (Bengaluru, Hyderabad, Chennai).
     - Draft highly personalized connection notes highlighting relevant technical depth and leadership alignment.
     - Dispatch connection requests with personalized notes directly via the browser (reserving `type = 'connect'` in `actions`, navigating to profile, clicking Connect -> Add a note, submitting invitation, and updating `messages.status = 'sent'`).
  4. **Tier 4: Mandatory 100% Prefill for Queued Portal Applications (Rule 11)**:
     - Open any job requiring external authentication, SSO, or candidate review in a dedicated tab (`await context.newPage()`).
     - 100% prefill all candidate fields, contact details, work experience (2.5 years), compensation (₹3.6 LPA / ₹10–13 LPA), notice (30 days), and technical screening essay answers.
     - Keep tab open and present in the End-of-Run report for candidate 1-click submission.
  5. **Tier 5: Evidence-Backed Reporting**:
     - Compile and present the structured End-of-Run report with confirmed applications, sent cold emails, queued connection drafts, and prefilled tabs.



## 21. Full-Run Execution Protocol ("run" Command)

- **Trigger**: When the user says **"run"** (or "start", "go", "execute", "do a run", "complete all") with no further qualification, treat it as a command to execute the **complete end-to-end job search pipeline** until every board's daily cap is hit or all available matching jobs are exhausted — whichever comes first.
- **Macro-Batch Execution Architecture (Mandatory)**:
  - **Total System Daily Quota**: **315 actions/day** across all 13 categories (155 total job applications across 10 boards: 35 Naukri + 25 LinkedIn + 15 Instahyre + 15 Indeed + 15 Direct ATS Portals + 50 across 5 Secondary Boards at 10 each, plus 160 outreach actions: 60 Connects + 50 Messages + 50 Emails).
  - **Execution Density**: The agent MUST NOT execute small 1–2 action dribbles. The daily volume must be driven to completion in **high-throughput macro-batches** across platforms.
  - **Continuous In-Turn Loop**: In each turn, the agent loads multi-item result pages, extracts batches of 15–30 targets at a time, reserves database actions individually/cleanly as each inspected target is validated, and executes submissions/invitations in sequence across tabs and platforms without yielding back to the user until a major quota block is cleared or a platform limit/hard stop is hit.
- **Mandatory Run Order**:
  1. **Stage 1 — Inbox Sweep & Replies** (always first): Check LinkedIn Messages and connection request replies. For each unanswered explicit question, draft/send reply based on `approval_mode`. Do NOT message contacts at rest.
  2. **Stage 2 — Applications Batch** (boards in cap-remaining order, highest remaining first):
     - Naukri (`apply_naukri`, cap 35) [Active Primary]
     - LinkedIn Easy Apply (`apply_linkedin`, cap 25) [Active Primary]
     - Indeed (`apply_indeed`, cap 15) [Active Primary - NOT Standby]
     - LinkedIn External Job Links & Direct ATS Portals (`apply_portal`, cap 40) [Active Primary]
     - Standby / Reserve Boards: Instahyre (`apply_instahyre`, cap 15), Wellfound (`apply_wellfound`, cap 10), Foundit (`apply_foundit`, cap 10), Hirist (`apply_hirist`, cap 10), iimjobs (`apply_iimjobs`, cap 10), Shine (`apply_shine`, cap 10)
  3. **Stage 3 — LinkedIn Connects Batch** (`connect`, cap 60): Search with `titleFreeText` filter, extract multiple eligible senior decision-makers, and process connection requests in sequence before yielding.
  4. **Stage 4 — LinkedIn Messages Batch** (`message`, cap 50): Message `stage='connected'` contacts with no prior outbound message.
  5. **Stage 5 — Cold Email Batch** (`email`, cap 50): Draft/send recruiter cold emails from discovered hiring posts.
- **Cap Check Before Each Board**: Before starting a board or channel, query `SELECT COUNT(*) FROM actions WHERE type='<action_type>' AND date(created_at,'+330 minutes')=date('now','+330 minutes')` alongside `SELECT CAST(value AS INTEGER) FROM settings WHERE key='cap_<action_type>'`. If already at or above its configured cap, skip that category and move to the next — do not stop the run.
- **Trigger `trg_actions_cap` Is the Hard Stop**: If the DB trigger fires `daily cap reached`, that board is done for the day. Move on immediately.
- **Never Stop and Ask** mid-run for routine decisions: which query to use, which board to try next, whether to continue. The ONLY valid pause points are: (a) explicit blockers that cannot be automated (visual CAPTCHA requiring human solver, hard SSO login walls), (b) hitting all daily caps across all sources.
- **End-of-Run Report is Mandatory** (Rule 9): After all stages are exhausted, output the full summary: applies by board, connects sent, messages drafted, emails drafted, manual queue items with prefilled URLs and blockers.
- **Partial Runs are OK**: If the user says "run Naukri" or "run connects", execute only that stage/board to its cap, then produce the end-of-run report for that scope.

## 22. Referral Trigger & Company Careers Catalog Navigation Protocol
- **Trigger Condition**: When an in-network contact or hiring manager replies with an invitation to review openings (e.g., *"Please check our jobs page and share if you find related roles"* or *"Share job IDs you are interested in"*), immediately trigger this deep catalog navigation protocol.
- **Autonomous Company Careers Discovery & Role Benchmarking Flow**:
  1. **Direct Profile Inspection from Active Chat**: Open the contact's profile directly from the open message thread to retrieve their current company, business unit, and headline. (Active chat profile opening is standard human behavior; the prohibition against visiting profiles applies exclusively to background Circle Back audits months later).
  2. **Official Careers Portal Navigation**: Navigate to the company's authoritative website and open their primary Careers Portal / ATS (Workday, Greenhouse, Lever, Taleo, iCIMS, or custom career site) and LinkedIn jobs.
  3. **Comprehensive Career Sweep & Benchmarking**:
     - Perform a sweep of active openings across India (Bengaluru, Hyderabad, Chennai, Pune, Mumbai, Gurgaon/Delhi-NCR, Remote).
     - Benchmark each role against Candidate Truth: 2.5 years experience, PostgreSQL & PostGIS spatial architecture, GiST/B-tree indexing, query optimization, automated Airflow ETL pipelines, and Python backend services (targeting the 0–6 year bracket).
  4. **Location Volume & Title-Based Filtering (200+ Openings Rule)**:
     - If a target city/hub displays high volume (200+ total openings), immediately apply title-based search filters: `Data Engineer`, `Database Engineer`, `Python`, `PostgreSQL`, `Backend`, `ETL`.
     - Screen down to the top matching vacancies within candidate scope.
  5. **Resolution Paths (Match Found vs Circle Back Lead)**:
     - **Match Found**: Capture exact Job Title, Requisition ID, and direct URL. Dispatch an immediate human peer reply with the role details, explain 2-sentence technical alignment, attach `Ajay_Patro_CV.pdf`, and respectfully request the internal referral. Set `contacts.stage = 'links_sent'`.
     - **No Match Found (Convertible Circle Back Lead)**: If the contact is well-disposed and the *only reason* a referral cannot proceed right now is the lack of a suitable open role (e.g. all roles require >6 years, or no active data/backend roles), they are a prime **Circle Back Potential Lead**. Send the non-pushy professional bridge:
       *"thanks [Name]. is it ok if I circle back to you? I will keep an eye on open roles, and if anything relevant comes up that matches my profile, I'll reach back out to you for a referral if that works for you."*
       If they respond with YES of any kind, record under **Topic 8: Circle Back** (`contacts.stage = 'agreed_to_refer'`), star their thread on LinkedIn, and transition to REST.

## 23. Inbound Communications Operational Protocol (Execution of "Handle inbound communications")
- **Core Directive**: When the candidate invokes `"Handle inbound communications"` (or `"handle inbound communications"` / `"run topic"`), the agent executes **Topic 6: Inbound Communications** across all communication channels to sweep, inspect, and answer every incoming communication before any outbound action is taken.
- **Top-Priority Sweep Sequence**:
  1. **LinkedIn Message Hub & Active Chat Drawers**:
     - Inspect all active conversation threads and unread chat badges.
     - Read the entire conversation history from Turn 1 to the end before formulating any reply.
     - Apply Intent-Driven Conversational Classification Gate (4 Categories):
       - Category A (Immediate Active Referrer): If contact invites job links or vacancies (e.g. 'check portal/LinkedIn and let me know'), search company roles immediately, reply with exact Job Title, ID, link, and attached Ajay_Patro_CV.pdf for the referral; set contacts.stage = 'links_sent' and retain star.
       - Category B (Circle Back Potential Lead): If contact respectfully denies or defers due to no current openings ('no current openings', 'hiring for different profiles', 'will let you know if something opens'), send the non-pushy professional bridge asking permission to circle back. If YES, add to Topic 8: Circle Back (contacts.stage = 'agreed_to_refer'), star conversation, and transition to REST.
       - Category C (Mentorship / Overly Helpful): If contact offers guidance, career advice, or mentorship, star their conversation in LinkedIn messaging, do NOT send automated replies, and route to the Mentorship & Personal Engagement Queue for Ajay's direct interaction.
       - Category D (Terminal Rest): If contact shows hard disinterest or sends standalone emojis with no text, say a brief thanks or leave at terminal rest; do NOT reply. If already agreed to circle back, remain at REST.
     - For explicit inquiries (CTC, notice period, location, tech stack): formulate a concise 1–3 sentence peer reply adhering to Candidate Truth (₹3.6 LPA current, ₹10–13 LPA expected, 30 days notice, 2.5 yrs exp, open across India).
     - ZERO EMOJIS: strictly forbidden in all replies.
  2. **LinkedIn Inbound Connection Invitations**:
     - Check received invitations (`/mynetwork/invitation-manager/`) for recruiter notes or custom messages.
     - If a recruiter or hiring manager included a role inquiry or screening question, accept and respond directly via chat.
  3. **Outlook Webmail Inbound Sweep**:
     - Check `outlook.live.com` for new unread emails from recruiters, talent acquisition, interview schedulers, and automated test portals (e.g. HackerRank, Codility, TestGorilla).
     - For recruiter screening emails: reply using the ultra-slim email structure (1-line hook, 2-line technical depth in PostgreSQL/PostGIS & Python ETL, `Ajay_Patro_CV.pdf` attached, standard signature).
     - For interview invitations or assessment links: immediately record in `career.sqlite`, update the job/application record, and alert the candidate.
  4. **Naukri Recruiter Chat Inbound**:
     - Inspect Naukri inbox for incoming recruiter messages, shortlists, or call requests, and provide the candidate's verified contact details (+91-7894464335, ajay789patro@outlook.com) and notice period (30 days).
- **Database Tracking**:
  - Record each received message in `messages` with `direction = 'inbound'`.
  - Record the outbound response in `messages` with `direction = 'outbound'`, `status = 'sent'`.
  - Update `contacts.last_inbound_at` and `contacts.last_outbound_at`.
