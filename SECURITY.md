# Security Policy

## API keys & secrets

These apps use a **Melange Personal Access Token** to stream NPU-optimized model weights. That token is a secret.

- **Never commit a real key.** Committed code must always contain the placeholder `YOUR_PERSONAL_ACCESS_TOKEN` (or `YOUR_MLANGE_KEY`).
- Set your key locally with `./scripts/adapt_mlange_key.sh`.
- Keep local key edits out of git with `./scripts/setup_git_ignore_keys.sh` (marks key files `skip-worktree`).
- Reset files back to placeholders anytime with `./scripts/restore_placeholder_keys.sh`.
- Before every commit, verify no key leaked:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

If you accidentally commit a key: revoke it immediately in the [Melange dashboard](https://mlange.zetic.ai), then rotate.

## Privacy model

Every app in this repo runs inference **on-device**. Camera frames, microphone audio, and text are processed locally and are not designed to leave the phone. If you contribute an app, keep that promise — any network call must be clearly documented in the app README.

## Reporting a vulnerability

Found a security issue? Please **do not** open a public issue. Reach us on [Discord](https://discord.gg/gqhDWfZbgU) (DM a maintainer) or email `security@zetic.ai`. We'll respond as fast as we can.
