<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <b>Deutsch</b> ·
  <a href="CONTRIBUTING.es.md">Español</a> ·
  <a href="CONTRIBUTING.fr.md">Français</a> ·
  <a href="CONTRIBUTING.ja.md">日本語</a> ·
  <a href="CONTRIBUTING.ko.md">한국어</a> ·
  <a href="CONTRIBUTING.pt.md">Português</a> ·
  <a href="CONTRIBUTING.zh.md">中文</a>
</p>

# Mitwirken

Danke, dass du hilfst, die beste Sammlung von **On-Device-KI-Apps** überhaupt aufzubauen. Die Messlatte für jede App hier ist eine einzige Frage:

> **Würde ein Fremder das clonen und tatsächlich nutzen?**

Nicht „demonstriert es ein Modell". Nicht „lässt es sich kompilieren". *Würde es jemand nutzen.* Wenn ja, wollen wir es.

## In 4 Schritten eine App hinzufügen

1. **Erstelle den Ordner** `apps/<YourApp>/` mit einem echten, lauffähigen Projekt:
   - `Android/`, ein vollständiges Android-Studio-Projekt (Kotlin), und/oder
   - `iOS/`, ein vollständiges Xcode-Projekt (Swift)
   - Mindestens eine Plattform muss tatsächlich auf einem Gerät laufen.

2. **Füge eine `meta.json` hinzu**, indem du eine aus einer bestehenden App kopierst und anpasst. Sie ist die zentrale Quelle der Wahrheit für den Katalog:
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

3. **Schreibe `apps/<YourApp>/README.md`** mit dem, was sie tut, einem Schnellstart und einem Demo-GIF. Lege gemeinsame Demo-Medien in `res/screenshots/` ab.

4. **Regeneriere den Katalog und öffne einen PR:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   CI prüft, ob der Katalog synchron ist, also überspringe das nicht.

## Standards

- **Sie läuft auf einem echten Gerät.** Simulatoren haben keine NPU. Beweise es mit einem Demo-GIF im PR.
- **Keine Secrets.** Committe niemals einen echten Melange-Key. Keys bleiben Platzhalter (`YOUR_PERSONAL_ACCESS_TOKEN`); nutze lokal `./scripts/adapt_mlange_key.sh` und `./scripts/setup_git_ignore_keys.sh`, um sie aus git herauszuhalten. Siehe [SECURITY.de.md](SECURITY.de.md).
- **Konsistenter Aufbau.** Halte dich an die Ordnerform bestehender Apps.
- **Englisch für die App-Inhalte, die du beisteuerst** (App-README, Code-Kommentare, UI-Texte, Commit-Messages). Englisch ist der Standard; Repo-Dokumente gibt es zusätzlich als Übersetzungen unter `translations/`. Funktionale i18n-Daten sind in Ordnung: das Endonym einer Sprache in einer Sprachauswahl oder sprachspezifische Demo-Strings in einer Übersetzungs-/Transkriptions-App, die diese Sprache wirklich unterstützt.
- **Modell-Lizenz.** Stelle sicher, dass das zugrunde liegende Modell Weitergabe/Nutzung erlaubt, und vermerke es im App-README.

## Einen Melange-Key holen

Apps streamen NPU-optimierte Gewichte über [Melange](https://mlange.zetic.ai). Hol dir ein kostenloses Personal Access Token (30 Sek., ohne Karte) unter **Settings → Personal Access Token** und führe dann `./scripts/adapt_mlange_key.sh` aus.

## Fragen

Komm in den [Discord](https://discord.gg/gqhDWfZbgU) oder öffne ein Issue. Wir helfen dir gern, deine App über die Ziellinie zu bringen.
