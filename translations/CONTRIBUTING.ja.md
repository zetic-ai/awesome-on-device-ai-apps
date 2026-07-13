<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <a href="CONTRIBUTING.de.md">Deutsch</a> ·
  <a href="CONTRIBUTING.es.md">Español</a> ·
  <a href="CONTRIBUTING.fr.md">Français</a> ·
  <b>日本語</b> ·
  <a href="CONTRIBUTING.ko.md">한국어</a> ·
  <a href="CONTRIBUTING.pt.md">Português</a> ·
  <a href="CONTRIBUTING.zh.md">中文</a>
</p>

# コントリビュート

世界一の**オンデバイスAIアプリ**コレクションづくりにご協力ありがとうございます。ここにあるすべてのアプリの基準は、たった一つの問いです:

> **見知らぬ人がこれをcloneして実際に使うか?**

「モデルをデモするか」ではありません。「ビルドが通るか」でもありません。*誰かが使うか*です。そうなら、私たちは歓迎します。

## 4ステップでアプリを追加

1. **フォルダを作る** `apps/<YourApp>/` — 実際に動くプロジェクトとして:
   - `Android/` — 完全なAndroid Studioプロジェクト(Kotlin)、および/または
   - `iOS/` — 完全なXcodeプロジェクト(Swift)
   - 少なくとも一つのプラットフォームが実機で実際に動くこと。

2. **`meta.json` を追加** — 既存アプリから一つコピーして編集します。カタログの唯一の情報源です:
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

3. **`apps/<YourApp>/README.md` を書く** — 何をするか、クイックスタート、デモGIFを含めます。共有デモメディアは `res/screenshots/` に置きます。

4. **カタログを再生成してPRを開く:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   CIがカタログの同期をチェックするので、この手順は飛ばさないでください。

## 基準

- **実機で動く。** シミュレーターにはNPUがありません。PRにデモGIFで証明してください。
- **シークレット厳禁。** 本物のMelangeキーを絶対にコミットしないでください。キーはプレースホルダー(`YOUR_PERSONAL_ACCESS_TOKEN`)のままにし、ローカルでは `./scripts/adapt_mlange_key.sh` を、gitから除外するには `./scripts/setup_git_ignore_keys.sh` を使ってください。[SECURITY.ja.md](SECURITY.ja.md) を参照。
- **一貫したレイアウト。** 既存アプリのフォルダ構成に合わせてください。
- **コントリビュートするアプリのコンテンツは英語で**(アプリREADME、コードコメント、UI文言、コミットメッセージ)。英語がデフォルトで、リポレベルの文書は `translations/` に翻訳版も用意されています。機能的なi18nデータは問題ありません: 言語選択のネイティブ言語名や、その言語を実際にサポートする翻訳・書き起こしアプリの言語別デモ文字列。
- **モデルライセンス。** ベースモデルが再配布・利用を許可しているか確認し、アプリREADMEに明記してください。

## Melangeキーの取得

アプリは [Melange](https://mlange.zetic.ai) を通じてNPU最適化された重みをストリーミングします。**Settings → Personal Access Token** で無料トークン(30秒、カード不要)を取得し、`./scripts/adapt_mlange_key.sh` を実行してください。

## 質問

[Discord](https://discord.gg/gqhDWfZbgU) に来るか、Issueを開いてください。アプリを仕上げるお手伝いを喜んでします。
