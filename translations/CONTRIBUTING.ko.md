<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <a href="CONTRIBUTING.de.md">Deutsch</a> ·
  <a href="CONTRIBUTING.es.md">Español</a> ·
  <a href="CONTRIBUTING.fr.md">Français</a> ·
  <a href="CONTRIBUTING.ja.md">日本語</a> ·
  <b>한국어</b> ·
  <a href="CONTRIBUTING.pt.md">Português</a> ·
  <a href="CONTRIBUTING.zh.md">中文</a>
</p>

# 기여하기

세상에서 가장 좋은 **온디바이스 AI 앱** 모음을 함께 만들어 주셔서 감사합니다. 여기 모든 앱의 기준은 단 하나의 질문입니다:

> **처음 보는 사람이 이걸 clone해서 실제로 쓸까?**

"모델을 데모하는가"가 아닙니다. "빌드가 되는가"도 아닙니다. *누군가 이걸 쓸까* 입니다. 그렇다면, 우린 원합니다.

## 4단계로 앱 추가하기

1. **폴더 생성** `apps/<YourApp>/` — 실제로 실행되는 프로젝트로:
   - `Android/` — 완전한 Android Studio 프로젝트(Kotlin), 그리고/또는
   - `iOS/` — 완전한 Xcode 프로젝트(Swift)
   - 최소 한 플랫폼은 실기기에서 실제로 돌아야 합니다.

2. **`meta.json` 추가** — 기존 앱에서 하나 복사해 수정하세요. 카탈로그의 단일 진실 원천입니다:
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

3. **`apps/<YourApp>/README.md` 작성** — 무엇을 하는지, 빠른 시작, 데모 GIF를 담으세요. 공용 데모 미디어는 `res/screenshots/`에 두세요.

4. **카탈로그 재생성 후 PR 열기:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   CI가 카탈로그 동기화를 검사하니 이 단계를 건너뛰지 마세요.

## 기준

- **실기기에서 돈다.** 시뮬레이터엔 NPU가 없습니다. PR에 데모 GIF로 증명하세요.
- **시크릿 금지.** 실제 Melange 키를 절대 커밋하지 마세요. 키는 플레이스홀더(`YOUR_PERSONAL_ACCESS_TOKEN`)로 두고, 로컬에선 `./scripts/adapt_mlange_key.sh`를, git에서 빼두려면 `./scripts/setup_git_ignore_keys.sh`를 쓰세요. [SECURITY.ko.md](SECURITY.ko.md) 참고.
- **일관된 구조.** 기존 앱의 폴더 형태를 따르세요.
- **기여하는 앱 콘텐츠는 영어로** (앱 README, 코드 주석, UI 문구, 커밋 메시지). 영어가 기본이며, 리포 레벨 문서는 `translations/`에 번역본도 제공됩니다. 기능적 i18n 데이터는 괜찮습니다: 언어 선택기의 네이티브 언어명, 또는 해당 언어를 실제 지원하는 번역기/전사 앱의 언어별 데모 문자열.
- **모델 라이선스.** 기반 모델이 재배포/사용을 허용하는지 확인하고, 앱 README에 명시하세요.

## Melange 키 받기

앱은 [Melange](https://mlange.zetic.ai)를 통해 NPU 최적화 가중치를 스트리밍합니다. **Settings → Personal Access Token**에서 무료 토큰(30초, 카드 불필요)을 받고 `./scripts/adapt_mlange_key.sh`를 실행하세요.

## 질문

[Discord](https://discord.gg/gqhDWfZbgU)에 들르거나 이슈를 열어주세요. 앱을 완성하는 데 기꺼이 돕겠습니다.
