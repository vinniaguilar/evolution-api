# 🚀 Setup Simples - Evolution API no Cloud Run

Guia direto ao ponto para você começar a usar em **5 passos**.

## ✅ Passo 1: Banco de Dados Gratuito (2 minutos)

### Supabase (Recomendado - Totalmente Gratuito)

1. Acesse: https://supabase.com
2. Clique em **"Start your project"**
3. Faça login com GitHub
4. Clique em **"New project"**
5. Preencha:
   - **Name**: `evolution-api`
   - **Database Password**: Crie uma senha forte (anote!)
   - **Region**: Escolha o mais próximo (ex: South America)
6. Clique em **"Create new project"** (aguarde ~2 minutos)
7. Vá em **Settings > Database**
8. Copie a **URI** em "Connection string" > "URI"

Vai parecer com isso:
```
postgresql://postgres.xxxxx:SUA_SENHA@aws-0-sa-east-1.pooler.supabase.com:6543/postgres
```

## ✅ Passo 2: Configurar Variáveis (1 minuto)

```bash
# Copiar template
cp .env.cloudrun .env.production

# Editar (use nano, vim ou seu editor preferido)
nano .env.production
```

**Altere APENAS estas 3 linhas:**

```bash
# 1. Gerar chave de API (execute este comando e copie o resultado)
openssl rand -hex 32

# Cole o resultado aqui:
AUTHENTICATION_API_KEY=COLE_A_CHAVE_GERADA_AQUI

# 2. Cole a URI do Supabase aqui:
DATABASE_CONNECTION_URI=postgresql://postgres.xxxxx:SUA_SENHA@aws-0-sa-east-1.pooler.supabase.com:6543/postgres

# 3. Deixe assim por enquanto (vamos atualizar depois):
SERVER_URL=http://localhost:8080
```

Salve e feche (Ctrl+O, Enter, Ctrl+X no nano).

## ✅ Passo 3: Fazer Deploy (5 minutos)

```bash
# Login no Google Cloud (abrirá o navegador)
gcloud auth login

# Criar projeto (substitua PROJECT_ID por um nome único)
gcloud projects create evolution-api-12345 --name="Evolution API"

# Definir como projeto ativo
gcloud config set project evolution-api-12345

# Deploy automático
./deploy-cloudrun.sh evolution-api-12345
```

**Aguarde ~5 minutos** enquanto o Cloud Run faz o build e deploy.

## ✅ Passo 4: Atualizar URL (1 minuto)

Após o deploy, você receberá uma URL tipo:
```
https://evolution-api-xxxxx-uc.a.run.app
```

Atualize em `.env.production`:

```bash
nano .env.production

# Altere esta linha:
SERVER_URL=https://evolution-api-xxxxx-uc.a.run.app
```

Faça redeploy rápido:

```bash
./deploy-cloudrun.sh evolution-api-12345
```

## ✅ Passo 5: Testar (1 minuto)

```bash
# Salvar URL em variável
URL="https://evolution-api-xxxxx-uc.a.run.app"
API_KEY="SUA_CHAVE_DO_ENV_PRODUCTION"

# Testar API
curl $URL

# Criar instância WhatsApp
curl -X POST $URL/instance/create \
  -H "Content-Type: application/json" \
  -H "apikey: $API_KEY" \
  -d '{
    "instanceName": "whatsapp",
    "qrcode": true
  }'

# Conectar WhatsApp (obter QR Code)
curl -X GET $URL/instance/connect/whatsapp \
  -H "apikey: $API_KEY"
```

A resposta terá um campo `base64` com o QR Code. Cole em: https://base64.guru/converter/decode/image

Escaneie o QR Code com seu WhatsApp!

## 🎉 Pronto!

Sua Evolution API está rodando no Cloud Run!

### 📱 Enviar Mensagem de Teste

```bash
curl -X POST $URL/message/sendText/whatsapp \
  -H "Content-Type: application/json" \
  -H "apikey: $API_KEY" \
  -d '{
    "number": "5511999999999",
    "text": "Olá! Mensagem enviada via Evolution API 🚀"
  }'
```

### 📊 Ver Logs

```bash
gcloud run services logs tail evolution-api --region us-central1
```

### 💰 Custo

- **Cloud Run**: $0/mês (free tier: 2M requisições)
- **Supabase**: $0/mês (free tier: 500MB)
- **Total**: **GRÁTIS** 🎉

### 🆘 Problemas?

```bash
# Ver logs detalhados
gcloud run services logs read evolution-api --region us-central1 --limit 50

# Testar localmente
docker build -f Dockerfile.cloudrun -t test .
docker run -p 8080:8080 --env-file .env.production test
```

## 📚 Documentação da API

- **Swagger**: `https://SEU-URL.run.app/docs`
- **Postman**: https://www.postman.com/agenciadgcode/evolution-api
- **Docs**: https://doc.evolution-api.com

---

**Isso é tudo!** Configuração básica e funcional. ✅
