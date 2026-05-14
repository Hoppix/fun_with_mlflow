variable "minio_endpoint" {
  type        = string
  default     = "localhost:9000"
}

variable "minio_user" {
  type        = string
}

variable "minio_password" {
  type        = string
  sensitive   = true
}