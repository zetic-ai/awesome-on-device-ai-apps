<p align="center">
  <a href="../README.md">English</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.fr.md">Français</a> ·
  <b>日本語</b> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.zh.md">中文</a>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### クラウドが法的に扱えないAI機能を出荷しよう。100%スマホ上で動くアプリ36本。

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**コンプライアンスの壁なし&nbsp; ·&nbsp; どんな規模でも$0&nbsp; ·&nbsp; データは端末から出ない&nbsp; ·&nbsp; オフライン動作**

<sub>💬 チャット&nbsp; · &nbsp;🌐 翻訳&nbsp; · &nbsp;👁️ ビジョン&nbsp; · &nbsp;❤️ ヘルス&nbsp; · &nbsp;🎙️ 音声&nbsp; · &nbsp;📈 予測</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ <a href="https://mlange.zetic.ai"><b>Melange</b></a>による — オンデバイスNPUランタイム</sub>

</div>

<br/>

> ### オンデバイスは技術の判断ではなく、ビジネスの判断です。

ここにあるすべてのアプリは、モデルをスマホ本体で実行します。サーバーへ送るものは何もありません。その一点が経済性を書き換えます:

- 🛡️ **コンプライアンスの壁なし。** ユーザーデータがクラウドに無いということは、GDPR・HIPAA・データレジデンシーがリリースを阻む要因にならないということ。ヘルス・金融・エンタープライズ製品にAIを組み込み、実際に課金できます。
- 💸 **限界コスト$0。** トークン課金も推論サーバーもなし。ユーザーが1人から1,000万人に増えても利益率は保たれます。
- 🔒 **設計段階からプライベート。** 端末から何も出ないため、漏洩・侵害・監査の対象となるクラウドデータセットが存在しません。
- ⚡ **即時かつオフライン。** ネットワーク往復なしでスマホのNPU上で動作。飛行機の中、地下鉄、電波のない工場でも。

しかもこれらはスニペットではありません。どのフォルダも、cloneして実機で動かせる完成済みアプリです。

<br/>

## ⚡ スマホで一つ動かしてみる

好きなアプリを選んでcloneし、実機で動かしてください。MLのセットアップも、モデル変換も、C++も不要です。

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

## 🗂️ アプリ一覧

36本すべてのカタログは[英語のREADME](../README.md#-the-apps)をご覧ください（各アプリのモデル・プラットフォーム・Melangeリンク付き）。

<br/>

## 🧩 自分で作る — vibe-codingで

Claude Code、Codex、Cursorは、ウェブアプリなら数分でvibe-codingしてくれます。ところがスマホのNPUでモデルを動かすアプリを頼むと止まってしまう。オンデバイス配備は、彼らがやり方を知らない領域だからです。

その隙間を埋めるのが[**Melange**](https://mlange.zetic.ai)です。今、世界でいちばん簡単にAIをオンデバイス化する方法。このリポのアプリはすべて同じやり方で作られました。Melangeで統合コードを生成して貼り付けるだけ。ここのユースケースをコピーすれば、あなたが普段使っているvibe-codingのループそのままで、オンデバイス機能がアプリに直接入ります。

既存プロジェクトへの組み込みはおよそ3行:

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

自分のモデルを持ち込む: [Melange](https://mlange.zetic.ai)にアップロードすれば自動で変換・NPU最適化し、数か月のハードウェアチューニングではなく約1時間で、スマホですぐ動くビルドを返してくれます。

<br/>

## 🤝 アプリを寄稿する

このギャラリーは寄稿で育ちます。基準はただ一つの問い: **見知らぬ人がこれをcloneして実際に使うか?**

1. `apps/<YourApp>/` に `Android/` および/または `iOS/` でアプリを置く
2. `meta.json`（既存アプリを参照）と `README.md` を追加する
3. `python3 scripts/generate_catalog.py` を実行してカタログに追加する
4. 実機で動くことを証明する（PRにデモGIF）

詳しいガイド → **[CONTRIBUTING.md](CONTRIBUTING.ja.md)**。質問は → [Discord](https://discord.gg/gqhDWfZbgU)。

<br/>

## ⭐ スター履歴

<div align="center">

[![Star History](https://img.shields.io/badge/%E2%AD%90%20Star%20History-View%20live%20chart-8A2BE2?style=for-the-badge)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

[ZETIC](https://zetic.ai)が制作 · [Melange](https://mlange.zetic.ai)による

**スマホネイティブのAIアプリを見て _「え、これオフラインで動くの?」_ と思ったら、⭐ を付けてください。次の開発者がこれを見つける方法です。**

</div>

<br/>

## 📄 ライセンス

アプリのソースは **Apache 2.0** です: 商用でも個人でも自由に使えます。Melange SDK自体は、ZETIC [利用規約](https://zetic.ai/terms)に従う独自ライブラリです。
