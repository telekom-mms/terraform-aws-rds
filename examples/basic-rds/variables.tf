// examples/basic-rds/variables.tf

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "example-rds"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "terraform"
    Project     = "rds-example"
  }
}
