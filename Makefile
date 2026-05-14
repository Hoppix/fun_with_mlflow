
.PHONY: cluster-up cluster-down cluster-reset cluster-status miniio-deploy miniio-delete miniio-status mlflow-deploy mlflow-delete mlflow-status mlflow-logs buckets-apply buckets-destroy smoke-test all reset train-local score-local



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


# python

smoke-test:
	uv run src/smoke_test.py

make train-local:
	uv run src/train.py 

make score-local:
	uv run src/score.py


# one-button commands


all: cluster-up miniio-deploy buckets-apply mlflow-deploy smoke-test
	@echo ""
	@echo "Stack is up:"
	@echo "  MLflow UI:     http://localhost:5000"
	@echo "  MinIO console: http://localhost:9001  (admin / admin123)"

reset:
	-./scripts/buckets.sh destroy
	-./scripts/cluster.sh reset
	@rm -rf terraform/envs/local/.terraform terraform/envs/local/*.tfstate*
	@echo "Reset complete."