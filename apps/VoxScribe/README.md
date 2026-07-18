# VoxScribe

**Transcribes speech and labels who spoke, fully offline.**

Runs entirely on the phone via `pyannote + Whisper`, powered by [Melange](https://mlange.zetic.ai). No cloud, no data leaving the device.

## Why on-device

- 🔒 **Private.** Inference happens on the phone's NPU. Nothing is uploaded, so there is no cloud dataset to breach or audit.
- 💸 **$0 to run.** No cloud inference, no per-call bill, at any scale.
- ✈️ **Offline.** Works with no network, anywhere.

## Run it

1. Grab a free [Melange](https://mlange.zetic.ai) key (30 seconds, no card): Settings, then Personal Access Token.
2. From the repo root, run `./scripts/adapt_mlange_key.sh`.
3. Open `Flutter/` and run `flutter run` on a connected device.

The app pulls its NPU-optimized weights on first launch, then runs fully offline.

> **Platform note:** this ships as a Flutter app. iOS and Android are both **supportable** from one Flutter codebase via Melange, but the per-platform Melange wiring is not verified on both yet, so treat this as the Flutter build for now. PRs welcome.

## Details

| Model | Platforms | Runtime |
| :-- | :-- | :-- |
| [`pyannote + Whisper`](https://mlange.zetic.ai/p/ajayshah/VoxScribe-whisper-decoder) | Flutter | [Melange](https://mlange.zetic.ai) |

---

Part of [**Awesome On-Device AI Apps**](../../README.md), a collection of AI apps that run 100% on the phone. Want your own model on-device? [Melange](https://mlange.zetic.ai) converts it and hands you back a phone-ready build.
