<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <a href="SECURITY.de.md">Deutsch</a> ·
  <a href="SECURITY.es.md">Español</a> ·
  <a href="SECURITY.fr.md">Français</a> ·
  <a href="SECURITY.ja.md">日本語</a> ·
  <a href="SECURITY.ko.md">한국어</a> ·
  <a href="SECURITY.pt.md">Português</a> ·
  <b>中文</b>
</p>

# 安全政策

## API 密钥与机密

这些应用使用 **Melange Personal Access Token** 来流式获取 NPU 优化的模型权重。该 Token 是机密。

- **绝不要提交真实密钥。** 提交的代码中必须始终是占位符 `YOUR_PERSONAL_ACCESS_TOKEN`(或 `YOUR_MLANGE_KEY`)。
- 用 `./scripts/adapt_mlange_key.sh` 在本地设置你的密钥。
- 用 `./scripts/setup_git_ignore_keys.sh` 把本地的密钥改动挡在 git 之外(将密钥文件标记为 `skip-worktree`)。
- 随时可用 `./scripts/restore_placeholder_keys.sh` 把文件还原为占位符。
- 每次提交前,确认没有密钥泄露:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

如果你不小心提交了密钥:立即在 [Melange 控制台](https://mlange.zetic.ai) 吊销(revoke),然后轮换。

## 隐私模型

本仓库的每个应用都在**端侧**运行推理。摄像头画面、麦克风音频和文本都在本地处理,设计上不会离开手机。如果你贡献一个应用,请守住这个承诺:任何网络调用都必须在应用 README 中清楚说明。

## 报告漏洞

发现了安全问题?请**不要**开公开 issue。通过 [Discord](https://discord.gg/gqhDWfZbgU)(私信维护者)或发邮件到 `security@zetic.ai` 联系我们。我们会尽快回复。
