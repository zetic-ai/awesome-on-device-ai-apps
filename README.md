<div align="center">

# 🧠 Awesome On-Device AI Apps

### AI in your pocket — 18+ real apps that run 100% on your phone

<img src="res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**No cloud&nbsp; ·&nbsp; No latency&nbsp; ·&nbsp; No API bills&nbsp; ·&nbsp; Runs offline**

<sub>💬 Chat&nbsp; · &nbsp;🌐 Translate&nbsp; · &nbsp;👁️ Vision&nbsp; · &nbsp;❤️ Health&nbsp; · &nbsp;🎙️ Voice&nbsp; · &nbsp;📈 Forecasting</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](LICENSE)

[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84.svg?style=flat-square)](.)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](CONTRIBUTING.md)
[![Discord](https://img.shields.io/badge/Discord-Join%20Us-7289da.svg?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/gqhDWfZbgU)

</div>

<br/>

> ### Not a link farm. Not a paper list. Not "SDK examples."
> **Every folder here is a finished app that runs on a real device — today.**

- 📱 **Real apps, not links** — native Android & iOS you clone and run, not a bibliography.
- 🔒 **Actually on-device** — the model runs on the phone's NPU. Nothing leaves the device.
- 💸 **$0 to run, forever** — no per-token API bill, no server, no rate limit.
- ✈️ **Offline by default** — works in airplane mode, on the subway, off the grid.

*Think `awesome-llm-apps`, but it runs in your pocket — offline, on the NPU, for $0.*

<br/>

## ⚡ Ship one in an hour

```bash
# 1. Clone
git clone https://github.com/zetic-ai/awesome-on-device-ai-apps.git
cd awesome-on-device-ai-apps

# 2. Get a free key (30s, no credit card) — the NPU engine streams model weights on first launch
#    https://mlange.zetic.ai  →  Settings  →  Personal Access Token
./scripts/adapt_mlange_key.sh

# 3. Open an app and run it on a REAL device (the NPU isn't in the simulator)
#    Android →  apps/<AppName>/Android   in Android Studio
#    iOS     →  apps/<AppName>/iOS       in Xcode
```

No model conversion, no C++, no hardware SDK spelunking. Pick a folder, hit Run.

<br/>

## 🗂️ The apps

> Auto-generated from each app's `meta.json`. Run `python3 scripts/generate_catalog.py` after adding one.

<!-- CATALOG:START -->

**Jump to:** 💬 [Language & Text](#cat-language-text) · 👁️ [Vision](#cat-vision) · ❤️ [Health & Wellbeing](#cat-health-wellbeing) · 🔊 [Audio](#cat-audio) · 📈 [Forecasting](#cat-forecasting)

<a id="cat-language-text"></a>

### 💬 Language & Text

| App | What it does | Model | Platforms | Try it |
| :-- | :-- | :-- | :-- | :-- |
| [**Brew — AI Notes**](apps/Brew-AI-Notes) | Records, transcribes & summarizes meetings, then lets you ask anything. Granola, but fully private. | `Gemma-4-E2B` | `iOS` | [Model ↗](https://mlange.zetic.ai/p/changgeun/gemma-4-E2B-it) |
| [**Grammar Fixer**](apps/t5_base_grammar_correction) | Real-time grammar correction as you type | `T5-base` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/Team_ZETIC/t5-base-grammar-correction) |
| [**HY-MT Translator**](apps/tencent_HY-MT) | Streaming offline machine translation with instant language swap | `Tencent HY-MT` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/vaibhav-zetic/tencent_HY-MT) |
| [**Offline Translator**](apps/translate-tencent_HY-MT) | Translate by text, voice, or camera/OCR — real-time, instant language swap, zero signal needed | `Tencent HY-MT` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/vaibhav-zetic/tencent_HY-MT) |
| [**Qwen3 Chat**](apps/Qwen3Chat) | A private ChatGPT in your pocket — full LLM chat with real-time token streaming | `Qwen3-4B` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/Qwen/Qwen3-4B) |
| [**Text Anonymizer**](apps/TextAnonymizer) | Auto-detects & masks PII (names, emails, phones) before any data moves | `tanaos-anonymizer-v1` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/Steve/text-anonymizer-v1) |
| [**Whisper ASR**](apps/whisper-tiny) | High-accuracy speech-to-text, fully offline | `Whisper Tiny` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/OpenAI/whisper-tiny-decoder) |

<a id="cat-vision"></a>

### 👁️ Vision

| App | What it does | Model | Platforms | Try it |
| :-- | :-- | :-- | :-- | :-- |
| [**Emotion Recognition**](apps/FaceEmotionRecognition) | Real-time facial emotion from the camera | `Emo-AffectNet` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/ElenaRyumina/FaceEmotionRecognition) |
| [**Face Detection**](apps/MediaPipe-Face-Detection) | Ultra-fast selfie-range face detection | `BlazeFace` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/google/MediaPipe-Face-Detection) |
| [**Face Landmarker**](apps/MediaPipe-Face-Landmarker) | 468-point face mesh tracking | `MediaPipe` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/google/MediaPipe-Face-Landmark) |
| [**YOLO26**](apps/YOLO26) | Next-gen NMS-free object detection | `YOLO26` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/Team_ZETIC/YOLO26) |
| [**YOLOv8**](apps/YOLOv8) | Real-time object detection & tracking in milliseconds | `YOLOv8n` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/Ultralytics/YOLOv8n) |

