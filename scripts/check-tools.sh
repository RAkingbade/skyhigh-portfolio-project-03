#!/usr/bin/env bash
# Checks that every tool for Project 3 is installed (like taking attendance)

for tool in docker kubectl minikube git code; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "✅ $tool is installed"
  else
    echo "❌ $tool is MISSING"
  fi
done

echo ""
echo "--- Versions ---"
docker --version
docker compose version
kubectl version --client
minikube version
