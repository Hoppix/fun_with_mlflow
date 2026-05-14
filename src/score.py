
import os
import time
from datetime import datetime, timezone

import boto3
import mlflow

MLFLOW_TRACKING_URI = os.getenv("MLFLOW_TRACKING_URI", "http://localhost:5000")
MODEL_NAME          = os.getenv("MLFLOW_MODEL_NAME", "nase-churn-classifier")
S3_ENDPOINT         = os.getenv("MLFLOW_S3_ENDPOINT_URL", "http://localhost:9000")
S3_ACCESS_KEY       = os.getenv("AWS_ACCESS_KEY_ID", "admin")
S3_SECRET_KEY       = os.getenv("AWS_SECRET_ACCESS_KEY", "admin123")
SCORES_BUCKET       = os.getenv("SCORES_BUCKET", "scores")


def main() -> None:
    mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)

    client = mlflow.MlflowClient()
    versions = client.search_model_versions(f"name='{MODEL_NAME}'")
    if not versions:
        raise RuntimeError(f"No '{MODEL_NAME}' in MLflow. Run training first.")
    version = max(versions, key=lambda v: int(v.version)).version
    print(f"would load {MODEL_NAME} v{version}")

    for i in range(3):
        print(f"scoring batch {i + 1}/3")
        time.sleep(0.3)

    fake_csv = "customer_id,churn_probability\n1,0.12\n2,0.87\n3,0.45\n"
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    key = f"scores-{ts}.csv"

    boto3.client(
        "s3",
        endpoint_url=S3_ENDPOINT,
        aws_access_key_id=S3_ACCESS_KEY,
        aws_secret_access_key=S3_SECRET_KEY,
        region_name="eu-central-1",
    ).put_object(Bucket=SCORES_BUCKET, Key=key, Body=fake_csv.encode())

    print(f"wrote s3://{SCORES_BUCKET}/{key}")


if __name__ == "__main__":
    main()