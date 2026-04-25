# Shift4 Sales Engine — Project Context & Instruction Manual

## What This Is

A standalone sales intelligence web app built for a Shift4 Payments sales rep operating in the Australian market. It runs locally (no cloud account needed) or can be deployed to Render.com with Supabase for cloud call logging.

**Stack:** React 18 (CDN, no build step) + Express.js + Supabase (optional) + Babel Standalone  
**Port:** 4200  
**File:** Everything is in `public/index.html` — one self-contained file.  
**Run locally:** Double-click `LAUNCH.bat` or `node server.js`

---

## Business Goals

1. **Win more deals, faster** — give the rep instant access to industry-specific openers, objection rebuttals, and competitive counter-scripts during live calls
2. **Track performance against targets** — log every call with outcome, skills scores, and stage; coach against a 60% first-call-close target and daily run rate
3. **Apply Challenger Sale methodology** — teach reps to reframe, not just respond; embed challenge questions into every objection card
4. **Work on any device** — mobile-first layout, usable on a phone during a call
5. **Cloud persistence** — call logs sync to Supabase so data survives across devices and sessions

---

## Architecture

```
payment-sales-engine/
  public/
    index.html      ← Full React SPA (Babel, CDN React 18, no build)
  server.js         ← Express static server, injects Supabase env vars at serve time
  package.json      ← express only, no other npm deps
  LAUNCH.bat        ← Windows double-click launcher (opens Chrome at localhost:4200)
  .gitignore
```

**Supabase integration:** `server.js` injects `window.SUPABASE_URL` and `window.SUPABASE_KEY` into the HTML at serve time. The client-side code initialises the Supabase JS client if those vars are present; falls back to localStorage if not.

**Supabase table schema:**
```sql
create table call_logs (
  id bigint primary key,
  time timestamptz,
  outcome text,
  stage_reached text,
  objection_id text,
  industry_id text,
  call_type text,
  is_first_call boolean,
  opener_score int,
  confidence_score int,
  rapport_score int,
  notes text,
  weight numeric,
  created_at timestamptz default now()
);
alter table call_logs enable row level security;
create policy "anon_all" on call_logs for all to anon using (true) with check (true);
```

---

## Tabs & Features

### 1. Industries
6 Australian verticals, each with:
- Industry name, icon, target customer, annual revenue range, expected call time
- Opening hook (what to say first)
- Use case (why Shift4 specifically wins here)
- Reconciliation watch-out (accounting headache to raise)
- Rejection reasons + pivot suggestions
- Walk-away criteria
- Buyer signals

**Verticals:** Hospitality, Retail, Health & Beauty, Trades & Services, Professional Services, Healthcare

### 2. Battle Cards
Competitor comparisons vs Square, Tyro, Zeller, Big 4 Banks, PayPal/Zettle. Each card has:
- Summary, strengths/weaknesses
- Counter-script (exact words to use)
- Win when / Lose to conditions

### 3. Objections (Challenger Sale)
9 common objections, each with:
- Stage badge (Early Call / Re-Engagement / Mid Call / Close)
- Technique badge — colour-coded sales technique (Pattern Interrupt, Feel/Felt/Found, ROI Bridge, etc.)
- Tonality guide — how to deliver it (pace, energy, posture)
- What's really happening (reframe for the rep's mindset)
- Rebuttal (exact script)
- Do NOT say (common mistakes)
- Challenger Reframe — a teaching insight that shifts the prospect's worldview
- Challenge Questions — 4 tappable prompts that challenge the prospect's assumptions (tap to copy)
- Re-engaging question

**CHALLENGER MINDSET header card:**
- Teach / Tailor / Take Control framework
- 5 universal challenge questions (tappable)

**Objections covered:**
- Not interested
- Happy with current provider
- Surcharge ban coming (RBA Oct 2026)
- Locked into contract
- Need to speak to accountant/partner
- Already shopped around
- Need to think about it
- Equipment change is too disruptive
- Rates don't look better

### 4. Incentives
Shift4 value propositions:
- Auto-surcharging (zero-cost EFTPOS)
- Shift4Shop (free e-commerce)
- Next-Day Settlement
- No Lock-in Contracts
- 24/7 AU Support

### 5. BNA (Business Needs Analysis)
7 qualifying questions in order:
- Current payment provider
- Monthly bill / effective rate
- Terminal count and type
- POS system
- Average ticket size
- Annual turnover
- Trading days

Each question has: why to ask, green flags, red flags, follow-up question, listen-for cues.

### 6. Lost Leads
Re-engagement toolkit:
- Scripts for leads aged <3 months, 3-6 months, 6+ months
- Why they fell off (pattern diagnosis)
- AIDA framework (Attention → Interest → Desire → Action)
- On-Brand consistency rules

### 7. Coaching (Call Log + Run Rate)
**Run Rate Card:**
- Editable daily call target (persists in localStorage)
- Live projected EOD call count (based on 9am–5pm workday)
- FCR (First-Call Close Rate) bar with 60% target marker
- Colour: green ≥60%, amber 40-59%, red <40%

**Call log table:** All logged calls with time, outcome, stage, objection, scores, weight

