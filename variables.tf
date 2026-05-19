// variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, dev, test)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names (if not provided, will use project-environment pattern)"
  type        = string
  default     = ""
}


variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "engine" {
  description = "The database engine to use (postgres, mysql, mariadb, oracle-ee, sqlserver-ex, etc.)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  type        = string
  default     = "gp3"
}

variable "database_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = null
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "dbadmin" # PSA Req 7: Avoid default names like 'admin' or 'postgres'

  validation {
    condition = can(regex("^[A-Za-z][A-Za-z0-9_]{0,15}$", var.master_username)) && !contains([
      "admin",
      "administrator",
      "master",
      "postgres",
      "root"
    ], lower(var.master_username))
    error_message = "master_username must start with a letter, be 1-16 characters using only letters, numbers, and underscores, and must not use reserved generic admin usernames."
  }
}

variable "master_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it is recommended to use Secrets Manager."
  type        = string
  sensitive   = true
}

variable "database_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true # Best practice for production
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled"
  type        = string
  default     = "03:00-06:00"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = true # Security first
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false # Best practice: always create final snapshot
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs"
  type        = list(string)
  default     = ["postgresql", "upgrade"]
}

variable "log_retention_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 30
}

variable "enable_performance_insights" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = true
}

variable "enable_enhanced_monitoring" {
  description = "Interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = bool
  default     = true
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = string
  default     = ""
}

variable "create_parameter_group" {
  description = "Whether to create a custom parameter group"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "Name of the existing DB parameter group to use (if create_parameter_group is false)"
  type        = string
  default     = null
}

variable "parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "postgres15"
}

variable "postgres_security_parameters" {
  description = "Security-focused parameters for PostgreSQL"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    { name = "rds.force_ssl", value = "1" }, # PSA Req 2: Enforce TLS
    { name = "log_connections", value = "1" },
    { name = "log_disconnections", value = "1" },
    { name = "log_checkpoints", value = "1" },
    { name = "log_lock_waits", value = "1" }
  ]
}

variable "mysql_security_parameters" {
  description = "Security-focused parameters for MySQL/MariaDB"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    { name = "require_secure_transport", value = "ON" }, # PSA Req 2: Enforce TLS
    { name = "log_warnings", value = "2" }
  ]
}

variable "custom_parameters" {
  description = "Custom parameters to add to the parameter group"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "create_kms_key" {
  description = "Whether to create a KMS key for RDS encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN of an existing KMS key to use for encryption"
  type        = string
  default     = ""
}

variable "create_read_replica" {
  description = "Whether to create a read replica"
  type        = bool
  default     = false
}

variable "replica_instance_class" {
  description = "The instance type of the RDS read replica"
  type        = string
  default     = "db.t3.medium"
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = false # Security first: keep backups
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether mapping of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = true # Best practice: enable IAM auth
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-rsa2048-g1" # Latest standard CA
}

# --- ADVANCED SUPERMARKET FEATURES ---

variable "create_aurora_cluster" {
  description = "Whether to create an Aurora cluster instead of a standard RDS instance"
  type        = bool
  default     = false
}

variable "aurora_instance_count" {
  description = "Number of Aurora instances in the cluster"
  type        = number
  default     = 2
}

variable "aurora_serverless_v2_scaling_configuration" {
  description = "Aurora Serverless v2 scaling configuration"
  type = object({
    max_capacity = number
    min_capacity = number
  })
  default = null
}

variable "create_db_proxy" {
  description = "Whether to create an RDS Proxy"
  type        = bool
  default     = false
}

variable "db_proxy_auth" {
  description = "Configuration block for DB Proxy authentication"
  type = list(object({
    auth_scheme = string
    description = optional(string)
    iam_auth    = optional(string)
    secret_arn  = string
  }))
  default = []
}
