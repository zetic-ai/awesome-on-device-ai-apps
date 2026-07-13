<p align="center">
  <a href="../SECURITY.md">English</a> ·
  <b>Deutsch</b> ·
  <a href="SECURITY.es.md">Español</a> ·
  <a href="SECURITY.fr.md">Français</a> ·
  <a href="SECURITY.ja.md">日本語</a> ·
  <a href="SECURITY.ko.md">한국어</a> ·
  <a href="SECURITY.pt.md">Português</a> ·
  <a href="SECURITY.zh.md">中文</a>
</p>

# Sicherheitsrichtlinie

## API-Keys & Secrets

Diese Apps nutzen ein **Melange Personal Access Token**, um NPU-optimierte Modellgewichte zu streamen. Dieses Token ist ein Secret.

- **Committe niemals einen echten Key.** Committeter Code muss immer den Platzhalter `YOUR_PERSONAL_ACCESS_TOKEN` (oder `YOUR_MLANGE_KEY`) enthalten.
- Setze deinen Key lokal mit `./scripts/adapt_mlange_key.sh`.
- Halte lokale Key-Änderungen mit `./scripts/setup_git_ignore_keys.sh` aus git heraus (markiert Key-Dateien als `skip-worktree`).
- Setze Dateien jederzeit mit `./scripts/restore_placeholder_keys.sh` auf Platzhalter zurück.
- Prüfe vor jedem Commit, dass kein Key durchgesickert ist:
  ```bash
  git diff --cached | grep -iE 'tokenKey|personalKey' | grep -viE 'YOUR_|PLACEHOLDER'
  ```

Falls du versehentlich einen Key committest: widerrufe ihn sofort im [Melange-Dashboard](https://mlange.zetic.ai) und rotiere ihn.

## Datenschutzmodell

Jede App in diesem Repo führt Inferenz **auf dem Gerät** aus. Kamerabilder, Mikrofon-Audio und Text werden lokal verarbeitet und sind nicht dafür ausgelegt, das Handy zu verlassen. Wenn du eine App beisteuerst, halte dieses Versprechen: Jeder Netzwerkaufruf muss im App-README klar dokumentiert sein.

## Eine Schwachstelle melden

Ein Sicherheitsproblem gefunden? Bitte öffne **kein** öffentliches Issue. Erreiche uns über [Discord](https://discord.gg/gqhDWfZbgU) (schreib einem Maintainer eine DM) oder per E-Mail an `security@zetic.ai`. Wir antworten so schnell wie möglich.