**Industry breakdown:** FCR and avg weight per industry

**Intervention logic:**
- 3+ "Not Interested" in a row → opens objection card for that ID
- 2+ "No Decision Maker" → suggests BNA before next call
- FCR drops below 40% → flags Challenger Sale review

### 8. Social Proof
5 AU merchant testimonials tagged by industry and situation.

### 9. Quick Facts
Credibility anchors + CSV export for AppSheet/Google Sheets.

---

## Live Listen Panel (floating, bottom-left)

Captures audio from another browser tab (softphone) via `getDisplayMedia`. Never records or sends audio anywhere — analysis only.

**Features:**
- Audio level visualiser (green/amber/blue bar)
- Keyword detection → objection alert (last 3 alerts shown)
- Buying signal detection
- Mic transcription (en-AU, continuous)
- Grade Call → pre-fills log modal with detected objection + transcript snippet
- Call timer

**Ping-Pong Mode (🏓 toggle):**
- Shows "CUSTOMER SAYS" (objection) and "YOU SAY" (rebuttal) stacked
- Technique badge + tonality hint inline
- ◀ / ▶ to manually cycle all 9 objections
- Auto-jumps to detected objection when keyword fires

---

## Pre-Call Planner (floating button, bottom-right)

Before dialling, the rep selects:
- Industry (dropdown)
- Inbound or outbound
- 5-item checklist (statement pulled, opener ready, decision maker confirmed, etc.)
- Free-text opener field

On submit → pre-fills the log modal with industry + call type after the call ends.

---

## Log Call Modal (floating button, bottom-right)

Fields:
- Outcome: Won / Lost / Callback / No Answer / Gatekeeper
- Call type: Inbound / Outbound toggle
- First-contact toggle ("First ever contact with this prospect?")
- Industry dropdown (pre-filled from Pre-Call Planner if used)
- Stage reached
- Objection encountered (dropdown)
- Opener / Confidence / Rapport scores (1-5 sliders)
- Notes (free text)

**Call weight formula:** `(outcomeBase × 0.6) + (avgSkillScore/3 × 2 × 0.4)`  
Where outcomeBase: Won=1.0, Callback=0.6, Lost=0.3, No Answer=0.1, Gatekeeper=0.2

---

## Supabase + Render Deployment

**Render setup:**
- Build: `npm install`
- Start: `node server.js`
- Env vars: `SUPABASE_URL`, `SUPABASE_KEY`

**Behaviour by environment:**

| Scenario | Storage |
|---|---|
| Local, no env vars | localStorage only |
| Local, env vars set | Supabase + localStorage cache |
| Render deployment | Supabase + localStorage cache |
| First cloud-connected load with existing local data | Auto-migrates localStorage → Supabase |

---

## Key Shift4 AU Context

- Acquired Smartpay (AU/NZ) in 2025 for ~$180M — inherited 40,000+ AU merchants
- Core hardware: PAX A920 Pro
- Key strength: auto-surcharging (zero-cost EFTPOS model)
- **CRITICAL — RBA ban:** Consumer card surcharges banned from October 2026. Sales pitch must evolve from "zero fees" to settlement speed, uptime, integrations, support, and merchant experience.
- Competitors: Square (SMB darling), Tyro (2022 outage, hospitality/health focus), Zeller (banking bundle), Big 4 Banks (trust + inertia), PayPal/Zettle (online-first)

---

## Sales Methodology

**Challenger Sale (primary framework):**
1. **Teach** — lead with an insight the prospect hasn't heard
2. **Tailor** — connect the insight to their specific pain
3. **Take Control** — guide the conversation, don't just respond

**BNA → AIDA flow:**
- Qualify with BNA (7 questions) → build desire with AIDA → close with assumptive or urgency-based language

**Tonality principles (embedded per objection):**
- Pattern Interrupt: drop pace, let silence work
- Feel/Felt/Found: match energy before shifting it
- ROI Bridge: anchor on cost of inaction, not product price
- Authority Pivot: be more informed than the prospect

---

## Working With This Codebase

All app logic is in `public/index.html`. Structure:
1. **CSS** (lines ~1–26)
2. **Data constants** — INDUSTRIES, BATTLE_CARDS, OBJECTIONS, BNA_QUESTIONS, LOST_LEADS_DATA, BUYING_SIGNALS, DANGER_KEYWORDS, CHALLENGER_MINDSET, TECHNIQUE_MAP
3. **Supabase helpers** — `fetchCallLog()`, `persistCall()`
4. **Shared UI components** — Card, Label, SearchBar, useLocalStorage
5. **View components** — IndustriesView, BattleCardsView, ObjectionsView, IncentivesView, BNAView, LostLeadsView, CoachingView, SocialProofView, QuickFactsView
6. **Live Listen** — LiveListenPanel, DANGER_KEYWORDS, BUYING_SIGNALS
7. **Modals** — FeedbackModal (log call), PreCallModal
8. **App** — main component, tab routing, floating buttons

When adding features: edit the data constants first, then the view component. Keep everything in the single HTML file. No build step — refresh browser to see changes.
