#!/usr/bin/env bash
# Deploys the whole app to Kubernetes and waits until it's healthy

set -euo pipefail

echo "🎛️  Creating config first (ConfigMap and Secret)..."
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

echo "📦 Applying the rest of the manifests..."
kubectl apply -f k8s/

echo "⏳ Waiting for backend to be ready..."
kubectl rollout status deployment/backend --timeout=120s

echo "⏳ Waiting for frontend to be ready..."
kubectl rollout status deployment/frontend --timeout=120s

echo ""
echo "--- Pods ---"
kubectl get pods -o wide

echo ""
echo "--- Services ---"
kubectl get services

echo ""
echo "--- Endpoints (which pods each Service forwards to) ---"
kubectl get endpoints

echo ""
echo "🌐 Open this in your browser: http://$(minikube ip):30080"
