#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-zeit-mlops}"
REGISTRY_NAME="${REGISTRY_NAME:-k3d-registry.localhost}"
REGISTRY_PORT="${REGISTRY_PORT:-5555}"

log() { echo -e "\033[36m[cluster]\033[0m $*"; }

cmd_up() {
  if ! k3d registry list 2>/dev/null | grep -q "$REGISTRY_NAME"; then
    log "creating registry $REGISTRY_NAME:$REGISTRY_PORT"
    k3d registry create "$REGISTRY_NAME" --port "$REGISTRY_PORT"
  else
    log "registry $REGISTRY_NAME already exists"
  fi

  if ! k3d cluster list 2>/dev/null | grep -q "$CLUSTER_NAME"; then
    log "creating cluster $CLUSTER_NAME"
    k3d cluster create "$CLUSTER_NAME" \
      --registry-use "$REGISTRY_NAME:$REGISTRY_PORT" \
      --agents 1 \
      --port "8080:80@loadbalancer" \
      --port "5000:5000@loadbalancer" \
      --port "9000:9000@loadbalancer" \
      --port "9001:9001@loadbalancer"
  else
    log "cluster $CLUSTER_NAME already exists"
  fi

  kubectl cluster-info --context "k3d-$CLUSTER_NAME"
}

cmd_down() {
  log "deleting cluster $CLUSTER_NAME (registry kept)"
  k3d cluster delete "$CLUSTER_NAME" || true
}

cmd_reset() {
  log "nuking cluster + registry"
  k3d cluster delete "$CLUSTER_NAME" || true
  k3d registry delete "$REGISTRY_NAME" || true
}

cmd_status() {
  kubectl get nodes -o wide
  echo
  kubectl get ns
}

case "${1:-}" in
  up)     cmd_up ;;
  down)   cmd_down ;;
  reset)  cmd_reset ;;
  status) cmd_status ;;
  *)
    echo "usage: $0 {up|down|reset|status}" >&2
    exit 1
    ;;
esac