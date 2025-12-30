#!/bin/bash
set -e

PROJECT_ID=${1:-""}
REGION=${2:-"us-central1"}
SERVICE_NAME="evolution-api"

echo "🚀 Evolution API - Deploy no Cloud Run"
echo ""

if [ -z "$PROJECT_ID" ]; then
    PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
    if [ -z "$PROJECT_ID" ]; then
        echo "❌ PROJECT_ID não fornecido. Use: ./deploy-cloudrun.sh SEU_PROJECT_ID"
        exit 1
    fi
fi

if [ ! -f ".env.production" ]; then
    echo "❌ Arquivo .env.production não encontrado!"
    exit 1
fi

echo "📋 Project: $PROJECT_ID"
echo "📋 Region: $REGION"
echo ""

gcloud config set project $PROJECT_ID
gcloud services enable run.googleapis.com --quiet
gcloud services enable cloudbuild.googleapis.com --quiet

echo "🚀 Iniciando deploy..."
echo ""

gcloud run deploy $SERVICE_NAME \
  --source . \
  --dockerfile Dockerfile.cloudrun \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 512Mi \
  --cpu 1 \
  --timeout 300 \
  --min-instances 0 \
  --max-instances 10 \
  --env-vars-file .env.production \
  --quiet

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deploy realizado com sucesso!"
    SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format 'value(status.url)')
    echo ""
    echo "🌐 URL: $SERVICE_URL"
    echo ""
    echo "📝 Atualize SERVER_URL em .env.production e faça redeploy"
fi
