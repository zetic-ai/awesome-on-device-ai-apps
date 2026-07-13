<p align="center">
  <a href="../README.md">English</a> ·
  <b>Deutsch</b> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.zh.md">中文</a>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### Liefere KI-Funktionen aus, die die Cloud rechtlich nicht darf. 36 Apps, die zu 100 % auf dem Handy laufen.

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**Keine Compliance-Hürde&nbsp; ·&nbsp; $0 in jeder Größenordnung&nbsp; ·&nbsp; Daten verlassen das Gerät nie&nbsp; ·&nbsp; Läuft offline**

<sub>💬 Chat&nbsp; · &nbsp;🌐 Übersetzung&nbsp; · &nbsp;👁️ Vision&nbsp; · &nbsp;❤️ Gesundheit&nbsp; · &nbsp;🎙️ Sprache&nbsp; · &nbsp;📈 Prognose</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ Angetrieben von <a href="https://mlange.zetic.ai"><b>Melange</b></a> — der On-Device-NPU-Runtime</sub>

</div>

<br/>

> ### On-Device ist eine geschäftliche Entscheidung, nicht nur eine technische.

Jede App hier führt das Modell auf dem Handy selbst aus. Nichts geht an einen Server. Diese eine Tatsache schreibt die Wirtschaftlichkeit neu:

- 🛡️ **Keine Compliance-Hürde.** Keine Nutzerdaten in der Cloud heißt: keine DSGVO-, HIPAA- oder Datenresidenz-Sperre zwischen dir und dem Launch. Bring KI in Gesundheits-, Finanz- und Enterprise-Produkte und verlange tatsächlich Geld dafür.
- 💸 **$0 Grenzkosten.** Keine Abrechnung pro Token, keine Inferenz-Server. Deine Margen bleiben stabil, egal ob 1 oder 10 Millionen Nutzer.
- 🔒 **Privat by Design.** Nichts verlässt das Gerät, also gibt es keinen Cloud-Datensatz, der geleakt, kompromittiert oder auditiert werden könnte.
- ⚡ **Sofort und offline.** Läuft auf der NPU des Handys ohne Netzwerk-Roundtrip — im Flugzeug, in der U-Bahn oder in einer Fabrikhalle ohne Empfang.

Und das sind keine Snippets. Jeder Ordner ist eine fertige App, die du clonen und heute auf einem echten Gerät ausführen kannst.

<br/>

## ⚡ Führe eine auf deinem Handy aus

Wähle eine beliebige App, clone sie und führe sie auf einem echten Gerät aus. Kein ML-Setup, keine Modellkonvertierung, kein C++.

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

## 🗂️ Die Apps

Sieh dir den vollständigen Katalog aller 36 Apps im [englischen README](../README.md#-the-apps) an (mit Modell, Plattformen und Melange-Link je App).

<br/>

## 🧩 Bau deine eigene — per Vibe-Coding

Claude Code, Codex und Cursor vibe-coden dir in Minuten eine Web-App. Bitte sie um eine App, die ein Modell auf der NPU des Handys ausführt, und sie kommen ins Stocken — On-Device-Deployment ist nichts, was sie können.

Genau diese Lücke füllt [**Melange**](https://mlange.zetic.ai), und es ist der weltweit einfachste Weg, KI heute auf das Gerät zu bringen. Jede App in diesem Repo wurde genauso gebaut: Integrationscode mit Melange generieren, einfügen, fertig. Kopiere einen Use Case von hier, und die On-Device-Funktion landet direkt in deiner App — in derselben Vibe-Coding-Schleife, die du ohnehin nutzt.

Die Einbindung in ein bestehendes Projekt sind etwa 3 Zeilen:

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

Bring dein eigenes Modell mit: Lade es zu [Melange](https://mlange.zetic.ai) hoch, es konvertiert und NPU-optimiert automatisch und gibt dir in etwa einer Stunde — statt Monaten Hardware-Tuning — einen einsatzbereiten Build zurück.

<br/>

## 🤝 Steuere eine App bei

Diese Galerie wächst durch Beiträge, und die Messlatte ist eine einzige Frage: **Würde ein Fremder das clonen und tatsächlich nutzen?**

1. Lege deine App in `apps/<YourApp>/` mit `Android/` und/oder `iOS/` ab
2. Füge eine `meta.json` (siehe bestehende Apps) und eine `README.md` hinzu
3. Führe `python3 scripts/generate_catalog.py` aus, um sie in den Katalog aufzunehmen
4. Beweise, dass sie auf einem echten Gerät läuft (Demo-GIF im PR)

Vollständige Anleitung → **[CONTRIBUTING.md](CONTRIBUTING.de.md)**. Fragen → [Discord](https://discord.gg/gqhDWfZbgU).

<br/>

## ⭐ Star-Verlauf

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

Gebaut von [ZETIC](https://zetic.ai) · Angetrieben von [Melange](https://mlange.zetic.ai)

**Wenn dich eine handy-native KI-App zum Staunen gebracht hat — _„Moment, das läuft offline?"_ — dann gib ihr einen ⭐. So findet der nächste Entwickler sie.**

</div>

<br/>

## 📄 Lizenz

Der App-Quellcode steht unter **Apache 2.0**: nutze ihn kommerziell oder privat, ganz wie du willst. Das Melange SDK selbst ist eine proprietäre Bibliothek unter den ZETIC [Nutzungsbedingungen](https://zetic.ai/terms).
