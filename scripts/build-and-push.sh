#!/usr/bin/env bash
# Builds both images with a version tag and pushes them to Docker Hub
# Usage: ./scripts/build-and-push.sh v1

set -euo pipefail

DOCKERHUB_USER="${DOCKERHUB_USER:?Set it first: export DOCKERHUB_USER=yourname}"
TAG="${1:-v1}"

for svc in backend frontend; do
  IMAGE="${DOCKERHUB_USER}/skyhigh-${svc}:${TAG}"
  echo "🔨 Building ${IMAGE}"
  docker build -t "${IMAGE}" "./${svc}"
  echo "📤 Pushing ${IMAGE}"
  docker push "${IMAGE}"
done

echo "✅ Done. Your images:"
docker images | grep "skyhigh"
