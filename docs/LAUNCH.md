# Launch Plan

Goal: land **GitHub Trending #1 (day)** and convert that spike into a durable base of
stars, contributors, and Melange signups.

This is a team playbook. It is intentionally not linked from the public README.

---

## 1. The bet

GitHub Trending ranks by **stars gained in a short window**, not total stars. So the
whole game is: drive a concentrated traffic spike from channels that already trust
you, into a repo whose first impression converts visitors to stars in under 10
seconds. The README is already tuned for that. This plan is about the spike.

**Success metrics**

| Metric | Floor | Target |
| :-- | :-- | :-- |
| Stars in first 48h | 500 | 2,000+ |
| Trending (day, any language) | top 10 | **#1** |
| Trending (Kotlin/Swift/Dart) | top 3 | #1 |
| Melange signups attributed | 100 | 500+ |
| Contributor PRs opened in week 1 | 3 | 15+ |

Pick the launch day once assets are green (see section 3). Best windows: **Tuesday to
Thursday, ~8am US Eastern** (HN and US devs waking up, full day of runway before the
daily trending cutoff).

## 2. Who we are talking to

Lead with the message that fits each audience. All roads point to the same repo.

- **Indie / mobile devs** (Android, iOS, Flutter): "clone a real on-device app and run it today."
- **Founders / PMs / builders**: "ship AI where the cloud legally can't, at $0 marginal cost."
- **Privacy / regulated-industry devs** (health, fintech, gov): "no data leaves the phone, no compliance wall."
- **Local-AI / on-device enthusiasts**: "36 apps, real NPU inference, not a benchmark repo."
- **The vibe-coding crowd** (the biggest and most timely audience): "your AI coding agent can't build on-device apps. Copy-paste from here and it can." This is the sharpest hook right now; lead with it on HN and X.

## 3. Pre-launch checklist (all green before we post)

Repo polish:
- [ ] **Social preview image** set (Settings, General, Social preview), 1280x640. This is the card every share renders. Non-negotiable.
- [ ] Repo **description** + **topics/tags**: `on-device-ai`, `llm`, `android`, `ios`, `flutter`, `npu`, `offline-ai`, `privacy`, `edge-ai`, `mobile-ai`.
- [ ] Repo **pinned** on the ZETIC org profile.
- [ ] **CI green** (catalog + Korean + key-leak checks passing).
- [ ] Every catalog link, demo GIF, and badge verified live.
- [ ] A few **`good first issue`** + **`help wanted`** issues opened (contributor on-ramp; also signals an active project).
- [ ] Star History chart renders (needs a nonzero baseline).
- [ ] Discord invite works and a maintainer is on call launch day.

Security (do this first, it is a launch-blocker):
- [ ] **Revoke the two leaked Melange tokens** from the migrated PRs (see TODO.md). A leaked key surfacing on launch day is the worst-case story.

Assets to prepare:
- [ ] One **hero GIF/video** (15 to 30s) cutting between 4 to 6 apps running on a real phone. This is the single most shareable asset.
- [ ] 4 to 6 standalone app GIFs for the X thread.
- [ ] Screenshot of the catalog for LinkedIn/Reddit.

## 4. Honesty guardrails (read before posting anything)

This repo is affiliated with ZETIC / Melange (a commercial product). That is fine, but
**undisclosed vendor promotion gets flamed on HN and Reddit and can tank the launch.**

- On HN and Reddit, **disclose the affiliation** plainly ("I work on Melange; this is our open-source app collection"). Transparency reads as confidence.
- **Never buy or fake stars.** Trending's anti-gaming will catch bursts of low-quality accounts, and one screenshot of it kills credibility permanently. Everything below is organic.
- Respect each subreddit's self-promotion rules; several ban direct repo links or require a ratio. When unsure, post value first and link in a comment.
- Reply to **every** comment in the first 6 hours, fast and humble. Engagement drives ranking on HN and Reddit.

## 5. Channels and ready-to-use copy

### Hacker News (the main event)

Post as **Show HN**. Title (keep it plain, no hype, no emoji):

> Show HN: 36 AI apps that run 100% on your phone (offline, no cloud)

First comment (you post it yourself, immediately):

> I work on Melange (on-device model deployment). We got tired of "on-device AI"
> repos that are just lists of papers and model links, so we built the opposite: a
> collection of 36 finished Android/iOS/Flutter apps where the model runs on the
> phone's NPU. Chat, translation, camera heart-rate, offline OCR, TTS, YOLO
> detectors, medical imaging, and more. Clone one and it runs on a real device.
>
> The reason we care about on-device beyond privacy: it sidesteps the cloud-data
> compliance wall (GDPR/HIPAA/residency) and costs $0 per inference, which is what
> makes AI shippable in health, finance, and enterprise products.
>
> One thing that surprised us building these: coding agents (Claude Code, Codex,
> Cursor) will happily vibe-code a web app but stall on "run this model on the
> phone's NPU," because that deployment step isn't something they know how to do.
> Every app here was built by generating the integration code with Melange and
> pasting it in, so you can copy a use case and drop the on-device feature straight
> into your own app.
>
> Apps are Apache-2.0. The Melange SDK that does the NPU conversion is our
> commercial product, so yes we have an angle here, but the apps are genuinely
> useful on their own. Happy to answer anything about the on-device stack.

