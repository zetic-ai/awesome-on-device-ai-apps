<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <a href="SECURITY.de.md">Deutsch</a> ·
  <a href="SECURITY.es.md">Español</a> ·
  <a href="SECURITY.fr.md">Français</a> ·
  <a href="SECURITY.ja.md">日本語</a> ·
  <b>한국어</b> ·
  <a href="SECURITY.pt.md">Português</a> ·
  <a href="SECURITY.zh.md">中文</a>
</p>

# 보안 정책

## API 키 및 시크릿

이 앱들은 NPU 최적화 모델 가중치를 스트리밍하기 위해 **Melange Personal Access Token**을 사용합니다. 그 토큰은 시크릿입니다.

- **실제 키를 절대 커밋하지 마세요.** 커밋된 코드에는 항상 플레이스홀더 `YOUR_PERSONAL_ACCESS_TOKEN`(또는 `YOUR_MLANGE_KEY`)이 있어야 합니다.
- 로컬 키는 `./scripts/adapt_mlange_key.sh`로 설정하세요.
- 로컬 키 변경을 git에서 빼두려면 `./scripts/setup_git_ignore_keys.sh`를 쓰세요 (키 파일을 `skip-worktree`로 표시).
- 언제든 `./scripts/restore_placeholder_keys.sh`로 플레이스홀더로 되돌릴 수 있습니다.
- 매 커밋 전에 키가 새지 않았는지 확인하세요:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

실수로 키를 커밋했다면: [Melange 대시보드](https://mlange.zetic.ai)에서 즉시 폐기(revoke)하고 교체하세요.

## 프라이버시 모델

이 리포의 모든 앱은 추론을 **온디바이스**로 실행합니다. 카메라 프레임, 마이크 오디오, 텍스트는 로컬에서 처리되며 폰을 떠나도록 설계되지 않았습니다. 앱을 기여한다면 그 약속을 지켜주세요: 모든 네트워크 호출은 앱 README에 명확히 문서화되어야 합니다.

## 취약점 신고

보안 이슈를 발견하셨나요? 공개 이슈를 열지 **마세요**. [Discord](https://discord.gg/gqhDWfZbgU)에서 메인테이너에게 DM하거나 `security@zetic.ai`로 이메일 주세요. 최대한 빨리 답하겠습니다.
