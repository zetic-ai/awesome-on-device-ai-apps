<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <a href="CONTRIBUTING.de.md">Deutsch</a> ·
  <a href="CONTRIBUTING.es.md">Español</a> ·
  <a href="CONTRIBUTING.fr.md">Français</a> ·
  <a href="CONTRIBUTING.ja.md">日本語</a> ·
  <a href="CONTRIBUTING.ko.md">한국어</a> ·
  <a href="CONTRIBUTING.pt.md">Português</a> ·
  <b>中文</b>
</p>

# 贡献指南

感谢你帮助打造全世界最好的**端侧 AI 应用**合集。这里每个应用的标准只有一个问题:

> **一个陌生人会 clone 它并真正使用吗?**

不是「它能演示一个模型吗」，也不是「它能编译吗」。而是*会有人使用它吗*。如果会，我们就想要它。

## 四步添加一个应用

1. **创建文件夹** `apps/<YourApp>/`，放一个真正可运行的项目:
   - `Android/`，一个完整的 Android Studio 项目(Kotlin)，和/或
   - `iOS/`，一个完整的 Xcode 项目(Swift)
   - 至少一个平台必须能在真机上实际运行。

2. **添加 `meta.json`**，从任意现有应用复制一份再修改。它是目录的唯一信息来源:
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

3. **编写 `apps/<YourApp>/README.md`**，说明它做什么、快速开始和一个演示 GIF。共享的演示素材放在 `res/screenshots/`。

4. **重新生成目录并开 PR:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   CI 会检查目录是否同步，所以别跳过这一步。

## 标准

- **它能在真机上运行。** 模拟器没有 NPU。用 PR 里的演示 GIF 来证明。
- **不要泄露密钥。** 绝不要提交真实的 Melange 密钥。密钥要保持为占位符(`YOUR_PERSONAL_ACCESS_TOKEN`);本地用 `./scripts/adapt_mlange_key.sh`,用 `./scripts/setup_git_ignore_keys.sh` 把它们挡在 git 之外。见 [SECURITY.zh.md](SECURITY.zh.md)。
- **一致的结构。** 与现有应用的文件夹形态保持一致。
- **你贡献的应用内容用英文**(应用 README、代码注释、UI 文案、提交信息)。英文是默认;仓库级文档也在 `translations/` 下提供翻译版。功能性 i18n 数据没问题:语言选择器里各语言的本名,或者一个真正支持该语言的翻译/转写应用中的语言相关演示字符串。
- **模型许可证。** 确认底层模型允许再分发/使用,并在应用 README 中注明。

## 获取 Melange 密钥

应用通过 [Melange](https://mlange.zetic.ai) 流式获取 NPU 优化后的权重。在 **Settings → Personal Access Token** 免费领取一个 Token(30 秒,无需信用卡),然后运行 `./scripts/adapt_mlange_key.sh`。

## 有问题

加入 [Discord](https://discord.gg/gqhDWfZbgU) 或者开一个 issue。我们很乐意帮你把应用做到能上线。
