#!/bin/bash

echo "Uninstalling on the way..."

echo "Uninstalling Kafka..."
helm uninstall kafka -n kafka 2>/dev/null || echo "Kafka not found or already uninstalled"
helm uninstall kafka-ui -n kafka 2>/dev/null || echo "Kafka-UI not found or already uninstalled"
echo "Kafka uninstalled. Waiting 3 seconds..."

echo "Uninstalling Nginx Service..."
helm uninstall nginx -n nginx 2>/dev/null || echo "Nginx not found or already uninstalled"
echo "Nginx uninstalled. Waiting 3 seconds..."

# echo "Deleting all namespaces..."
kubectl delete namespace kafka
kubectl delete namespace nginx


echo "Done!"