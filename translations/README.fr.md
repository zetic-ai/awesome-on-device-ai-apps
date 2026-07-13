<p align="center">
  <a href="../README.md">English</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <b>Français</b> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.zh.md">中文</a>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### Livrez les fonctionnalités d'IA que le cloud n'a pas légalement le droit d'offrir. 36 apps qui tournent 100 % sur le téléphone.

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**Aucun mur de conformité&nbsp; ·&nbsp; 0 $ à toute échelle&nbsp; ·&nbsp; Les données ne quittent jamais l'appareil&nbsp; ·&nbsp; Fonctionne hors ligne**

<sub>💬 Chat&nbsp; · &nbsp;🌐 Traduction&nbsp; · &nbsp;👁️ Vision&nbsp; · &nbsp;❤️ Santé&nbsp; · &nbsp;🎙️ Voix&nbsp; · &nbsp;📈 Prévision</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ Propulsé par <a href="https://mlange.zetic.ai"><b>Melange</b></a> — le runtime NPU sur l'appareil</sub>

</div>

<br/>

> ### L'on-device est une décision business, pas seulement technique.

Chaque app ici exécute le modèle sur le téléphone lui-même. Rien ne part vers un serveur. Ce simple fait réécrit l'économie :

- 🛡️ **Aucun mur de conformité.** Pas de données utilisateur dans le cloud, donc aucun blocage RGPD, HIPAA ou de résidence des données entre vous et le lancement. Mettez de l'IA dans des produits de santé, de finance et d'entreprise, et facturez-la pour de vrai.
- 💸 **Coût marginal de 0 $.** Pas de facturation au token, pas de serveurs d'inférence. Vos marges tiennent que vous passiez de 1 à 10 millions d'utilisateurs.
- 🔒 **Privé par conception.** Rien ne quitte l'appareil, donc aucun jeu de données cloud à faire fuiter, compromettre ou auditer.
- ⚡ **Instantané et hors ligne.** Tourne sur le NPU du téléphone sans aller-retour réseau : dans un avion, un métro ou une usine sans réseau.

Et ce ne sont pas des extraits de code. Chaque dossier est une app terminée que vous pouvez cloner et exécuter dès aujourd'hui sur un vrai appareil.

<br/>

## ⚡ Lancez-en une sur votre téléphone

Choisissez une app, clonez-la et exécutez-la sur un vrai appareil. Pas de configuration ML, pas de conversion de modèle, pas de C++.

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

## 🗂️ Les apps

Parcourez le catalogue complet des 36 apps dans le [README en anglais](../README.md#-the-apps) (avec modèle, plateformes et lien Melange par app).

<br/>

## 🧩 Créez la vôtre — en vibe-coding

Claude Code, Codex et Cursor vous vibe-codent une app web en quelques minutes. Demandez-leur une app qui exécute un modèle sur le NPU du téléphone et ils calent : le déploiement on-device n'est pas quelque chose qu'ils savent faire.

C'est précisément la lacune que comble [**Melange**](https://mlange.zetic.ai), et c'est la façon la plus simple au monde de mettre de l'IA sur l'appareil aujourd'hui. Chaque app de ce dépôt a été construite de la même manière : générez le code d'intégration avec Melange, collez-le, terminé. Copiez un cas d'usage d'ici et la fonctionnalité on-device atterrit directement dans votre app, dans la même boucle de vibe-coding que vous utilisez déjà.

L'intégrer dans un projet existant, c'est environ 3 lignes :

**Android** (`build.gradle.kts`) :
```kotlin
dependencies { implementation("com.zeticai.mlange:mlange:+") }
```
```kotlin
val model = ZeticMLangeModel(context = this, tokenKey = "YOUR_KEY", modelName = "Team_ZETIC/YOLO26")
val outputs = model.run(inputs)   // NPU-accelerated, on-device
```

**iOS** (Swift Package Manager → `https://github.com/zetic-ai/ZeticMLangeiOS.git`) :
```swift
let model = try ZeticMLangeModel(tokenKey: "YOUR_KEY", name: "Team_ZETIC/YOLO26", version: 1)
let outputs = try model.run(inputs: inputs)
```

Apportez votre propre modèle : téléversez-le sur [Melange](https://mlange.zetic.ai), il le convertit et l'optimise pour le NPU automatiquement, puis vous rend un build prêt pour le téléphone en environ une heure, au lieu de mois de réglage matériel.

<br/>

## 🤝 Contribuez une app

Cette galerie grandit par les contributions, et la barre est une seule question : **un inconnu la clonerait-il et l'utiliserait-il vraiment ?**

1. Déposez votre app dans `apps/<YourApp>/` avec `Android/` et/ou `iOS/`
2. Ajoutez un `meta.json` (voyez n'importe quelle app existante) et un `README.md`
3. Lancez `python3 scripts/generate_catalog.py` pour l'ajouter au catalogue
4. Prouvez qu'elle tourne sur un vrai appareil (GIF de démo dans la PR)

Guide complet → **[CONTRIBUTING.md](CONTRIBUTING.fr.md)**. Questions → [Discord](https://discord.gg/gqhDWfZbgU).

<br/>

## ⭐ Historique des étoiles

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

Réalisé par [ZETIC](https://zetic.ai) · Propulsé par [Melange](https://mlange.zetic.ai)

**Si une app d'IA native du téléphone vous a fait dire _« attends, ça marche hors ligne ? »_, mettez-lui une ⭐. C'est comme ça que le prochain dev la trouvera.**

</div>

<br/>

## 📄 Licence

Le code source des apps est sous **Apache 2.0** : utilisez-le en commercial ou en privé, comme vous voulez. Le SDK Melange lui-même est une bibliothèque propriétaire soumise aux [Conditions d'utilisation](https://zetic.ai/terms) de ZETIC.
