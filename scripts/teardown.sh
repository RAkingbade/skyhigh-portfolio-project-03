#!/usr/bin/env bash
# Removes everything this project created on your laptop

set -euo pipefail

echo "🧹 Removing Kubernetes resources..."
kubectl delete -f k8s/ --ignore-not-found

echo "🧹 Stopping Docker Compose (if running)..."
docker compose down || true

echo "🛑 Stopping minikube (frees your laptop's memory)..."
minikube stop

echo "✅ Teardown complete"