Rules: submit, then post that comment, then stay in the thread. Do not resubmit if it
flops; try again another day with a different title.

### X / Twitter (thread)

Tweet 1, option A (the vibe-coding hook, recommended, + hero GIF):

> Claude Code and Cursor can vibe-code you a web app in minutes.
>
> Ask them to run a model on the phone's NPU and they freeze.
>
> We open-sourced 36 on-device AI apps that were built by pasting Melange-generated
> code. Copy a use case, the on-device feature is in your app. 🧵

Tweet 1, option B (the idle-NPU hook + hero GIF):

> Your phone has an NPU sitting idle while you pay a cloud API to do inference.
>
> We open-sourced 36 AI apps that run 100% on the phone. No cloud, no latency, no
> per-user cost, no compliance wall.
>
> Clone one, it runs today. 🧵

Tweets 2 to 6: one app per tweet, each with its GIF and one line (Qwen chat, offline
translator, camera heart-rate, CherryPad keyboard, offline OCR reader).

Final tweet: the repo link + "Apache-2.0, PRs welcome" + Discord.

Ask 2 to 3 colleagues with reach to quote-tweet, not bare-RT (quotes travel further).

### Reddit (tailored per sub, staggered over the launch day)

- **r/LocalLLaMA**: lead with on-device LLM (Qwen chat, CherryPad, TTS). This crowd loves genuinely-local inference.
- **r/androiddev** and **r/iOSProgramming**: lead with "real native apps you can clone," code-first, humble.
- **r/FlutterDev**: 12 of the apps are Flutter; lead with that.
- **r/SideProject** and **r/opensource**: the "we built a thing, it is free" framing.
- Avoid r/programming and r/MachineLearning for direct promo (strict rules, high flame risk).

Post value first (a short write-up of one interesting app or the on-device tradeoffs),
disclose affiliation, link in the body only where the sub allows it.

### LinkedIn (business angle)

Aim at founders/PMs. Lead with the compliance/revenue story:

> Cloud AI can't legally touch a lot of the most valuable use cases: patient data,
> financial records, anything with residency rules. On-device AI can, because the
> data never leaves the phone. We open-sourced 36 apps that show what that looks
> like in practice (health, fintech, privacy), all running on the phone's NPU.
> Apache-2.0.

### Newsletters and aggregators (submit day-of)

- TLDR, Console.dev, Changelog News, Pointer, Hacker Newsletter, Awesome newsletters.
- **Trendshift** submission (once trending starts, it compounds).
- Relevant Discord/Slack communities (Flutter, mobile dev, local-AI). Share, do not spam.

## 6. Launch-day timeline (all times local to the launch owner)

| Time | Action |
| :-- | :-- |
| T-24h | Final checklist pass. Social preview live. Colleagues briefed and standing by. |
| T-1h | Repo pinned, description/topics final, Discord staffed. |
| **T-0 (8am ET)** | Post **Show HN** + your first comment. |
| T+15m | X thread goes live. Colleagues quote-tweet. |
| T+30m | r/LocalLLaMA post. |
| T+1h to T+6h | Reddit posts staggered across subs. **Reply to every comment, everywhere.** |
| T+2h | LinkedIn post. |
| Midday | Submit to newsletters + Trendshift. |
| Evening | Post a "we are trending, thank you" update in the HN thread and on X to compound. |

## 7. After the spike (turn a day into a base)

- Ship a **new app every week** and post it (the "insanely many apps" velocity is the retention story). Announce each in Discord + X.
- Keep a visible **CHANGELOG** or pinned "recently added" list.
- Respond to every PR within 24h. Thank every contributor by name.
- Convert the star spike: a subtle, honest Melange CTA is already in the README. Track signups.
- Re-post the strongest single app to its niche community a week later (a second, smaller spike).

## 8. What could go wrong

- **Leaked key surfaces** in a migrated app. Mitigation: revoke before launch (section 3).
- **HN flags it as vendor spam.** Mitigation: Show HN framing + upfront disclosure + genuinely useful apps.
- **Unverified apps embarrass us.** Some migrated apps came from unmerged PRs and are not device-tested. Mitigation: device-test the ones you will feature; do not headline an app you have not run.
- **Repo weight** (~500MB) makes clone slow and looks unpolished. Mitigation: resolve the Git-LFS decision (TODO.md) before a big audience arrives.
