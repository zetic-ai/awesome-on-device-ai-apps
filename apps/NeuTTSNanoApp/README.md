# NeuTTS Nano

**On-device text-to-speech with voice cloning, via a three-stage NeuTTS Nano pipeline.**

- **Model:** `NeuTTS Nano`
- **Platforms:** iOS
- **Runs:** 100% on-device, powered by [Melange](https://mlange.zetic.ai)

## Quick start

1. Get a free Melange key at [mlange.zetic.ai](https://mlange.zetic.ai) (Settings then Personal Access Token).
2. From the repo root, run `./scripts/adapt_mlange_key.sh`.
3. Open `iOS/` and run it on a real device.

Inference runs entirely on the phone's NPU. Nothing leaves the device.

See the repo [contributing guide](../../CONTRIBUTING.md) for the app conventions.
