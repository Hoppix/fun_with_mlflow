resource "minio_s3_bucket" "bucket" {
  bucket        = var.name
  force_destroy = var.force_destroy
}

resource "minio_s3_object" "initial_object" {
  count = var.initial_object != null ? 1 : 0

  bucket_name  = minio_s3_bucket.bucket.bucket
  object_name  = var.initial_object.key
  content      = var.initial_object.content
  content_type = "application/octet-stream"
}