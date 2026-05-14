#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLUSTER_NAME="${CLUSTER_NAME:-zeit-mlops}"
IMAGE_NAME="${IMAGE_NAME:-zeit-mlops}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
FULL_IMAGE="$IMAGE_NAME:$IMAGE_TAG"

log() { echo -e "\033[36m[docker]\033[0m $*"; }

cmd_build() {
  log "building $FULL_IMAGE"
  pushd "$REPO_ROOT" > /dev/null
  trap 'popd > /dev/null' EXIT
  docker build -t "$FULL_IMAGE" .
}

cmd_import() {
  # Loads the local image directly into k3d nodes.
  log "importing $FULL_IMAGE into cluster $CLUSTER_NAME"
  k3d image import "$FULL_IMAGE" -c "$CLUSTER_NAME"
}

cmd_push() {
  cmd_build
  cmd_import
}

case "${1:-}" in
  build)  cmd_build ;;
  import) cmd_import ;;
  push)   cmd_push ;;
  *)
    echo "usage: $0 {build|import|push}" >&2
    exit 1
    ;;
esac