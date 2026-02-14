#!/bin/bash

# Скрипт для развертывания микросервисов в кластере
echo "Installation starting..."

# Функция для ожидания
wait_seconds() {
    local seconds=$1
    echo "Waiting $seconds seconds..."
    sleep $seconds
}

# Создание ключей, namespace и применение секретов
echo "..................................................."
echo "Step 1. Creating keys, namespaces and applying secrets..."

# генерация пары ключей для JWT
openssl genrsa -out ./etc/keys/jwt-private.pem 2048
openssl rsa -in ./etc/keys/jwt-private.pem -pubout -out ./etc/keys/jwt-public.pem

# 1 namespace = 1 сервис
kubectl create namespace auth
kubectl create namespace profile
kubectl create namespace order
kubectl create namespace billing
kubectl create namespace client
kubectl create namespace notif

# Секреты из манифестов
kubectl apply -f ./secrets/auth_secret.yaml -n auth
kubectl apply -f ./secrets/users_secret.yaml -n profile
kubectl apply -f ./secrets/billing_secret.yaml -n billing
kubectl apply -f ./secrets/order_secret.yaml -n order
kubectl apply -f ./secrets/kafka_secret.yaml -n order
kubectl apply -f ./secrets/notif_secret.yaml -n notif
kubectl apply -f ./secrets/kafka_secret.yaml -n notif

# Секреты с ключами
# Полная пара для сервиса аутентификации
kubectl create secret generic jwt-signing-keys --from-file=private.pem=./etc/keys/jwt-private.pem --from-file=public.pem=./etc/keys/jwt-public.pem -n auth
# Только открытый ключ для API Gateway
kubectl create secret generic jwt-validation-key --from-file=public.pem=./etc/keys/jwt-public.pem -n client


# Установка сервиса аутентификации
echo "..................................................."
echo "Step 2. Installing Auth (A&A) Service..."

helm dependency build ./services/auth-app/
helm install auth ./services/auth-app -n auth

echo "Auth service installed."
wait_seconds 10


# Установка сервиса профилей
echo "..................................................."
echo "Step 3: Installing Profile Service..."

helm dependency build ./services/users-app/
helm install profile ./services/users-app -n profile

echo "Profile service installed."
wait_seconds 10


# Установка сервиса заказов
echo "..................................................."
echo "Step 4: Installing Order Service..."

helm dependency build ./services/orders-app/
helm install order ./services/orders-app -n order

echo "Order service installed."
wait_seconds 10


# Установка сервиса биллинга
echo "..................................................."
echo "Step 5: Installing Billing Service..."

helm dependency build ./services/billing-app/
helm install billing ./services/billing-app -n billing

echo "Billing service installed."
wait_seconds 10


# Устновка сервиса нотификаций
echo "..................................................."
echo "Step 6: Installing Notification Service..."

helm dependency build ./services/notif/
helm install notifications ./services/notif -n notif

echo "Notifications service installed."
wait_seconds 10


# Установка API Gateway
echo "..................................................."
echo "Step 7: Installing Client API Gateway..."

helm install client ./services/client-api -n client

echo "Client API Gateway installed."
wait_seconds 10


echo "========================================="
echo "Installation completed successfully!"
echo "========================================="

echo ""
echo "========================================="
echo "Installation summary:"
echo "========================================="
echo "1. Created namespaces: auth, profile, billing, order, client"
echo "2. Applied all required secrets"
echo "3. Installed services:"
echo "   - Profile Service"
echo "   - Auth Service"
echo "   - Billing Service"
echo "   - Order Service"
echo "   - Notification Service"
echo "   - API Gateway"
echo "========================================="

# Ожидание ввода пользователя
echo "Script execution completed. You may close this window."
read -p "Press Enter to continue..."