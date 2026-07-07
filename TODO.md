# Maintainer TODO

Things the rebrand still needs that **can't be done from code alone** — they need a
human with a device, real credentials, or a judgment call. Grab one, do it, check it off.

> This is the team-facing punch list. The public story lives in `README.md`.

---

## 🔴 Blockers before we launch / go for GitHub Trending

- [ ] **Run every app on a real device.** No app ships in the catalog until someone
      has built and run it on physical hardware. Track pass/fail per app + device below.
- [ ] **Real benchmark numbers.** The README deliberately makes **no** speed/FPS/latency
      claims because none are measured. Add a per-app benchmark (device, latency/FPS,
      model size) once measured. Do **not** invent numbers.
- [ ] **Demo GIFs for the 8 apps that have none.** `meta.json` `demo` is `null` for:
      `TextAnonymizer`, `whisper-tiny`, `YOLO26`, `YOLOv8`, `MediaPipe-Face-Detection`,
      `MediaPipe-Face-Landmarker`, `FaceEmotionRecognition`, `YamNet`.
      Record on device → drop in `res/screenshots/` → set `demo` in that app's `meta.json`
      → `python3 scripts/generate_catalog.py`.
- [ ] **Verify every external link resolves:** Discord invite, all `mlange.zetic.ai`
      model pages, store links, `docs.zetic.ai`. (A link-check CI job is a nice-to-have.)
- [ ] **Confirm the Melange-key story.** Is there any app that runs with *no* key? If so,
      feature it as a zero-friction first run. If not, make sure the Quick Start key step
      reads as painless. This is our biggest funnel risk vs `awesome-llm-apps` ("no signup").

## 🟠 Structure / infra (decisions + setup)

- [ ] **Key-protection git filter.** Only the helper scripts were migrated. The clean
      filter (`mlange-key-clean`) from the old repo lived in `.git/` and was never tracked,
      so a fresh clone can't run it. Either (a) commit a real, tracked filter script +
      `.gitattributes`, or (b) rely on `scripts/setup_git_ignore_keys.sh` + the CI key scan.
      Pick one and document it.
- [ ] **CODEOWNERS.** `.github/CODEOWNERS` references `@zetic-ai/maintainers` — create that
      GitHub team (or swap in real usernames).
- [ ] **Repo social preview image** (Settings → General → Social preview), 1280×640. This is
      the image that shows when the repo is shared — big deal for a launch.
- [ ] **Hero/banner + logo asset** in `docs/assets/` if we want a branded header.
- [ ] **`extension/` submodule.** The old repo had a `zetic_mlange_ext` submodule; it was
      *not* migrated. Decide if any app needs it and wire it up, or confirm none do.
- [ ] **Verify `scripts/*.sh` still work from the new `scripts/` location** (they `find apps`
      relative to CWD — must be run from repo root, e.g. `./scripts/adapt_mlange_key.sh`).

## 🟡 Content accuracy (please double-check my inferences)

- [ ] **Audit every `meta.json`.** Taglines, model names, categories, and platform lists were
      inferred from the old README + folder contents. Correct anything wrong. Especially:
  - [ ] `Brew-AI-Notes` is marked **iOS-only** — confirm, or add Android.
  - [ ] `tencent_HY-MT` vs `translate-tencent_HY-MT` — two translator apps. Keep both, merge,
        or differentiate their taglines so they don't look like dupes.
  - [ ] Confirm each app's `melange` URL points at the right model page.
- [ ] **Per-app README pass.** Make sure each `apps/*/README.md` reflects the new brand
      (drop "SDK example" framing, keep it "an app you'd use").
- [ ] **Model licenses.** Confirm each underlying model permits redistribution/use and note it.

## 🟢 Growth (Phase 3 — the "insanely many apps" pipeline)

- [ ] **Port the ~20 open PRs** from `ZETIC_Melange_apps` into this repo (each becomes an
      `apps/<App>/` + `meta.json`): SiteGuard, PlateHawk, SkyScout, FundusGate, GradeVue,
      OraLens, ShelfSense, SayRight, CherryPad, VoxScribe, Qwen-TTS, MedASR, neutts, and more.
- [ ] **Bump the hero count** in `README.md` as apps land (currently "18+").
- [ ] **Launch plan:** set up the Star History chart baseline, write the HN / Reddit / X
      posts, line up the first wave of stars, submit to Trendshift.

---

### Device test matrix (fill in as you test)

| App | Android device | iOS device | Runs? | Notes |
| :-- | :-- | :-- | :--: | :-- |
| _example_ | Pixel 8 | iPhone 15 Pro | ✅ / ❌ | |
