<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <a href="CONTRIBUTING.de.md">Deutsch</a> ·
  <a href="CONTRIBUTING.es.md">Español</a> ·
  <b>Français</b> ·
  <a href="CONTRIBUTING.ja.md">日本語</a> ·
  <a href="CONTRIBUTING.ko.md">한국어</a> ·
  <a href="CONTRIBUTING.pt.md">Português</a> ·
  <a href="CONTRIBUTING.zh.md">中文</a>
</p>

# Contribuer

Merci d'aider à bâtir la meilleure collection d'**apps d'IA on-device** qui soit. La barre pour chaque app ici est une seule question :

> **Un inconnu la clonerait-il et l'utiliserait-il vraiment ?**

Pas « est-ce que ça démontre un modèle ». Pas « est-ce que ça compile ». *Est-ce que quelqu'un l'utiliserait.* Si oui, on la veut.

## Ajouter une app en 4 étapes

1. **Créez le dossier** `apps/<YourApp>/` avec un vrai projet exécutable :
   - `Android/`, un projet Android Studio complet (Kotlin), et/ou
   - `iOS/`, un projet Xcode complet (Swift)
   - Au moins une plateforme doit réellement tourner sur un appareil.

2. **Ajoutez un `meta.json`** en copiant celui d'une app existante et en l'adaptant. C'est la source de vérité unique du catalogue :
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

3. **Écrivez `apps/<YourApp>/README.md`** décrivant ce qu'elle fait, un démarrage rapide et un GIF de démo. Placez les médias de démo partagés dans `res/screenshots/`.

4. **Régénérez le catalogue et ouvrez une PR :**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   La CI vérifie que le catalogue est synchronisé, alors ne sautez pas cette étape.

## Standards

- **Elle tourne sur un vrai appareil.** Les simulateurs n'ont pas de NPU. Prouvez-le avec un GIF de démo dans la PR.
- **Pas de secrets.** Ne committez jamais une vraie clé Melange. Les clés restent des espaces réservés (`YOUR_PERSONAL_ACCESS_TOKEN`) ; utilisez `./scripts/adapt_mlange_key.sh` en local et `./scripts/setup_git_ignore_keys.sh` pour les garder hors de git. Voir [SECURITY.fr.md](SECURITY.fr.md).
- **Structure cohérente.** Respectez la forme des dossiers des apps existantes.
- **Anglais pour le contenu d'app que vous contribuez** (README de l'app, commentaires de code, textes d'UI, messages de commit). L'anglais est la langue par défaut ; les docs du dépôt sont aussi proposées en traduction sous `translations/`. Les données i18n fonctionnelles sont acceptées : l'endonyme d'une langue dans un sélecteur, ou des chaînes de démo propres à une langue dans une app de traduction/transcription qui la prend réellement en charge.
- **Licence du modèle.** Assurez-vous que le modèle sous-jacent autorise la redistribution/l'usage, et notez-le dans le README de l'app.

## Obtenir une clé Melange

Les apps diffusent des poids optimisés pour le NPU via [Melange](https://mlange.zetic.ai). Obtenez un Personal Access Token gratuit (30 s, sans carte) sous **Settings → Personal Access Token**, puis lancez `./scripts/adapt_mlange_key.sh`.

## Questions

Passez sur [Discord](https://discord.gg/gqhDWfZbgU) ou ouvrez une issue. On vous aide volontiers à finaliser votre app.
