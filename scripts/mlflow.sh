#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST_DIR="$REPO_ROOT/k8s/mlflow"
NAMESPACE="mlflow"

log() { echo -e "\033[36m[mlflow]\033[0m $*"; }

cmd_deploy() {
  log "applying manifests from $MANIFEST_DIR"
  kubectl apply -f "$MANIFEST_DIR/namespace.yaml"
  kubectl apply -f "$MANIFEST_DIR/secret.yaml"
  kubectl apply -f "$MANIFEST_DIR/pvc.yaml"
  kubectl apply -f "$MANIFEST_DIR/deployment.yaml"
  kubectl apply -f "$MANIFEST_DIR/service.yaml"

  log "waiting for mlflow to become ready (up to 3 min)"
  kubectl wait --for=condition=available deployment/mlflow \
    -n "$NAMESPACE" --timeout=180s

  log "mlflow is up: http://localhost:5000"
}

cmd_delete() {
  log "deleting mlflow (including PVC — all experiment metadata lost)"
  kubectl delete namespace "$NAMESPACE" --ignore-not-found
}

cmd_status() {
  kubectl get all,pvc,secret -n "$NAMESPACE"
}

cmd_logs() {
  kubectl logs -n "$NAMESPACE" deployment/mlflow --tail=100 -f
}

case "${1:-}" in
  deploy) cmd_deploy ;;
  delete) cmd_delete ;;
  status) cmd_status ;;
  logs)   cmd_logs ;;
  *)
    echo "usage: $0 {deploy|delete|status|logs}" >&2
    exit 1
    ;;
esac