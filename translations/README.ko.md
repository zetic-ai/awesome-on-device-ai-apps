<p align="center">
  <a href="../README.md">English</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.ja.md">日本語</a> ·
  <b>한국어</b> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.zh.md">中文</a>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### 클라우드가 법적으로 담지 못하는 AI 기능을 출시하세요. 100% 폰에서 도는 앱 36개.

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**컴플라이언스 장벽 없음&nbsp; ·&nbsp; 규모와 무관하게 $0&nbsp; ·&nbsp; 데이터가 기기를 떠나지 않음&nbsp; ·&nbsp; 오프라인 동작**

<sub>💬 챗&nbsp; · &nbsp;🌐 번역&nbsp; · &nbsp;👁️ 비전&nbsp; · &nbsp;❤️ 헬스&nbsp; · &nbsp;🎙️ 음성&nbsp; · &nbsp;📈 예측</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ <a href="https://mlange.zetic.ai"><b>Melange</b></a>로 구동 — 온디바이스 NPU 런타임</sub>

</div>

<br/>

> ### 온디바이스는 기술 결정이 아니라 비즈니스 결정입니다.

여기 모든 앱은 모델을 폰 자체에서 실행합니다. 서버로 가는 게 아무것도 없죠. 그 사실 하나가 경제성을 다시 씁니다:

- 🛡️ **컴플라이언스 장벽 없음.** 사용자 데이터가 클라우드에 없다는 건 GDPR·HIPAA·데이터 레지던시 규제가 출시를 막지 않는다는 뜻입니다. 헬스·금융·엔터프라이즈 제품에 AI를 넣고, 실제로 과금하세요.
- 💸 **한계비용 $0.** 토큰당 요금도, 추론 서버도 없습니다. 사용자가 1명에서 1,000만 명으로 늘어도 마진이 유지됩니다.
- 🔒 **설계부터 프라이빗.** 기기를 떠나는 게 없으니 유출·침해·감사 대상이 될 클라우드 데이터셋 자체가 없습니다.
- ⚡ **즉각적이고 오프라인.** 네트워크 왕복 없이 폰 NPU에서 실행됩니다. 비행기 안, 지하철, 신호 없는 공장 현장에서도.

그리고 이건 스니펫이 아닙니다. 모든 폴더가 clone해서 실기기에서 바로 돌리는 완성된 앱입니다.

<br/>

## ⚡ 폰에서 하나 실행해보기

아무 앱이나 골라 clone하고 실기기에서 실행하세요. ML 셋업도, 모델 변환도, C++도 없습니다.

```bash
git clone https://github.com/zetic-ai/awesome-on-device-ai-apps.git
cd awesome-on-device-ai-apps

# A free key lets the app pull its NPU-optimized weights on first launch
# (30 seconds, no card): mlange.zetic.ai -> Settings -> Personal Access Token
./scripts/adapt_mlange_key.sh

# Open an app on a REAL device (the NPU isn't in the simulator):
#   Android:  apps/<AppName>/Android    in Android Studio
#   iOS:      apps/<AppName>/iOS        in Xcode
#   Flutter:  cd apps/<AppName>/Flutter && flutter run
```

<br/>

## 🗂️ 앱 목록

36개 앱 전체 카탈로그는 [영어 README](../README.md#-the-apps)에서 확인하세요 (앱별 모델·플랫폼·Melange 링크 포함).

<br/>

## 🧩 직접 만들기 — vibe-coding으로

Claude Code, Codex, Cursor는 웹 앱은 몇 분 만에 vibe-coding 해줍니다. 하지만 폰 NPU에서 모델을 돌리는 앱을 요청하면 멈춰버립니다. 온디바이스 배포는 그들이 할 줄 아는 일이 아니거든요.

바로 그 간극을 [**Melange**](https://mlange.zetic.ai)가 메웁니다. 지금 세상에서 온디바이스 AI를 가장 쉽게 구현하는 방법입니다. 이 리포의 모든 앱이 같은 방식으로 만들어졌습니다: Melange로 통합 코드를 생성해 붙여넣으면 끝. 여기 유즈케이스를 복사하면, 당신이 이미 쓰는 그 vibe-coding 루프 그대로 온디바이스 기능이 앱에 바로 들어갑니다.

기존 프로젝트에 넣는 건 약 3줄입니다:

**Android** (`build.gradle.kts`):
```kotlin
dependencies { implementation("com.zeticai.mlange:mlange:+") }
```
```kotlin
val model = ZeticMLangeModel(context = this, tokenKey = "YOUR_KEY", modelName = "Team_ZETIC/YOLO26")
val outputs = model.run(inputs)   // NPU-accelerated, on-device
```

**iOS** (Swift Package Manager → `https://github.com/zetic-ai/ZeticMLangeiOS.git`):
```swift
let model = try ZeticMLangeModel(tokenKey: "YOUR_KEY", name: "Team_ZETIC/YOLO26", version: 1)
let outputs = try model.run(inputs: inputs)
```

당신의 모델을 가져오세요: [Melange](https://mlange.zetic.ai)에 업로드하면 자동으로 변환·NPU 최적화하고, 몇 달간의 하드웨어 튜닝이 아니라 약 한 시간 만에 폰에서 바로 도는 빌드를 돌려줍니다.

<br/>

## 🤝 앱 기여하기

이 갤러리는 기여로 자랍니다. 기준은 단 하나의 질문입니다: **처음 보는 사람이 이걸 clone해서 실제로 쓸까?**

1. `apps/<YourApp>/`에 `Android/` 그리고/또는 `iOS/`로 앱을 넣으세요
2. `meta.json`(기존 앱 참고)과 `README.md`를 추가하세요
3. `python3 scripts/generate_catalog.py`를 실행해 카탈로그에 추가하세요
4. 실기기에서 도는 걸 증명하세요 (PR에 데모 GIF)

전체 가이드 → **[CONTRIBUTING.md](CONTRIBUTING.ko.md)**. 질문은 → [Discord](https://discord.gg/gqhDWfZbgU).

<br/>

## ⭐ 스타 히스토리

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

[ZETIC](https://zetic.ai)이 만들고 · [Melange](https://mlange.zetic.ai)로 구동됩니다

**폰 네이티브 AI 앱을 보고 _"잠깐, 이게 오프라인으로 돌아?"_ 싶었다면, ⭐ 눌러주세요. 다음 개발자가 이걸 발견하는 방법입니다.**

</div>

<br/>

## 📄 라이선스

앱 소스는 **Apache 2.0**입니다: 상업적이든 개인적이든 원하는 대로 쓰세요. Melange SDK 자체는 ZETIC [이용약관](https://zetic.ai/terms)을 따르는 독점 라이브러리입니다.
