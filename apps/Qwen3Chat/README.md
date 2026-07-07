# Qwen3 Chat

**A private ChatGPT in your pocket, with real-time token streaming**

<p align="center"><img src="../../res/screenshots/qwen_4b_ios.gif" width="240" alt="Qwen3 Chat demo"></p>

Runs entirely on the phone via `Qwen3-4B`, powered by [Melange](https://mlange.zetic.ai). No cloud, no data leaving the device.

## Why on-device

- 🔒 **Private.** Inference happens on the phone's NPU. Nothing is uploaded, so there is no cloud dataset to breach or audit.
- 💸 **$0 to run.** No cloud inference, no per-call bill, at any scale.
- ✈️ **Offline.** Works with no network, anywhere.

## Run it

1. Grab a free [Melange](https://mlange.zetic.ai) key (30 seconds, no card): Settings, then Personal Access Token.
2. From the repo root, run `./scripts/adapt_mlange_key.sh`.
3. Open `Android/` in Android Studio and run on a real device. Open `iOS/` in Xcode and run on a real device.

The app pulls its NPU-optimized weights on first launch, then runs fully offline.

## Details

| Model | Platforms | Runtime |
| :-- | :-- | :-- |
| [`Qwen3-4B`](https://mlange.zetic.ai/p/Qwen/Qwen3-4B) | Android, iOS | [Melange](https://mlange.zetic.ai) |

---

Part of [**Awesome On-Device AI Apps**](../../README.md), a collection of AI apps that run 100% on the phone. Want your own model on-device? [Melange](https://mlange.zetic.ai) converts it and hands you back a phone-ready build.
