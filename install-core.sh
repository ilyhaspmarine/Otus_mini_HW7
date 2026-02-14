#!/bin/bash

# Установочный скрипт для развертывания Core-компонентов (Nginx, Kafka etc.)
echo "Starting installation..."

# Функция для ожидания
wait_seconds() {
    local seconds=$1
    echo "Waiting $seconds seconds..."
    sleep $seconds
}

# Создание namespace и применение секретов
echo "Step 1: Creating namespaces and applying secrets..."

kubectl create namespace nginx
kubectl create namespace kafka

kubectl apply -f ./secrets/kafka_secret.yaml -n kafka

# Добавление helm репозиториев
echo "Step 2: Adding Helm repositories..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx/
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
helm repo update


# # Установка мониторинга
# echo "Step 3: Installing monitoring stack..."
# helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
#   -f install/monitoring/prometheus.yaml \
#   -f install/monitoring/grafana.yaml \
#   --namespace zsvv-monitoring \
#   --create-namespace

# echo "Monitoring stack installed. Waiting 20 seconds..."
# wait_seconds 40

# Установка ingress контроллера
echo "Step 3: Installing NGINX Ingress Controller..."
helm upgrade --install nginx ingress-nginx/ingress-nginx --namespace nginx -f ./nginx/nginx_values.yaml

echo "NGINX Ingress Controller installed..."
wait_seconds 30

# Установка Kafka
echo "Step 4: Installing Kafka..."
helm dependency build ./kafka/kafka/
helm upgrade --install kafka ./kafka/kafka/ -n kafka --create-namespace

echo "Kafka installed..."
wait_seconds 10

# Установка Kafka UI
echo "Step 6: Installing Kafka UI..."
helm dependency build ./kafka/kafka-ui/
helm upgrade --install kafka-ui ./kafka/kafka-ui/ -n kafka --create-namespace

echo "Kafka UI installed..."
wait_seconds 10


echo "========================================="
echo "Installation completed successfully!"
echo "========================================="

echo ""
echo "========================================="
echo "Installation summary:"
echo "========================================="
echo "1. Created namespaces: nginx, kafka"
echo "2. Applied all required secrets"
# echo "4. Installed Monitoring stack in zsvv-monitoring"
echo "3. Installed NGINX Ingress in nginx namespace"
echo "4. Installed Kafka infrastructure:"
echo "   - Kafka"
echo "   - Kafka UI"
echo "========================================="

# Ожидание ввода пользователя
echo "Script execution completed. You may close this window."
read -p "Press Enter to continue..."