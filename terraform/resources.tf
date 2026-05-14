module "mlflow_artifacts" {
  source        = "../../modules/bucket"
  name          = "mlflow-artifacts"
  force_destroy = true
}

module "training_data" {
  source        = "../../modules/bucket"
  name          = "training-data"
  force_destroy = true

  initial_object = {
    key     = "README.txt"
    content = "data goes here"
  }
}

module "scores" {
  source        = "../../modules/bucket"
  name          = "scores"
  force_destroy = true
}