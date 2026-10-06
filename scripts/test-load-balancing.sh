#!/usr/bin/env bash
# Visits the frontend 20 times and counts which pod answered each time

set -euo pipefail

URL="${1:-http://$(minikube ip):30080}"

for i in $(seq 1 20); do
  curl -s "$URL" | grep -oE 'frontend-[a-z0-9]+-[a-z0-9]+' | head -1
done | sort | uniq -c
