#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-buckets}"

log() { echo -e "\033[36m[buckets]\033[0m $*"; }

cmd_destroy() {
    pushd terraform > /dev/null
    terraform destroy -auto-approve
    popd > /dev/null
}

cmd_apply() {
    pushd terraform > /dev/null
    terraform apply -auto-approve
    popd > /dev/null
}


case "${1:-}" in
  apply) cmd_apply ;;
  destroy) cmd_destroy ;;
  *)
    echo "usage: $0 {apply|destroy}" >&2
    exit 1
    ;;
esac