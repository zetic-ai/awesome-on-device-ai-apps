<p align="center">
  <a href="../README.md">English</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <b>Português</b> ·
  <a href="README.zh.md">中文</a>
</p>

<div align="center">

# 🧠 Awesome On-Device AI Apps

### Lance recursos de IA que a nuvem não pode oferecer legalmente. 36 apps que rodam 100% no celular.

<img src="../res/screenshots/qwen_4b_ios.gif" width="178" alt="On-device chat"> <img src="../res/screenshots/translator-ocr.gif" width="178" alt="Offline translator"> <img src="../res/screenshots/ainotes.gif" width="178" alt="Private AI notes"> <img src="../res/screenshots/camera-vitals.gif" width="178" alt="Camera heart-rate">

**Sem barreira de conformidade&nbsp; ·&nbsp; $0 em qualquer escala&nbsp; ·&nbsp; Os dados nunca saem do aparelho&nbsp; ·&nbsp; Funciona offline**

<sub>💬 Chat&nbsp; · &nbsp;🌐 Tradução&nbsp; · &nbsp;👁️ Visão&nbsp; · &nbsp;❤️ Saúde&nbsp; · &nbsp;🎙️ Voz&nbsp; · &nbsp;📈 Previsão</sub>

<br/>

[![Stars](https://img.shields.io/github/stars/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge&color=8A2BE2&logo=github)](https://github.com/zetic-ai/awesome-on-device-ai-apps/stargazers)
[![Forks](https://img.shields.io/github/forks/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/network/members)
[![Last commit](https://img.shields.io/github/last-commit/zetic-ai/awesome-on-device-ai-apps?style=for-the-badge)](https://github.com/zetic-ai/awesome-on-device-ai-apps/commits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](../LICENSE)

<sub>⚡ Desenvolvido com <a href="https://mlange.zetic.ai"><b>Melange</b></a> — o runtime de NPU no aparelho</sub>

</div>

<br/>

> ### On-device é uma decisão de negócio, não apenas técnica.

Cada app aqui executa o modelo no próprio celular. Nada vai para um servidor. Esse único fato reescreve a economia:

- 🛡️ **Sem barreira de conformidade.** Sem dados de usuário na nuvem, não há bloqueio de GDPR, HIPAA ou residência de dados entre você e o lançamento. Coloque IA em produtos de saúde, finanças e corporativos, e cobre de verdade por isso.
- 💸 **Custo marginal de $0.** Sem cobrança por token, sem servidores de inferência. Suas margens se mantêm ao escalar de 1 a 10 milhões de usuários.
- 🔒 **Privado por design.** Nada sai do aparelho, então não existe um conjunto de dados na nuvem para vazar, ser invadido ou auditado.
- ⚡ **Instantâneo e offline.** Roda na NPU do celular sem ida e volta à rede: num avião, no metrô ou num chão de fábrica sem sinal.

E estes não são trechos de código. Cada pasta é um app pronto que você pode clonar e rodar hoje num aparelho real.

<br/>

## ⚡ Rode um no seu celular

Escolha qualquer app, clone e rode num aparelho real. Sem configuração de ML, sem conversão de modelo, sem C++.

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

## 🗂️ Os apps

Veja o catálogo completo dos 36 apps no [README em inglês](../README.md#-the-apps) (com modelo, plataformas e link do Melange por app).

<br/>

## 🧩 Crie o seu — via vibe-coding

Claude Code, Codex e Cursor fazem vibe-coding de um app web em minutos. Peça a eles um app que rode um modelo na NPU do celular e eles travam, porque o deploy on-device não é algo que eles saibam fazer.

É exatamente essa lacuna que o [**Melange**](https://mlange.zetic.ai) preenche, e é o jeito mais fácil do mundo de levar IA para o aparelho hoje. Cada app deste repo foi feito do mesmo jeito: gere o código de integração com o Melange, cole, pronto. Copie um caso de uso daqui e o recurso on-device entra direto no seu app, no mesmo loop de vibe-coding que você já usa.

Colocá-lo num projeto existente são cerca de 3 linhas:

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

Traga o seu próprio modelo: envie para o [Melange](https://mlange.zetic.ai), ele converte e otimiza para NPU automaticamente e devolve um build pronto para o celular em cerca de uma hora, e não em meses de ajuste de hardware.

<br/>

## 🤝 Contribua com um app

Esta galeria cresce com contribuições, e a régua é uma só pergunta: **um estranho clonaria isto e usaria de verdade?**

1. Coloque seu app em `apps/<YourApp>/` com `Android/` e/ou `iOS/`
2. Adicione um `meta.json` (veja qualquer app existente) e um `README.md`
3. Rode `python3 scripts/generate_catalog.py` para adicioná-lo ao catálogo
4. Prove que roda num aparelho real (GIF de demo no PR)

Guia completo → **[CONTRIBUTING.md](../CONTRIBUTING.md)**. Dúvidas → [Discord](https://discord.gg/gqhDWfZbgU).

<br/>

## ⭐ Histórico de estrelas

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=zetic-ai/awesome-on-device-ai-apps&type=Date)](https://star-history.com/#zetic-ai/awesome-on-device-ai-apps&Date)

<br/>

Feito pela [ZETIC](https://zetic.ai) · Desenvolvido com [Melange](https://mlange.zetic.ai)

**Se um app de IA nativo do celular te fez pensar _"peraí, isso roda offline?"_, dê uma ⭐. É assim que o próximo dev encontra o projeto.**

</div>

<br/>

## 📄 Licença

O código-fonte dos apps está sob **Apache 2.0**: use comercial ou privadamente, como quiser. O próprio SDK do Melange é uma biblioteca proprietária sujeita aos [Termos de Serviço](https://zetic.ai/terms) da ZETIC.
