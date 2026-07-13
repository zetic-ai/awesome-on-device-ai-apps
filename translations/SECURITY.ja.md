<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <a href="SECURITY.de.md">Deutsch</a> ·
  <a href="SECURITY.es.md">Español</a> ·
  <a href="SECURITY.fr.md">Français</a> ·
  <b>日本語</b> ·
  <a href="SECURITY.ko.md">한국어</a> ·
  <a href="SECURITY.pt.md">Português</a> ·
  <a href="SECURITY.zh.md">中文</a>
</p>

# セキュリティポリシー

## APIキーとシークレット

これらのアプリは、NPU最適化されたモデルの重みをストリーミングするために **Melange Personal Access Token** を使用します。そのトークンはシークレットです。

- **本物のキーを絶対にコミットしないでください。** コミットされるコードには常にプレースホルダー `YOUR_PERSONAL_ACCESS_TOKEN`(または `YOUR_MLANGE_KEY`)が入っていなければなりません。
- ローカルのキーは `./scripts/adapt_mlange_key.sh` で設定します。
- ローカルのキー変更をgitから除外するには `./scripts/setup_git_ignore_keys.sh` を使います(キーファイルを `skip-worktree` に設定)。
- いつでも `./scripts/restore_placeholder_keys.sh` でプレースホルダーに戻せます。
- 毎回のコミット前に、キーが漏れていないか確認してください:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

誤ってキーをコミットした場合: [Melangeダッシュボード](https://mlange.zetic.ai) で直ちに失効(revoke)させ、ローテーションしてください。

## プライバシーモデル

このリポのすべてのアプリは、推論を **オンデバイス** で実行します。カメラのフレーム、マイクの音声、テキストはローカルで処理され、スマホから出ない設計です。アプリをコントリビュートする場合はその約束を守ってください: あらゆるネットワーク呼び出しはアプリREADMEに明確に文書化する必要があります。

## 脆弱性の報告

セキュリティ上の問題を見つけましたか? 公開Issueは開か **ないで** ください。[Discord](https://discord.gg/gqhDWfZbgU) でメンテナーにDMするか、`security@zetic.ai` にメールしてください。できる限り早く対応します。
