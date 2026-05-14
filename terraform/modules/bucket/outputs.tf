output "name" {
  description = "The bucket name."
  value       = minio_s3_bucket.this.bucket
}

output "url" {
  description = "S3 URL of the bucket."
  value       = minio_s3_bucket.this.bucket_domain_name
}