#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST_DIR="$REPO_ROOT/k8s/dags"

log() { echo -e "\033[36m[jobs]\033[0m $*"; }

ensure_secret() {
  kubectl apply -f "$MANIFEST_DIR/secrets.yaml" > /dev/null
}

run_job() {
  local manifest="$1"
  ensure_secret

  log "creating job from $manifest"
  local job_name
  job_name=$(kubectl create -f "$manifest" -o jsonpath='{.metadata.name}')
  log "  -> $job_name"

  log "waiting for pod to start"
  # Wait until the job has a pod that's at least past the Pending state.
  # `kubectl logs -f job/...` will block until ready and then stream, so this
  # is mostly a guard against confusing errors if the image fails to load.
  for _ in {1..30}; do
    phase=$(kubectl get pods --selector="batch.kubernetes.io/job-name=$job_name" \
      -o jsonpath='{.items[0].status.phase}' 2>/dev/null || true)
    [[ "$phase" == "Running" || "$phase" == "Succeeded" || "$phase" == "Failed" ]] && break
    sleep 1
  done

  log "streaming logs:"
  echo "----"
  kubectl logs -f "job/$job_name" || true
  echo "----"

  log "final status:"
  kubectl get "job/$job_name"
}

cmd_train()    { run_job "$MANIFEST_DIR/train.yaml"; }
cmd_score()    { run_job "$MANIFEST_DIR/score.yaml"; }

cmd_list() {
  kubectl get jobs -l app=zeit-mlops
}

cmd_clean() {
  log "deleting all dags"
  kubectl delete jobs -l app=zeit-mlops --ignore-not-found
}

case "${1:-}" in
  train) cmd_train ;;
  score) cmd_score ;;
  list)  cmd_list ;;
  clean) cmd_clean ;;
  *)
    echo "usage: $0 {train|score|list|clean}" >&2
    exit 1
    ;;
esac