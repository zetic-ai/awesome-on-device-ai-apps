# SkyScout

**Real-time aerial and drone object detection across 10 VisDrone classes, live on-device.**

- **Model:** `YOLOv8s (VisDrone)`
- **Platforms:** Flutter
- **Runs:** 100% on-device, powered by [Melange](https://mlange.zetic.ai)

## Quick start

1. Get a free Melange key at [mlange.zetic.ai](https://mlange.zetic.ai) (Settings then Personal Access Token).
2. From the repo root, run `./scripts/adapt_mlange_key.sh`.
3. Open `Flutter/` and `flutter run` on a real device.

Inference runs entirely on the phone's NPU. Nothing leaves the device.

See the repo [contributing guide](../../CONTRIBUTING.md) for the app conventions.
