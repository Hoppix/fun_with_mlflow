
import os
import time

import mlflow
import numpy as np
from sklearn.dummy import DummyClassifier

MLFLOW_TRACKING_URI = os.getenv("MLFLOW_TRACKING_URI", "http://localhost:5000")
EXPERIMENT_NAME    = os.getenv("MLFLOW_EXPERIMENT_NAME", "churn-classifier")
MODEL_NAME         = os.getenv("MLFLOW_MODEL_NAME", "nase-churn-classifier")

os.environ["MLFLOW_TRACKING_URI"]      = "http://localhost:5000"
# os.environ["MLFLOW_S3_ENDPOINT_URL"]   = "http://localhost:9000"
os.environ["AWS_ACCESS_KEY_ID"]        = "admin"
os.environ["AWS_SECRET_ACCESS_KEY"]    = "admin123"


def main() -> None:
    mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)
    mlflow.set_experiment(EXPERIMENT_NAME)

    with mlflow.start_run() as run:
        mlflow.log_params({"epochs": 3, "learning_rate": 0.01, "model_type": "fake"})

        for epoch in range(3):
            print(f"training epoch {epoch + 1}/3")
            mlflow.log_metric("loss", 1.0 / (epoch + 1), step=epoch)
            time.sleep(0.5)

        # Create and train a simple dummy model
        X = np.array([[1, 2], [3, 4], [5, 6], [7, 8]])
        y = np.array([0, 1, 0, 1])
        
        model = DummyClassifier(strategy="most_frequent")
        model.fit(X, y)
        
        # Log the model using mlflow.sklearn
        mlflow.sklearn.log_model(model, MODEL_NAME)

        mlflow.register_model(f"runs:/{run.info.run_id}/{MODEL_NAME}", MODEL_NAME)
        print(f"done — run {run.info.run_id}")


if __name__ == "__main__":
    main()