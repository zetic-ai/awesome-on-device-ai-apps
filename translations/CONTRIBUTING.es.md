<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <a href="CONTRIBUTING.de.md">Deutsch</a> ·
  <b>Español</b> ·
  <a href="CONTRIBUTING.fr.md">Français</a> ·
  <a href="CONTRIBUTING.ja.md">日本語</a> ·
  <a href="CONTRIBUTING.ko.md">한국어</a> ·
  <a href="CONTRIBUTING.pt.md">Português</a> ·
  <a href="CONTRIBUTING.zh.md">中文</a>
</p>

# Contribuir

Gracias por ayudar a construir la mejor colección de **apps de IA on-device** que existe. El listón para cada app aquí es una sola pregunta:

> **¿Un desconocido la clonaría y la usaría de verdad?**

No "¿demuestra un modelo?". No "¿compila?". *¿La usaría alguien?* Si es así, la queremos.

## Añade una app en 4 pasos

1. **Crea la carpeta** `apps/<YourApp>/` con un proyecto real y ejecutable:
   - `Android/`, un proyecto completo de Android Studio (Kotlin), y/o
   - `iOS/`, un proyecto completo de Xcode (Swift)
   - Al menos una plataforma debe correr realmente en un dispositivo.

2. **Añade un `meta.json`** copiando uno de una app existente y editándolo. Es la única fuente de verdad del catálogo:
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

3. **Escribe `apps/<YourApp>/README.md`** cubriendo qué hace, un inicio rápido y un GIF de demo. Pon los medios de demo compartidos en `res/screenshots/`.

4. **Regenera el catálogo y abre un PR:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   CI comprueba que el catálogo esté sincronizado, así que no te saltes esto.

## Estándares

- **Corre en un dispositivo real.** Los simuladores no tienen NPU. Demuéstralo con un GIF de demo en el PR.
- **Sin secretos.** Nunca hagas commit de una clave Melange real. Las claves quedan como marcadores (`YOUR_PERSONAL_ACCESS_TOKEN`); usa `./scripts/adapt_mlange_key.sh` en local y `./scripts/setup_git_ignore_keys.sh` para mantenerlas fuera de git. Ver [SECURITY.es.md](SECURITY.es.md).
- **Estructura consistente.** Sigue la forma de carpetas de las apps existentes.
- **Inglés para el contenido de la app que contribuyes** (README de la app, comentarios de código, textos de UI, mensajes de commit). El inglés es el idioma por defecto; los documentos del repo también se ofrecen traducidos en `translations/`. Los datos funcionales de i18n están bien: el endónimo de un idioma en un selector, o cadenas de demo específicas de un idioma en una app de traducción/transcripción que realmente lo soporte.
- **Licencia del modelo.** Asegúrate de que el modelo base permita redistribución/uso, e indícalo en el README de la app.

## Conseguir una clave Melange

Las apps transmiten pesos optimizados para NPU vía [Melange](https://mlange.zetic.ai). Consigue un Personal Access Token gratis (30 s, sin tarjeta) en **Settings → Personal Access Token** y luego ejecuta `./scripts/adapt_mlange_key.sh`.

## Preguntas

Pásate por [Discord](https://discord.gg/gqhDWfZbgU) o abre un issue. Con gusto te ayudamos a dejar tu app lista.
