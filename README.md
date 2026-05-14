# Fun with MLOps

Local MLOps platform for training and scoring a subscription-churn classifier.
The entire stack runs on a developer laptop via k3d, with the stateful pieces
provisioned through Terraform.

This is a deliberately small, end-to-end setup. The goal is to show how the
pieces fit together — cluster, storage, model tracking, jobs — not to build
production-grade infrastructure on day one.

## Notes

* MiniO has been deprecated as of 25.04.2026, would not use further.
* Usually I would add a backend configuration to the Terraform code, but since this is a test project, I will just use the local state file.
* Credential Management is nonexistent, which is a no-go for production but fine for this demo. In a real setup, I'd integrate something like HashiCorp Vault or AWS SSM or Workload Identity to avoid hardcoding secrets in the manifests.

## Getting started

### Prerequisites

- Docker Desktop (WSL2 backend on Windows, always hacky) 
- `k3d` ≥ v5
- `kubectl`
- `terraform` ≥ 1.6
- `make`
- Python 3.11+ for running the training/scoring scripts during development

### Bring it up

```bash
make cluster-up        # k3d cluster + local image registry
make minio-deploy      # MinIO server
make buckets-apply     # one-time Terraform init
make mlflow-deploy     # MLflow Tracking Server
```

```bash
make all                 # do it all in one go
```

### Verify

| What | Where | Login |
|---|---|---|
| MLflow UI | http://localhost:5000 | — |
| MinIO console | http://localhost:9001 | `admin` / `admin123` |
| Cluster health | `make cluster-status` | — |
| Run smoke test | `make smoke-test` | — |

### Tear down

```bash
make buckets-destroy   # remove buckets
make mlflow-delete     # remove MLflow (deletes metadata)
make minio-delete      # remove MinIO (deletes data)
make cluster-reset     # destroy cluster + local registry
```

```
make reset             # do it all in one go
```

## Repository layout

```
.
├── Makefile                # Single user-facing entrypoint
├── scripts/                # Bash scripts the Makefile delegates to
│   ├── cluster.sh
│   ├── minio.sh
│   ├── mlflow.sh
│   └── terraform.sh
├── k8s/                    # Kubernetes manifests (in-cluster runtime)
│   ├── minio/
│   └── mlflow/
├── terraform/              # IaC for stateful resources (buckets)
│   ├── modules/
│   │   └── bucket/         # Reusable bucket module with validation
└── src/                    # Any code related
```