# Maintainer TODO

Things the rebrand still needs that **can't be done from code alone** and they need a
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
- [ ] **CODEOWNERS.** `.github/CODEOWNERS` references `@zetic-ai/maintainers`, so create that
      GitHub team (or swap in real usernames).
- [ ] **Upload the social preview image.** The asset is ready at
      `docs/assets/social-preview.png` (1280x640; regenerate with
      `python3 docs/assets/make_social_preview.py`). It just needs uploading at
      Settings -> General -> Social preview (a repo setting, not a commit).
- [ ] **Hero/banner + logo asset** in `docs/assets/` if we want a branded header.
- [ ] **`extension/` submodule.** The old repo had a `zetic_mlange_ext` submodule; it was
      *not* migrated. Decide if any app needs it and wire it up, or confirm none do.
- [ ] **Verify `scripts/*.sh` still work from the new `scripts/` location** (they `find apps`
      relative to CWD, so must be run from repo root, e.g. `./scripts/adapt_mlange_key.sh`).
- [ ] **Repo weight: vendored SDK binaries.** GitHub warns on push: `Brew-AI-Notes` vendors
      the full `ZeticMLange.xcframework` (**73 MB**, over the 50 MB soft limit), and several apps
      commit `.framework`/`.dylib` binaries (esp. `FaceEmotionRecognition` UITests). `.git` is
      ~79 MB already and will only grow. Pick a fix and apply it (needs a device to re-verify
      builds afterward):
  - Prefer pulling the SDK via SPM/Gradle instead of vendoring it (matches the README's
    "Use it in your own app" instructions). Brew vendored it only to dodge a Simulator-slice
    issue; confirm whether that's still needed.
  - Or move large binaries to **Git LFS** (history rewrite; coordinate with the team first).

## 🟡 Content accuracy (please double-check my inferences)

- [ ] **Audit every `meta.json`.** Taglines, model names, categories, and platform lists were
      inferred from the old README + folder contents. Correct anything wrong. Especially:
  - [ ] `Brew-AI-Notes` is marked **iOS-only**; confirm, or add Android.
  - [ ] `tencent_HY-MT` vs `translate-tencent_HY-MT`: two translator apps. Keep both, merge,
        or differentiate their taglines so they don't look like dupes.
  - [ ] Confirm each app's `melange` URL points at the right model page.
- [ ] **Per-app README pass.** Make sure each `apps/*/README.md` reflects the new brand
      (drop "SDK example" framing, keep it "an app you'd use").
- [ ] **Model licenses.** Confirm each underlying model permits redistribution/use and note it.

## 🔴 Follow-ups from the PR-queue migration (18 apps just added)

- [ ] **REVOKE three leaked Melange tokens (dashboard).** Real tokens came in via PRs. They are
      now scrubbed from the working tree AND purged from all git history (history was rewritten
      and force-pushed), but they were public in the source PRs, so the live tokens must still be
      rotated in the Melange dashboard: `dev_24c61ecf...` (NeuTTS + PromptGuard),
      `dev_d786c1fd...` (YOLO26), `ztp_37418352...` (MedASR). Revocation is the only real fix.
- [ ] **License audit (DEFERRED, revisit at monetization).** Owner call: not a launch blocker
      right now because we are not charging yet and there is a free tier; fine for a demo/showcase.
      Revisit when we start monetizing, or if we ever tell users to ship these commercially, since
      model licenses like AGPL / CC-BY-NC bind the downstream shipper regardless of Melange's tier.
      Several migrated apps use commercial-use-restricted models; if it becomes relevant, swap the
      model, add a per-app license note, or stop featuring the app for the revenue story:
  - **AGPL-3.0** (Ultralytics YOLO; commercial use needs an Ultralytics license): SafetyPPEYOLO,
    VehiclePlateYOLO, AerialDetectYOLO, ShelfScanYOLO, Ultralytics_YOLOv26-Seg-Nano, plus the
    original YOLO26 and YOLOv8.
  - **CC-BY-NC / non-commercial / research-only**: DentalXrayDetect (CC-BY-NC-4.0),
    ShelfScanYOLO, SensorForecastTS (CC-BY-NC-4.0), VoxScribe, RetinaDRScreen (research-only).
  - (Details were in each app's `model_selection.md`, now removed but in git history.)
- [ ] **Drop ONNX, use Melange's native pt2 path.** The migrated Flutter apps bundle static-shape
      `.onnx` (the repo's heaviest non-vendored files: 43/37/17/12/11/6 MB). Melange ingests
      `torch.export` / `.pt2` directly, which is lighter and avoids the ONNX-export slowdown.
      Re-export those models via the pt2 path: smaller repo + faster inference + a stronger
      "fastest on-device" story. Pair with the Git-LFS / weight-hosting decision above.
- [ ] **These 18 apps came from UNMERGED PRs** (not yet reviewed/merged upstream). Treat them as
      unverified: build + run each on a device, confirm quality, and fix or drop any that fall
      below the "would a stranger use this?" bar.
- [x] **Fill in `melange` links** in the 18 new `meta.json` files. Done: pulled the exact
      model id each app loads via the SDK (`ajayshah/*`, `jathin-zetic/*`, `vaibhav-zetic/*`,
      `Steve/*`). Multi-model apps link their primary model. Confirm each page is public.
- [ ] **Demo GIFs** for the new apps (all `demo: null` except AI-Keyboard). Several ship input
      samples under `demo_images/`, but not a running-app GIF.
- [ ] **Flutter is now a first-class platform** (12 of the new apps are Flutter). The hero badge
      was updated to Android | iOS | Flutter; make sure docs/positioning reflect that.
- [ ] **Repo weight jumped** (~+464 MB of bundled model weights from the migration). Revisit the
      Git-LFS decision above with urgency now that it is real.

## 🌍 Translations

- [ ] **Native-speaker review of the README translations.** `translations/README.{de,es,fr,ja,ko,pt,zh}.md`
      were drafted in-house and should be proofread by a native speaker per language before launch.
- [x] **Translate the community docs** (README + CONTRIBUTING + SECURITY + CODE_OF_CONDUCT).
      Done: all 4 docs in 7 languages (28 files in `translations/`), language selectors on the
      English originals, and translated READMEs link to their translated CONTRIBUTING. Still
      pending: native-speaker proofreading (above).
- [ ] **Keep translations in sync.** They are static copies and will drift when the English README
      changes. Update them (or add a check) whenever the English original changes materially.
- Policy: English is the default/original (must stay Korean-free); `translations/` holds the
  localized copies. The CI Korean check excludes `translations/`.

## 🟢 Growth / launch

- [ ] **Launch:** execute the plan in [docs/LAUNCH.md](docs/LAUNCH.md) (Show HN + ready-to-use
      copy, channel timeline, honesty guardrails, pre-launch checklist). Blockers to clear first:
      revoke leaked keys, set the social preview image, device-test the apps you will feature.

---

### Device test matrix (fill in as you test)

| App | Android device | iOS device | Runs? | Notes |
| :-- | :-- | :-- | :--: | :-- |
| _example_ | Pixel 8 | iPhone 15 Pro | ✅ / ❌ | |
