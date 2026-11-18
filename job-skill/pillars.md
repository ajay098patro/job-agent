# Pillars of the Autonomous Career Engine

Governed by `AGENTS.md` and executed through the 8 consolidated operational Topics and 5 Grouped Commands (`Handle inbound communications`, `run job apply`, `run connet`, `run dispath messages and email`, `circle back`). All hard rules apply. All dates in the database are UTC; format in IST when reporting to the user.

---

## 1. Connect & Referral Sourcing (LinkedIn Direct Dispatch Protocol)

1. **Autonomous People & Referral Sourcing**:
   - The agent independently discovers hiring managers, engineering directors, and talent leads without requiring user prompt.
   - Sourcing targets 2nd-degree senior decision-makers in India or Remote matching keywords: `Data Engineer`, `Database Engineer`, `PostgreSQL`, `Python backend`, `ETL`, `Geospatial`.
   - **Mandatory Seniority Filter**: ALWAYS include the `titleFreeText` filter in the search URL:
     `&titleFreeText=Senior%20OR%20Lead%20OR%20Manager%20OR%20Director%20OR%20Head%20OR%20Principal`
   - Target company priority: Companies in `companies` catalog (lowest `priority` first), followed by independently discovered engineering firms.

2. **Seniority & Role Hard Gate**:
   - ONLY connect with contacts meeting at least one criterion:
     - Leadership titles: Lead, Senior, Staff, Principal, Head, Director, Manager, VP, President, Founder, CTO, Architect, Engineering Manager.
     - Recruiter / Talent Acquisition Specialist at a target tech company.
     - Senior technical specialist (5+ years demonstrable experience) at a target company.
   - NEVER connect with: Interns, freshers, junior analysts, trainees, associates with < 2 years experience, or peers at the candidate's level.

3. **Direct Message Dispatch Mode (`approval_mode = 'none'`)**:
   - Per candidate directive ("no review need to msg sending"), connection requests and personalized notes are dispatched directly by the agent upon generation without requiring manual review gates.
   - Deduplication: Normalise profile URL. Skip if exists in `contacts`, matches `blocklist`, or matches candidate's current employer in `profile.json`.

4. **Action Reservation & Dispatch Protocol**:
   - Reserve action: `INSERT INTO actions (type, ref_table, ref_id) VALUES ('connect', 'contacts', <contact_id>)`.
   - Record contact in `contacts` table (`stage = 'requested'`, with name, headline, company, location, `in_india`).
   - Generate tailored, professional connection note (max 300 chars, ZERO emojis, highlighting 2.5 yrs PostgreSQL, Airflow, and Python ETL experience).
   - Dispatch directly via Playwright MCP using human-like delays, record in `messages` (`kind = 'connect_note'`, `status = 'sent'`).

---

## 2. First Message (New Connection Outreach Dispatch - Topic 7)

1. **Target Selection from Database Boundary**:
   - Inspect `career.sqlite` to find the boundary of the last contacted contact ID.
   - Advance systematically through newly connected contacts (`stage = 'connected'`) that have 0 prior outbound messages (`kind = 'first'`).
2. **Transcript Verification**:
   - Inspect thread history from Turn 1 to the end. If an earlier message exists, record in `messages`, set `stage = 'approached'`, and do NOT duplicate.
3. **High-Density Personalization**:
   - Review contact's profile summary and engineering focus.
   - Compose outreach using candidate truth from `profile.json`:
     - 1-line hook/context.
     - Core technical evidence: 2.5+ years experience in PostgreSQL, PostGIS spatial indexing, Airflow ETL pipelines, FastAPI.
     - Zero emojis.
     - Standard signature.
4. **Direct Dispatch Protocol**:
   - Reserve action in `actions` (`type = 'message'`).
   - Dispatch directly via Playwright MCP, record `status = 'sent'` in `messages`, set `stage = 'approached'`, `last_outbound_at = strftime('%Y-%m-%dT%H:%M:%SZ','now')`.

---

## 3. Inbox Sweep, Replies & Intent-Driven Conversational Classification (Topic 6)

1. **Inbox Sweep & Priority**:
   - Inbound communications is always top priority. Sweep LinkedIn message drawers, incoming connection notes, and Outlook Webmail.
2. **Mandatory Full Transcript Inspection**:
   - Read entire historical conversation transcript from Turn 1 to the end before formulating any reply.
