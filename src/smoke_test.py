import os
import mlflow

os.environ["MLFLOW_TRACKING_URI"]      = "http://localhost:5000"
os.environ["MLFLOW_S3_ENDPOINT_URL"]   = "http://localhost:9000"
os.environ["AWS_ACCESS_KEY_ID"]        = "admin"
os.environ["AWS_SECRET_ACCESS_KEY"]    = "admin123"

mlflow.set_experiment("smoke-test")
with mlflow.start_run():
    mlflow.log_param("p", 1)
    mlflow.log_metric("m", 0.42)
    with open("/tmp/hello.txt", "w") as f:
        f.write("hi")
    mlflow.log_artifact("/tmp/hello.txt")

print("done")