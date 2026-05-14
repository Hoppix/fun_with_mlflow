variable "name" {
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.name))
    error_message = "Bucket name must be 3-63 chars, lowercase alphanumeric/dots/hyphens, and start/end with alphanumeric."
  }
}

variable "force_destroy" {
  description = "Delete bucket even if it contains objects. Useful for dev, dangerous for prod."
  type        = bool
  default     = false
}

variable "initial_object" {
  description = "Optional seed object to upload on creation."
  type = object({
    key     = string
    content = string
  })
  default = null

  validation {
    condition     = var.initial_object == null || (try(length(var.initial_object.key), 0) > 0)
    error_message = "If initial_object is set, its key must be non-empty."
  }
}