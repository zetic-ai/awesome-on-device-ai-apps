# Voice Biomarker

**Speech-emotion + respiratory event detection (cough, wheeze) from mic audio**

<p align="center"><img src="../../res/screenshots/voice-biomarker1.gif" width="240" alt="Voice Biomarker demo"></p>

Runs entirely on the phone via `wav2vec2 · YAMNet`, powered by [Melange](https://mlange.zetic.ai). No cloud, no data leaving the device.

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
| [`wav2vec2 · YAMNet`](https://mlange.zetic.ai/p/realtonypark/Wav2Vec2-Base_Emotion-Recognition) | Android, iOS | [Melange](https://mlange.zetic.ai) |

---

Part of [**Awesome On-Device AI Apps**](../../README.md), a collection of AI apps that run 100% on the phone. Want your own model on-device? [Melange](https://mlange.zetic.ai) converts it and hands you back a phone-ready build.
