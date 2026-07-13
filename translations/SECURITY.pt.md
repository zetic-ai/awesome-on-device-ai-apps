<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <a href="SECURITY.de.md">Deutsch</a> ·
  <a href="SECURITY.es.md">Español</a> ·
  <a href="SECURITY.fr.md">Français</a> ·
  <a href="SECURITY.ja.md">日本語</a> ·
  <a href="SECURITY.ko.md">한국어</a> ·
  <b>Português</b> ·
  <a href="SECURITY.zh.md">中文</a>
</p>

# Política de segurança

## Chaves de API e segredos

Estes apps usam um **Melange Personal Access Token** para transmitir os pesos do modelo otimizados para NPU. Esse token é um segredo.

- **Nunca faça commit de uma chave real.** O código commitado deve sempre conter o placeholder `YOUR_PERSONAL_ACCESS_TOKEN` (ou `YOUR_MLANGE_KEY`).
- Defina sua chave localmente com `./scripts/adapt_mlange_key.sh`.
- Mantenha as alterações locais de chave fora do git com `./scripts/setup_git_ignore_keys.sh` (marca os arquivos de chave como `skip-worktree`).
- Restaure os arquivos para placeholders a qualquer momento com `./scripts/restore_placeholder_keys.sh`.
- Antes de cada commit, verifique que nenhuma chave vazou:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

Se você fizer commit de uma chave por acidente: revogue-a imediatamente no [painel do Melange](https://mlange.zetic.ai) e faça a rotação.

## Modelo de privacidade

Cada app deste repo executa a inferência **no aparelho**. Frames da câmera, áudio do microfone e texto são processados localmente e não foram projetados para sair do telefone. Se você contribuir com um app, mantenha essa promessa: qualquer chamada de rede precisa ser claramente documentada no README do app.

## Reportar uma vulnerabilidade

Encontrou um problema de segurança? Por favor, **não** abra uma issue pública. Fale conosco no [Discord](https://discord.gg/gqhDWfZbgU) (DM para um mantenedor) ou por e-mail em `security@zetic.ai`. Vamos responder o mais rápido possível.
