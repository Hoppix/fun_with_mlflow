output "name" {
  description = "The bucket name."
  value       = minio_s3_bucket.bucket.bucket
}

output "url" {
  description = "S3 URL of the bucket."
  value       = minio_s3_bucket.bucket.bucket_domain_name
}