<p align="center">
  <a href="../README.md">English</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <b>Español</b> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.zh.md">中文</a>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### Lanza funciones de IA que la nube no puede ofrecer legalmente. 36 apps que corren 100 % en el teléfono.

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**Sin muro de cumplimiento&nbsp; ·&nbsp; $0 a cualquier escala&nbsp; ·&nbsp; Los datos nunca salen del dispositivo&nbsp; ·&nbsp; Funciona sin conexión**

<sub>💬 Chat&nbsp; · &nbsp;🌐 Traducción&nbsp; · &nbsp;👁️ Visión&nbsp; · &nbsp;❤️ Salud&nbsp; · &nbsp;🎙️ Voz&nbsp; · &nbsp;📈 Predicción</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ Impulsado por <a href="https://mlange.zetic.ai"><b>Melange</b></a> — el runtime de NPU en el dispositivo</sub>

</div>

<br/>

> ### On-device es una decisión de negocio, no solo técnica.

Cada app aquí ejecuta el modelo en el propio teléfono. Nada va a un servidor. Ese único hecho reescribe la economía:

- 🛡️ **Sin muro de cumplimiento.** Sin datos de usuario en la nube no hay bloqueo de GDPR, HIPAA ni residencia de datos entre tú y el lanzamiento. Lleva IA a productos de salud, finanzas y empresa, y cóbralos de verdad.
- 💸 **Costo marginal de $0.** Sin facturación por token, sin servidores de inferencia. Tus márgenes se mantienen al escalar de 1 a 10 millones de usuarios.
- 🔒 **Privado por diseño.** Nada sale del dispositivo, así que no hay un conjunto de datos en la nube que filtrar, vulnerar o auditar.
- ⚡ **Instantáneo y sin conexión.** Corre en la NPU del teléfono sin ida y vuelta a la red: en un avión, en el metro o en una fábrica sin señal.

Y esto no son fragmentos de código. Cada carpeta es una app terminada que puedes clonar y ejecutar hoy en un dispositivo real.

<br/>

## ⚡ Ejecuta una en tu teléfono

Elige cualquier app, clónala y ejecútala en un dispositivo real. Sin configuración de ML, sin conversión de modelos, sin C++.

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

## 🗂️ Las apps

Explora el catálogo completo de las 36 apps en el [README en inglés](../README.md#-the-apps) (con modelo, plataformas y enlace de Melange por app).

<br/>

## 🧩 Crea la tuya — con vibe-coding

Claude Code, Codex y Cursor te hacen vibe-coding de una app web en minutos. Pídeles una app que ejecute un modelo en la NPU del teléfono y se atascan, porque el despliegue en el dispositivo no es algo que sepan hacer.

Ese es el hueco que llena [**Melange**](https://mlange.zetic.ai), y es la forma más fácil del mundo de llevar IA al dispositivo hoy. Cada app de este repo se construyó igual: genera el código de integración con Melange, pégalo, listo. Copia un caso de uso de aquí y la función on-device entra directo en tu app, con el mismo bucle de vibe-coding que ya usas.

Integrarlo en un proyecto existente son unas 3 líneas:

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

Trae tu propio modelo: súbelo a [Melange](https://mlange.zetic.ai), lo convierte y optimiza para NPU automáticamente, y te devuelve un build listo para el teléfono en cerca de una hora, no en meses de ajuste de hardware.

<br/>

## 🤝 Contribuye una app

Esta galería crece con las contribuciones, y el listón es una sola pregunta: **¿un desconocido la clonaría y la usaría de verdad?**

1. Coloca tu app en `apps/<YourApp>/` con `Android/` y/o `iOS/`
2. Añade un `meta.json` (mira cualquier app existente) y un `README.md`
3. Ejecuta `python3 scripts/generate_catalog.py` para añadirla al catálogo
4. Demuestra que corre en un dispositivo real (GIF de demo en el PR)

Guía completa → **[CONTRIBUTING.md](../CONTRIBUTING.md)**. Preguntas → [Discord](https://discord.gg/gqhDWfZbgU).

<br/>

## ⭐ Historial de estrellas

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

Hecho por [ZETIC](https://zetic.ai) · Impulsado por [Melange](https://mlange.zetic.ai)

**Si una app de IA nativa del teléfono te hizo pensar _"espera, ¿esto corre sin conexión?"_, dale una ⭐. Así la encuentra el siguiente desarrollador.**

</div>

<br/>

## 📄 Licencia

El código de las apps está bajo **Apache 2.0**: úsalo comercial o privadamente, como quieras. El propio SDK de Melange es una biblioteca propietaria sujeta a los [Términos de servicio](https://zetic.ai/terms) de ZETIC.
