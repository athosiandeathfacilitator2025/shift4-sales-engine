# Shift4 Sales Engine — Goals & Roadmap

## Primary Goal

Help a Shift4 Payments AU sales rep close more deals, faster, with less cognitive load during live calls — especially in the first 90 days on the job.

---

## Business Objectives

### Short term (now)
- [x] Industry-specific openers and use cases for 6 AU verticals
- [x] Battle cards vs 5 competitors (Square, Tyro, Zeller, Big 4, PayPal)
- [x] Objections library with rebuttals for 9 common objections
- [x] Challenger Sale framework embedded in every objection card
- [x] Tonality and technique guide per objection
- [x] Real-time Live Listen (keyword detection + ping-pong rebuttal cards)
- [x] Call logging with outcome, skill scores, and weighted performance
- [x] First-Call Close Rate tracking vs 60% target
- [x] Daily run rate dashboard with EOD projection
- [x] Pre-Call Planner (industry + checklist + opener)
- [x] BNA qualifying framework (7 questions with flags)
- [x] Lost lead re-engagement scripts and AIDA framework
- [x] Social proof (AU merchant testimonials)
- [x] CSV export for AppSheet
- [x] Supabase cloud persistence (optional)
- [x] Render.com deployment (public URL, any device)

### Medium term (v2 — next 60 days)
- [ ] **RBA surcharge-ban pitch evolution** — replace zero-fee pitch with: settlement speed, integrations, support, and merchant experience value props. Auto-detect if rep is pitching surcharging and suggest pivot language.
- [ ] **Objection difficulty rating** — let rep rate how hard each objection felt after logging; surface patterns in the Coaching tab
- [ ] **Call streak tracking** — consecutive wins/losses with streak notification (gamified)
- [ ] **Daily XP system** — points for calls logged, wins, challenge questions used, FCR above target; weekly leaderboard vs personal best
- [ ] **PingPong extended** — include Challenger Reframe text in the ping-pong panel, not just the rebuttal
- [ ] **Industry switcher in Live Listen** — let rep select the prospect's industry during a live call so Live Listen surfaces industry-specific watch-outs
- [ ] **Script builder** — combine BNA answers into a custom pitch script in one tap
- [ ] **Supabase table for Pre-Call plans** — persist pre-call notes so they're visible in Coaching history
- [ ] **Manager view** — read-only Supabase query that shows team FCR and run rate (when team scales)

### Long term (v3)
- [ ] **AI call coaching** — send transcript to Claude API, get a structured debrief with scores on each Challenger move
- [ ] **Prospecting intelligence** — paste a business name → get industry classification, estimated revenue, relevant hook, and suggested opener
- [ ] **Objection trend analysis** — most common objections by time of day, day of week, industry; surface coaching suggestions
- [ ] **Multi-user** — Supabase auth, per-rep call logs, manager dashboard
- [ ] **Mobile app** — Progressive Web App (PWA) wrapper so it installs on phone home screen and works offline

---

## Sales Performance Targets

| Metric | Target | Rationale |
|---|---|---|
| First-Call Close Rate | ≥ 60% | Industry benchmark for high-performing SMB payments reps |
| Daily calls logged | ≥ 40 | Volume required to hit pipeline targets |
| Average call weight | > 0.7 | Indicates calls progressing to close, not just dropping at gatekeeper |
| BNA completion rate | > 80% of conversations | Qualifying before pitching = higher conversion |
| Lost lead re-engagement | ≥ 1 per day | Old inbound is high-intent; don't leave it cold |

---

## Methodologies Embedded in the App

### Challenger Sale (Matthew Dixon)
- Every objection card has a Challenger Reframe and Challenge Questions
- The Challenger Mindset header teaches Teach → Tailor → Take Control
- Tonality guides train delivery, not just content
- Goal: reps who shape perspective, not just respond to it

### BNA → AIDA Flow
- BNA surfaces pain and qualifies budget/authority/need
- AIDA converts that pain into a structured close
- Both frameworks are in the app and designed to flow into each other

### Call Weighting
- Every call gets a weight score based on outcome (60%) and skill scores (40%)
- Forces reps to focus on quality, not just volume
- The Coaching tab surfaces average weight by industry to identify skill gaps

---

## Key Constraints

- **No build step** — must remain a single HTML file with CDN dependencies only. No webpack, no Vite, no npm packages beyond Express. This keeps it easy for non-developers to run and update.
- **No login required** — personal tool. Supabase anon access is intentional.
- **AU market first** — all data, scripts, and compliance references are Australian. Do not add generic/global content that dilutes the AU focus.
- **Mobile-first layout** — the rep uses this on their phone during calls. Every feature must work on a 375px screen.
- **Fast load** — CDN dependencies only, no heavy libraries. Keep it snappy on a mobile connection.

---

## Shift4 AU Context (Sales Strategy)

### Smartpay acquisition (2025)
Shift4 bought Smartpay for ~$180M, inheriting 40,000+ AU merchants. This gives:
- Instant brand recognition in AU hospitality and retail
- A reference base for social proof ("we already look after 40,000 AU businesses")
- An upgrade opportunity — Smartpay merchants on old hardware can be upgraded to PAX A920 Pro

### RBA surcharge ban (October 2026)
The Reserve Bank of Australia is banning consumer card surcharges. This affects the core "zero-cost EFTPOS" pitch:
- **Before October 2026:** Auto-surcharging is a powerful opener ("merchants pay $0 in card fees")
- **After October 2026:** The pitch must shift to: next-day cash flow, uptime reliability, integration quality, and local 24/7 support
- The app's objection cards and incentives tab should be updated as this date approaches

### Competitive landscape
- **Square:** SMB darling, great app, high fees, no negotiation
- **Tyro:** 2022 outage affected 35,000 businesses — use this as an uptime credibility anchor
- **Zeller:** Banking + payments bundle, targeting businesses that want to simplify banking; hard to compete on ecosystem
- **Big 4 Banks:** Trust and inertia are the main barriers; they're not price-competitive
- **PayPal/Zettle:** Online-first, weak in-person; easy to win against for physical merchants

---

## How to Work With This Project (for Claude)

When Joshua asks you to update or extend this app:

1. **Read `public/index.html` first** — all logic is there. Never assume what's in it.
2. **The data constants come first** — add new data (industries, objections, etc.) to the relevant constant array before touching the view components.
3. **Keep the single-file architecture** — do not split into multiple JS files or introduce a build step.
4. **Mobile layout is non-negotiable** — test every new UI component at 375px width in your mental model.
5. **The call logging flow is the most important UX** — Pre-Call Planner → Live Listen → Log Call → Coaching tab must always work end-to-end without friction.
6. **Supabase schema changes require a SQL migration** — if you add columns to `call_logs`, provide the `ALTER TABLE` statement for Joshua to run in the Supabase SQL Editor.
7. **Check the RBA surcharge ban date** — any new pitch content should reflect whether we're before or after October 2026.
