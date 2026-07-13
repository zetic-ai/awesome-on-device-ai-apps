<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <a href="SECURITY.de.md">Deutsch</a> ·
  <b>Español</b> ·
  <a href="SECURITY.fr.md">Français</a> ·
  <a href="SECURITY.ja.md">日本語</a> ·
  <a href="SECURITY.ko.md">한국어</a> ·
  <a href="SECURITY.pt.md">Português</a> ·
  <a href="SECURITY.zh.md">中文</a>
</p>

# Política de seguridad

## Claves de API y secretos

Estas apps usan un **Melange Personal Access Token** para transmitir los pesos del modelo optimizados para NPU. Ese token es un secreto.

- **Nunca hagas commit de una clave real.** El código commiteado siempre debe contener el marcador `YOUR_PERSONAL_ACCESS_TOKEN` (o `YOUR_MLANGE_KEY`).
- Configura tu clave en local con `./scripts/adapt_mlange_key.sh`.
- Mantén los cambios locales de clave fuera de git con `./scripts/setup_git_ignore_keys.sh` (marca los archivos de clave como `skip-worktree`).
- Restaura los archivos a marcadores cuando quieras con `./scripts/restore_placeholder_keys.sh`.
- Antes de cada commit, verifica que no se filtró ninguna clave:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

Si por accidente haces commit de una clave: revócala de inmediato en el [panel de Melange](https://mlange.zetic.ai) y rótala.

## Modelo de privacidad

Cada app de este repo ejecuta la inferencia **en el dispositivo**. Los fotogramas de la cámara, el audio del micrófono y el texto se procesan localmente y no están diseñados para salir del teléfono. Si contribuyes una app, mantén esa promesa: cualquier llamada de red debe estar claramente documentada en el README de la app.

## Reportar una vulnerabilidad

¿Encontraste un problema de seguridad? Por favor, **no** abras un issue público. Contáctanos por [Discord](https://discord.gg/gqhDWfZbgU) (DM a un maintainer) o por correo a `security@zetic.ai`. Responderemos lo antes posible.