<a id="cat-health-wellbeing"></a>

### ❤️ Health & Wellbeing

| App | What it does | Model | Platforms | Try it |
| :-- | :-- | :-- | :-- | :-- |
| [**Camera Vitals**](apps/Camera-Vitals) | Contactless heart-rate from the front camera — frames never leave the phone | `EfficientPhys-rPPG` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/realtonypark/EfficientPhys-rPPG_camera_vitals) |
| [**Skin Classifier**](apps/Skin-Image-Classification) | On-device skin-lesion classification with severity-aware guidance (non-diagnostic) | `Skin-Cancer ViT` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/realtonypark/Skin_Cancer-Image_Classification) |
| [**Voice Biomarker**](apps/Voice-Biomarker) | Speech-emotion + respiratory event detection (cough, wheeze) from mic audio | `wav2vec2 · YAMNet` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/realtonypark/Wav2Vec2-Base_Emotion-Recognition) |
| [**Wellbeing Screener**](apps/multimodal-screener) | Fuses live face- and voice-emotion into an explainable mood check-in | `wav2vec2 · Emo-AffectNet` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/realtonypark/Wav2Vec2-Base_Emotion-Recognition) |

<a id="cat-audio"></a>

### 🔊 Audio

| App | What it does | Model | Platforms | Try it |
| :-- | :-- | :-- | :-- | :-- |
| [**YamNet**](apps/YamNet) | Classifies environmental sounds & audio events | `YAMNet` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/google/Sound%20Classification%28YAMNET%29) |

<a id="cat-forecasting"></a>

### 📈 Forecasting

| App | What it does | Model | Platforms | Try it |
| :-- | :-- | :-- | :-- | :-- |
| [**Chronos Forecast**](apps/ChronosTimeSeries) | Probabilistic time-series forecasting with CSV import & interactive charts | `Chronos-Bolt` | `Android` `iOS` | [Model ↗](https://mlange.zetic.ai/p/Team_ZETIC/Chronos-balt-tiny) |

<!-- CATALOG:END -->

<br/>

## 🧩 Use it in your own app

Like what you see? Dropping on-device inference into your own project is ~3 lines.

**Android** — `build.gradle.kts`:
```kotlin
dependencies { implementation("com.zeticai.mlange:mlange:+") }
```
```kotlin
val model = ZeticMLangeModel(context = this, tokenKey = "YOUR_KEY", modelName = "Team_ZETIC/YOLO26")
val outputs = model.run(inputs)   // NPU-accelerated, on-device
```

**iOS** — Swift Package Manager → `https://github.com/zetic-ai/ZeticMLangeiOS.git`:
```swift
let model = try ZeticMLangeModel(tokenKey: "YOUR_KEY", name: "Team_ZETIC/YOLO26", version: 1)
let outputs = try model.run(inputs: inputs)
```

Want your *own* model on-device? Upload it to [Melange](https://mlange.zetic.ai) — it converts & NPU-optimizes automatically and hands you back code.

<br/>

## 🤝 Contribute an app

This gallery grows by contribution, and the bar is one question: **would a stranger clone this and actually use it?**

1. Drop your app in `apps/<YourApp>/` with `Android/` and/or `iOS/`
2. Add a `meta.json` (see any existing app) and a `README.md`
3. Run `python3 scripts/generate_catalog.py` to add it to the catalog
4. Prove it runs on a real device (demo GIF in the PR)

Full guide → **[CONTRIBUTING.md](CONTRIBUTING.md)**. Questions → [Discord](https://discord.gg/gqhDWfZbgU).

<br/>

## ⭐ Star history

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

Built by [ZETIC](https://zetic.ai) · Powered by [Melange](https://mlange.zetic.ai)

[![Contributors](https://contrib.rocks/image?repo=zetic-ai/awesome-on-device-ai-apps)](https://github.com/zetic-ai/awesome-on-device-ai-apps/graphs/contributors)

**If a phone-native AI app made you go _"wait, that runs offline?"_ — ⭐ star it. It's how the next dev finds it.**

</div>

<br/>

## 📄 License

App source is **Apache 2.0** — use it commercially or privately, however you like. The Melange SDK itself is a proprietary library under the ZETIC [Terms of Service](https://zetic.ai/terms).

<!-- ───────────────────────────────────────────────────────────────────────────
     MAINTAINER TODO — things Claude can't do; teammates please fill in.
     Kept as an HTML comment so it doesn't render on GitHub. See TODO.md for the
     tracked, checkbox version.
     ─────────────────────────────────────────────────────────────────────────── -->
