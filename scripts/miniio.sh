#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-minio}"

log() { echo -e "\033[36m[minio]\033[0m $*"; }

cmd_deploy() {
  log "applying manifests"
  kubectl apply -f k8s/miniio.yaml

  log "waiting for minio to become ready (up to 3 min)"
  kubectl wait --for=condition=available deployment/minio \
    -n "$NAMESPACE" --timeout=180s

  log "minio is up:"
  echo "  S3 API:  http://localhost:9000"
  echo "  Console: http://localhost:9001  (user: minioadmin / pw: minioadmin123)"
}

cmd_delete() {
  log "deleting minio (including PVC — all data lost)"
  kubectl delete -f k8s/miniio.yaml --ignore-not-found
}

cmd_status() {
  kubectl get all,pvc -n "$NAMESPACE"
}

case "${1:-}" in
  deploy) cmd_deploy ;;
  delete) cmd_delete ;;
  status) cmd_status ;;
  *)
    echo "usage: $0 {deploy|delete|status}" >&2
    exit 1
    ;;
esac