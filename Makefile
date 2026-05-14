
.PHONY: cluster-up cluster-down cluster-reset cluster-status miniio-deploy miniio-delete miniio-status mlflow-deploy mlflow-delete mlflow-status mlflow-logs buckets-apply buckets-destroy smoke-test



# k3d cluster management

cluster-up:
	./scripts/cluster.sh up

cluster-down:
	./scripts/cluster.sh down

cluster-reset: 
	./scripts/cluster.sh reset

cluster-status:
	./scripts/cluster.sh status



# minio

miniio-deploy:
	./scripts/miniio.sh deploy

miniio-delete:
	./scripts/miniio.sh delete

miniio-status:
	./scripts/miniio.sh status


# buckets

buckets-apply:
	./scripts/buckets.sh apply

buckets-destroy:
	./scripts/buckets.sh destroy


# mlflow

mlflow-deploy:
	./scripts/mlflow.sh deploy

mlflow-delete:
	./scripts/mlflow.sh delete

mlflow-status:
	./scripts/mlflow.sh status

mlflow-logs:
	./scripts/mlflow.sh logs


# tests

smoke-test:
	uv run src/smoke_test.py