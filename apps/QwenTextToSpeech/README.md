# Qwen TTS

**On-device text-to-speech with a custom voice, running the Qwen3-TTS pipeline on the NPU.**

Runs entirely on the phone via `Qwen3-TTS-0.6B`, powered by [Melange](https://mlange.zetic.ai). No cloud, no data leaving the device.

## Why on-device

- 🔒 **Private.** Inference happens on the phone's NPU. Nothing is uploaded, so there is no cloud dataset to breach or audit.
- 💸 **$0 to run.** No cloud inference, no per-call bill, at any scale.
- ✈️ **Offline.** Works with no network, anywhere.

## Run it

1. Grab a free [Melange](https://mlange.zetic.ai) key (30 seconds, no card): Settings, then Personal Access Token.
2. From the repo root, run `./scripts/adapt_mlange_key.sh`.
3. Open `iOS/` in Xcode and run on a real device.

The app pulls its NPU-optimized weights on first launch, then runs fully offline.

> **Platform note:** this demo currently ships the **iOS** build. The `Qwen3-TTS-0.6B` model runs on iOS, Android, and Flutter through Melange, so adding the Android and Flutter build is a small lift, not a rewrite. PRs welcome.

## Details

| Model | Platforms | Runtime |
| :-- | :-- | :-- |
| [`Qwen3-TTS-0.6B`](https://mlange.zetic.ai/p/jathin-zetic/qwen_tts06b_talker) | iOS | [Melange](https://mlange.zetic.ai) |

---

Part of [**Awesome On-Device AI Apps**](../../README.md), a collection of AI apps that run 100% on the phone. Want your own model on-device? [Melange](https://mlange.zetic.ai) converts it and hands you back a phone-ready build.
