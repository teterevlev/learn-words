#!/bin/bash

set -e

echo "🔍 Проверка YC CLI..."
if ! command -v yc &> /dev/null; then
    echo "❌ YC CLI не установлен."
    echo ""
    echo "💡 Для macOS (рекомендуется):"
    echo "   brew install yandex-cloud-cli"
    echo ""
    echo "💡 Альтернатива:"
    echo "   curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash"
    exit 1
fi

echo "✅ YC CLI установлен: $(yc --version)"

echo ""
echo "📦 Создание пакета для деплоя..."

# Очистка предыдущих артефактов
rm -rf package function.zip

# Создание пакета
mkdir -p package
cp -r *.py lib/ 2>/dev/null || true
cp requirements.txt package/ 2>/dev/null || true

cd package
zip -r ../function.zip . > /dev/null
cd ..

echo "✅ Пакет создан: function.zip"
echo ""

if [ -z "$1" ]; then
    echo "⚠️  Для деплоя укажите FUNCTION_ID:"
    echo "   ./scripts/test-deploy.sh <FUNCTION_ID>"
    echo ""
    echo "💡 Или создайте функцию:"
    echo "   yc serverless function create --name my-function"
    exit 0
fi

FUNCTION_ID=$1

echo "🚀 Деплой функции $FUNCTION_ID..."

yc serverless function version create \
    --function-id "$FUNCTION_ID" \
    --runtime python311 \
    --entrypoint index.handler \
    --memory 128m \
    --execution-timeout 3s \
    --source-path function.zip \
    --environment PYTHONUNBUFFERED=1

echo ""
echo "✅ Деплой успешен!"
echo ""
echo "📋 Проверить версии функции:"
echo "   yc serverless function version list --function-id $FUNCTION_ID"
echo ""
echo "🧪 Вызвать функцию:"
echo "   yc serverless function invoke $FUNCTION_ID"
