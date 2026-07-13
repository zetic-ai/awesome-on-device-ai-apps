<p align="center">
  <a href="../CONTRIBUTING.md">English</a> ·
  <a href="CONTRIBUTING.de.md">Deutsch</a> ·
  <a href="CONTRIBUTING.es.md">Español</a> ·
  <a href="CONTRIBUTING.fr.md">Français</a> ·
  <a href="CONTRIBUTING.ja.md">日本語</a> ·
  <a href="CONTRIBUTING.ko.md">한국어</a> ·
  <b>Português</b> ·
  <a href="CONTRIBUTING.zh.md">中文</a>
</p>

# Contribuir

Obrigado por ajudar a construir a melhor coleção de **apps de IA on-device** que existe. A régua para cada app aqui é uma só pergunta:

> **Um estranho clonaria isto e usaria de verdade?**

Não é "ele demonstra um modelo?". Não é "ele compila?". *Alguém usaria?* Se sim, nós queremos.

## Adicione um app em 4 passos

1. **Crie a pasta** `apps/<YourApp>/` com um projeto real e executável:
   - `Android/`, um projeto completo do Android Studio (Kotlin), e/ou
   - `iOS/`, um projeto completo do Xcode (Swift)
   - Pelo menos uma plataforma precisa realmente rodar num aparelho.

2. **Adicione um `meta.json`** copiando o de um app existente e editando. É a única fonte de verdade do catálogo:
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

3. **Escreva `apps/<YourApp>/README.md`** descrevendo o que ele faz, um início rápido e um GIF de demo. Coloque a mídia de demo compartilhada em `res/screenshots/`.

4. **Regenere o catálogo e abra um PR:**
   ```bash
   python3 scripts/generate_catalog.py
   ```
   A CI verifica se o catálogo está sincronizado, então não pule este passo.

## Padrões

- **Roda num aparelho real.** Simuladores não têm NPU. Prove com um GIF de demo no PR.
- **Sem segredos.** Nunca faça commit de uma chave Melange real. As chaves ficam como placeholders (`YOUR_PERSONAL_ACCESS_TOKEN`); use `./scripts/adapt_mlange_key.sh` localmente e `./scripts/setup_git_ignore_keys.sh` para mantê-las fora do git. Veja [SECURITY.pt.md](SECURITY.pt.md).
- **Estrutura consistente.** Siga o formato de pastas dos apps existentes.
- **Inglês para o conteúdo do app que você contribui** (README do app, comentários de código, textos de UI, mensagens de commit). O inglês é o padrão; os documentos do repo também são oferecidos traduzidos em `translations/`. Dados funcionais de i18n são ok: o endônimo de um idioma num seletor, ou strings de demo específicas de um idioma num app de tradução/transcrição que realmente o suporte.
- **Licença do modelo.** Garanta que o modelo base permite redistribuição/uso, e registre isso no README do app.

## Conseguir uma chave Melange

Os apps transmitem pesos otimizados para NPU via [Melange](https://mlange.zetic.ai). Pegue um Personal Access Token gratuito (30 s, sem cartão) em **Settings → Personal Access Token** e então rode `./scripts/adapt_mlange_key.sh`.

## Dúvidas

Entre no [Discord](https://discord.gg/gqhDWfZbgU) ou abra uma issue. Teremos prazer em ajudar a deixar seu app pronto.