3. **Intent-Driven Conversational Classification Gate (4 Categories)**:
   - **Category A: Immediate Active Referrer**: If contact invites job links or vacancies, immediately audit company openings, reply with exact Job Title, ID, link, and attached `Ajay_Patro_CV.pdf` for referral (`contacts.stage = 'links_sent'`).
   - **Category B: Circle Back Potential Lead**: If contact politely declines due to lack of immediate openings, send the non-pushy professional bridge asking permission to circle back. If YES, add to Topic 8: Circle Back (`contacts.stage = 'agreed_to_refer'`), star conversation, and transition to REST.
   - **Category C: Mentorship / Overly Helpful**: If contact offers guidance, career advice, or mentorship, star their conversation in LinkedIn messaging, do NOT send automated replies, and route to the Mentorship & Personal Engagement Queue for Ajay's direct interaction.
   - **Category D: Terminal Rest**: If contact shows hard disinterest or sends standalone emojis with no text, say a brief thanks or leave at terminal rest; do NOT reply. If already agreed to circle back, remain at REST.
4. **Actionable Technical Inquiries**:
   - Formulate concise 1–3 sentence peer replies adhering strictly to Candidate Truth (₹3.6 LPA current, ₹10–13 LPA expected, 30 days notice, 2.5 yrs exp, open across India). ZERO EMOJIS.

---

## 4. Discover (Dynamic Job Discovery & Qualification Gates - Topic 1 & 2)

1. **Autonomous Source Navigation**:
   - Active platforms: Naukri (`apply_naukri`: 35/day), LinkedIn Easy Apply (`apply_linkedin`: 25/day), Indeed (`apply_indeed`: 15/day), and ATS Portals & External Job Links (`apply_portal`: 40/day).
   - Target roles: Data Engineer, Database Engineer, Python Backend Developer, ETL Developer, PostgreSQL Developer.
   - Hubs: Hyderabad, Bengaluru, Chennai, Remote, and all India hubs.

2. **Qualification & Seniority Gates**:
   - **Hard Reject Filter**: Skip immediately with `skip_reason = 'hard_reject'` for: Land Surveyor, Drone Pilot, Surveyor, SDET, QA, Chaos Engineer, Frontend, PHP, Mainframe, Machine Learning Engineer, Data Scientist, DevOps Engineer, Cloud Engineer, QA Engineer, Test Engineer.
   - **Authorized Experience Bracket (0–6 Years)**:
     - Candidate truth: **2.5 Years Experience**, authorized to target up to **5–6 years** based on production engineering depth.
     - Reject only roles strictly requiring **> 6 years experience** (e.g. 7–10+ years, Principal, Director, VP) with fit_score <= 30, `status = 'skipped'`, `granular_status = 'skipped'`, and `skip_reason = 'seniority_beyond_6yr_limit'`.
     - Openly shortlist and apply to matching roles in the **0–6 years bracket**.

3. **Multi-Platform Application Routes**:
   - `apply_portal`: Direct corporate ATS links (Ashby, Greenhouse, Lever, Workable) and LinkedIn external redirect links.
   - `apply_naukri`: High-volume Indian tech/database postings.
   - `apply_linkedin`: LinkedIn Easy Apply up to daily cap (25/day).
   - `apply_indeed`: Primary board applications up to daily cap (15/day).

---

## 5. Apply & Queued Job Prefill Protocol

1. **Dual-Route Application Mandate**:
   - Process both LinkedIn Easy Apply and external job link openings (`apply_portal`).
   - If LinkedIn Easy Apply hits daily caps, immediately failover to external links and Naukri.

2. **Mandatory 100% Autonomous Prefill for Queued Jobs**:
   - Every job requiring manual application (`status = 'needs_input'` or `granular_status = 'awaiting_user_info'`) must be actively opened in a dedicated browser tab and 100% prefilled before handing off to the candidate:
     - Full Name: Ajay Kumar Patro
     - Email: ajay789patro@outlook.com
     - Phone: +91-7894464335
     - Location: Nashik / India
     - Current CTC: ₹3.6 LPA / Expected CTC: ₹10–13 LPA
     - Notice Period: 30 days
     - Experience: 2.5 Years
     - CV: `job-skill/cv/Ajay_Patro_CV.pdf` attached.

3. **End-of-Run Reporting**:
   - Output both the **Manual Applications Queue** and the **Mentorship & Personal Engagement Queue** so the candidate can immediately act.
