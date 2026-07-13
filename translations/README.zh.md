<p align="center">
  <a href="../README.md">English</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pt.md">Português</a> ·
  <b>中文</b>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### 交付云端在法律上做不到的 AI 功能。36 款 100% 在手机上运行的应用。

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**没有合规壁垒&nbsp; ·&nbsp; 任意规模都 $0&nbsp; ·&nbsp; 数据不出设备&nbsp; ·&nbsp; 离线运行**

<sub>💬 聊天&nbsp; · &nbsp;🌐 翻译&nbsp; · &nbsp;👁️ 视觉&nbsp; · &nbsp;❤️ 健康&nbsp; · &nbsp;🎙️ 语音&nbsp; · &nbsp;📈 预测</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ 由 <a href="https://mlange.zetic.ai"><b>Melange</b></a> 驱动 — 端侧 NPU 运行时</sub>

</div>

<br/>

> ### 端侧是一个商业决策，而不仅仅是技术决策。

这里的每个应用都在手机本机上运行模型。没有任何东西发往服务器。这一个事实改写了经济账:

- 🛡️ **没有合规壁垒。** 用户数据不在云端，意味着 GDPR、HIPAA 或数据驻留法规不会成为你上线的拦路石。把 AI 放进医疗、金融和企业产品，并真正为之收费。
- 💸 **边际成本为 $0。** 没有按 token 计费，没有推理服务器。用户从 1 增长到 1000 万，你的利润率依然稳固。
- 🔒 **设计即隐私。** 没有任何东西离开设备，因此不存在会被泄露、被攻破或被审计的云端数据集。
- ⚡ **即时且离线。** 在手机 NPU 上运行，无需网络往返，飞机上、地铁里、没有信号的工厂车间都能用。

而且这些不是代码片段。每个文件夹都是一个可以 clone 下来、在真机上直接运行的完整应用。

<br/>

## ⚡ 在你的手机上跑一个

任选一个应用，clone 下来，在真机上运行。无需 ML 配置，无需模型转换，无需 C++。

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

## 🗂️ 应用列表

在[英文 README](../README.md#-the-apps) 中查看全部 36 个应用的完整目录（含每个应用的模型、平台与 Melange 链接）。

<br/>

## 🧩 自己动手 —— 用 vibe-coding

Claude Code、Codex 和 Cursor 能在几分钟内帮你 vibe-code 一个网页应用。但当你让它们做一个在手机 NPU 上运行模型的应用时，它们就卡住了——端侧部署不是它们会做的事。

而这正是 [**Melange**](https://mlange.zetic.ai) 填补的空白，也是当今世界上把 AI 端侧化最简单的方式。这个仓库里的每个应用都是这样做出来的：用 Melange 生成集成代码，粘贴进去，搞定。从这里复制一个用例，端侧功能就会以你早已熟悉的 vibe-coding 方式直接进入你的应用。

集成到现有项目大约只需 3 行:

**Android**（`build.gradle.kts`）:
```kotlin
dependencies { implementation("com.zeticai.mlange:mlange:+") }
```
```kotlin
val model = ZeticMLangeModel(context = this, tokenKey = "YOUR_KEY", modelName = "Team_ZETIC/YOLO26")
val outputs = model.run(inputs)   // NPU-accelerated, on-device
```

**iOS**（Swift Package Manager → `https://github.com/zetic-ai/ZeticMLangeiOS.git`）:
```swift
let model = try ZeticMLangeModel(tokenKey: "YOUR_KEY", name: "Team_ZETIC/YOLO26", version: 1)
let outputs = try model.run(inputs: inputs)
```

带上你自己的模型: 上传到 [Melange](https://mlange.zetic.ai)，它会自动转换并做 NPU 优化，然后在大约一小时内（而不是数月的硬件调优）把一个可直接在手机上运行的构建交回给你。

<br/>

## 🤝 贡献一个应用

这个作品集靠贡献成长，标准只有一个问题: **一个陌生人会 clone 它并真正使用吗?**

1. 把你的应用放进 `apps/<YourApp>/`，含 `Android/` 和/或 `iOS/`
2. 添加 `meta.json`（参考任意现有应用）和 `README.md`
3. 运行 `python3 scripts/generate_catalog.py` 将其加入目录
4. 证明它能在真机上运行（PR 中附演示 GIF）

完整指南 → **[CONTRIBUTING.md](../CONTRIBUTING.md)**。有问题 → [Discord](https://discord.gg/gqhDWfZbgU)。

<br/>

## ⭐ Star 历史

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

由 [ZETIC](https://zetic.ai) 打造 · 由 [Melange](https://mlange.zetic.ai) 驱动

**如果一个手机原生 AI 应用让你惊呼 _「等等，这居然离线也能跑?」_，那就点个 ⭐。这是下一个开发者发现它的方式。**

</div>

<br/>

## 📄 许可证

应用源代码采用 **Apache 2.0**: 无论商用还是私用，随你使用。Melange SDK 本身是一个专有库，受 ZETIC [服务条款](https://zetic.ai/terms)约束。
