#!/bin/bash

echo "Uninstalling on the way..."

echo "Uninstalling Auth Service..."
helm uninstall auth -n auth 2>/dev/null || echo "Auth Service not found or already uninstalled"
echo "Auth Service uninstalled. Waiting 3 seconds..."


echo "Uninstalling Profile Service..."
helm uninstall profile -n profile 2>/dev/null || echo "Profile Service not found or already uninstalled"
echo "Profile Service uninstalled. Waiting 3 seconds..."

echo "Uninstalling Notification Service..."
helm uninstall notifications -n notif 2>/dev/null || echo "Notification Service not found or already uninstalled"
echo "Notification Service uninstalled. Waiting 3 seconds..."

echo "Uninstalling Order Service..."
helm uninstall order -n order 2>/dev/null || echo "Order Service not found or already uninstalled"
echo "Order Service uninstalled. Waiting 230 seconds..."

echo "Uninstalling Billing Service..."
helm uninstall billing -n billing 2>/dev/null || echo "Billing Service not found or already uninstalled"
echo "Billing Service uninstalled. Waiting 3 seconds..."

echo "Uninstalling Notification Service..."
helm uninstall notifications -n notif 2>/dev/null || echo "Notification Service not found or already uninstalled"
echo "Notification Service uninstalled. Waiting 3 seconds..."

echo "Uninstalling API GAteway Service..."
helm uninstall client -n client 2>/dev/null || echo "API Gateway Service not found or already uninstalled"
echo "API Gateway Service uninstalled. Waiting 3 seconds..."

echo "Deleting all namespaces..."
kubectl delete namespace auth
kubectl delete namespace profile
kubectl delete namespace order
kubectl delete namespace billing
kubectl delete namespace client
kubectl delete namespace notif
# echo "notif"
# kubectl delete namespace notif
echo "Done!"