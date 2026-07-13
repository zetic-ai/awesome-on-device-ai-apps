<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <a href="SECURITY.de.md">Deutsch</a> ·
  <a href="SECURITY.es.md">Español</a> ·
  <b>Français</b> ·
  <a href="SECURITY.ja.md">日本語</a> ·
  <a href="SECURITY.ko.md">한국어</a> ·
  <a href="SECURITY.pt.md">Português</a> ·
  <a href="SECURITY.zh.md">中文</a>
</p>

# Politique de sécurité

## Clés d'API et secrets

Ces apps utilisent un **Melange Personal Access Token** pour diffuser les poids du modèle optimisés pour le NPU. Ce token est un secret.

- **Ne committez jamais une vraie clé.** Le code committé doit toujours contenir l'espace réservé `YOUR_PERSONAL_ACCESS_TOKEN` (ou `YOUR_MLANGE_KEY`).
- Définissez votre clé en local avec `./scripts/adapt_mlange_key.sh`.
- Gardez les modifications locales de clé hors de git avec `./scripts/setup_git_ignore_keys.sh` (marque les fichiers de clé en `skip-worktree`).
- Réinitialisez les fichiers vers les espaces réservés à tout moment avec `./scripts/restore_placeholder_keys.sh`.
- Avant chaque commit, vérifiez qu'aucune clé n'a fuité :
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

Si vous committez une clé par accident : révoquez-la immédiatement dans le [tableau de bord Melange](https://mlange.zetic.ai), puis effectuez une rotation.

## Modèle de confidentialité

Chaque app de ce dépôt exécute l'inférence **sur l'appareil**. Les images de la caméra, l'audio du micro et le texte sont traités localement et ne sont pas censés quitter le téléphone. Si vous contribuez une app, tenez cette promesse : tout appel réseau doit être clairement documenté dans le README de l'app.

## Signaler une vulnérabilité

Un problème de sécurité ? Merci de **ne pas** ouvrir d'issue publique. Contactez-nous sur [Discord](https://discord.gg/gqhDWfZbgU) (DM à un mainteneur) ou par e-mail à `security@zetic.ai`. Nous répondrons aussi vite que possible.
