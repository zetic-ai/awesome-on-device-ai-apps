# Contributing

Thanks for helping build the best collection of **on-device AI apps** anywhere. The bar for every app here is one question:

> **Would a stranger clone this and actually use it?**

Not "does it demo a model." Not "does it compile." *Would someone use it.* If yes, we want it.

## Add an app in 4 steps

1. **Create the folder** `apps/<YourApp>/` with a real, runnable project:
   - `Android/`, a full Android Studio project (Kotlin), and/or
   - `iOS/`, a full Xcode project (Swift)
   - At least one platform must actually run on a device.

2. **Add `meta.json`** by copying one from an existing app and editing it. This is the single source of truth for the catalog:
   ```json
   {
     "name": "Your App",
     "slug": "YourApp",
     "category": "Language & Text | Vision | Health & Wellbeing | Audio | Forecasting",
     "tagline": "One line a user would repeat to a friend.",
     "model": "ModelName",
     "platforms": ["Android", "iOS"],
     "demo": "res/screenshots/your-demo.gif",
     "melange": "https://mlange.zetic.ai/p/.../..."
   }
   ```

3. **Write `apps/<YourApp>/README.md`** covering what it does, quick start, and a demo GIF. Put shared demo media in `res/screenshots/`.

4. **Regenerate the catalog and open a PR:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   CI checks the catalog is in sync, so don't skip this.

## Standards

- **It runs on a real device.** Simulators don't have the NPU. Prove it with a demo GIF in the PR.
- **No secrets.** Never commit a real Melange key. Keys stay as placeholders (`YOUR_PERSONAL_ACCESS_TOKEN`); use `./scripts/adapt_mlange_key.sh` locally and `./scripts/setup_git_ignore_keys.sh` to keep them out of git. See [SECURITY.md](SECURITY.md).
- **Consistent layout.** Match the folder shape of existing apps.
- **English only** in authored content: docs, code comments, UI chrome, and commit messages. (Functional i18n data is fine: a language's own endonym in a language picker, or language-specific demo strings in a translator/transcriber that actually supports that language.)
- **Model license.** Make sure the underlying model permits redistribution/use, and note it in the app README.

## Getting a Melange key

Apps stream NPU-optimized weights via [Melange](https://mlange.zetic.ai). Grab a free Personal Access Token (30s, no card) at **Settings → Personal Access Token**, then run `./scripts/adapt_mlange_key.sh`.

## Questions

Jump into [Discord](https://discord.gg/gqhDWfZbgU) or open an issue. We're happy to help you get an app across the line.
