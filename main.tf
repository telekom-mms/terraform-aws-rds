// main.tf
# Written by Marc Straubinger - Overhauled for Security-First Best Practices and Feature Completeness

# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-db-subnet-group"
    "PSA-Compliant" = "true"
  })
}

# DB Parameter Group (Standard RDS)
resource "aws_db_parameter_group" "this" {
  count  = var.create_parameter_group && !var.create_aurora_cluster ? 1 : 0
  family = var.parameter_group_family
  name   = "${local.name_prefix}-db-params"

  # Security-focused parameters
  dynamic "parameter" {
    for_each = concat(
      var.engine == "postgres" ? var.postgres_security_parameters : (var.engine == "mysql" || var.engine == "mariadb" ? var.mysql_security_parameters : []),
      var.custom_parameters
    )
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-db-params"
    "PSA-Compliant" = "true"
  })
}

# Aurora Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "this" {
  count  = var.create_parameter_group && var.create_aurora_cluster ? 1 : 0
  family = var.parameter_group_family
  name   = "${local.name_prefix}-cluster-params"

  dynamic "parameter" {
    for_each = concat(
      var.engine == "postgres" ? var.postgres_security_parameters : (var.engine == "mysql" || var.engine == "mariadb" ? var.mysql_security_parameters : []),
      var.custom_parameters
    )
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-cluster-params"
    "PSA-Compliant" = "true"
  })
}

# KMS Key for RDS Encryption
resource "aws_kms_key" "rds" {
  count       = var.create_kms_key ? 1 : 0
  description = "KMS key for RDS encryption - ${local.name_prefix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow RDS Service"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-rds-kms-key"
    "Purpose"       = "RDS Encryption"
    "PSA-Compliant" = "true"
  })
}

resource "aws_kms_alias" "rds" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${local.name_prefix}-rds"
  target_key_id = aws_kms_key.rds[0].key_id
}

# RDS Instance (Standard)
resource "aws_db_instance" "this" {
  count = var.create_aurora_cluster ? 0 : 1

  identifier = "${local.name_prefix}-rds"

  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  storage_encrypted = true                                                         # PSA Compliance: Req 5 (database encryption)
  kms_key_id        = var.create_kms_key ? aws_kms_key.rds[0].arn : var.kms_key_id # PSA Compliance: Req 5 (database encryption)

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password
  port     = var.database_port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = false

  parameter_group_name = var.create_parameter_group ? aws_db_parameter_group.this[0].name : var.parameter_group_name

  backup_retention_period  = var.backup_retention_period # PSA Compliance: Req 5 (database backup)
  backup_window            = var.backup_window           # PSA Compliance: Req 5 (database backup)
  maintenance_window       = var.maintenance_window
  copy_tags_to_snapshot    = true
  delete_automated_backups = var.delete_automated_backups

  final_snapshot_identifier = "${local.name_prefix}-rds-final-snapshot"
  skip_final_snapshot       = var.skip_final_snapshot

  monitoring_interval             = var.enable_enhanced_monitoring ? 60 : 0
  monitoring_role_arn             = var.enable_enhanced_monitoring ? var.monitoring_role_arn : null
  performance_insights_enabled    = var.enable_performance_insights
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  deletion_protection                 = var.deletion_protection
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  ca_cert_identifier                  = var.ca_cert_identifier

  multi_az = var.multi_az

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-rds"
    "PSA-Compliant" = "true"
  })

  lifecycle {
    precondition {
      # If enhanced monitoring is enabled, monitoring_role_arn must be provided
      condition     = !var.enable_enhanced_monitoring || trimspace(var.monitoring_role_arn) != ""
      error_message = "monitoring_role_arn must be provided when enable_enhanced_monitoring is true."
    }
  }
}

# --- AURORA CLUSTER ---

resource "aws_rds_cluster" "this" {
  count = var.create_aurora_cluster ? 1 : 0

  cluster_identifier      = "${local.name_prefix}-cluster"
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period # PSA Compliance: Req 5 (database backup)
  preferred_backup_window = var.backup_window           # PSA Compliance: Req 5 (database backup)

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  storage_encrypted = true                                                         # PSA Compliance: Req 5 (database encryption)
  kms_key_id        = var.create_kms_key ? aws_kms_key.rds[0].arn : var.kms_key_id # PSA Compliance: Req 5 (database encryption)

  db_cluster_parameter_group_name = var.create_parameter_group ? aws_rds_cluster_parameter_group.this[0].name : null

  deletion_protection                 = var.deletion_protection
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.aurora_serverless_v2_scaling_configuration != null ? [var.aurora_serverless_v2_scaling_configuration] : []
    content {
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-cluster"
    "PSA-Compliant" = "true"
  })
}

resource "aws_rds_cluster_instance" "this" {
  count = var.create_aurora_cluster ? var.aurora_instance_count : 0

  identifier         = "${local.name_prefix}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this[0].engine
  engine_version     = aws_rds_cluster.this[0].engine_version

  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false

  performance_insights_enabled = var.enable_performance_insights
  monitoring_interval          = var.enable_enhanced_monitoring ? 60 : 0
  monitoring_role_arn          = var.enable_enhanced_monitoring ? var.monitoring_role_arn : null

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-instance-${count.index}"
    "PSA-Compliant" = "true"
  })

  lifecycle {
    precondition {
      # If enhanced monitoring is enabled, monitoring_role_arn must be provided
      condition     = !var.enable_enhanced_monitoring || trimspace(var.monitoring_role_arn) != ""
      error_message = "monitoring_role_arn must be provided when enable_enhanced_monitoring is true."
    }
  }
}

# --- DB PROXY ---

resource "aws_db_proxy" "this" {
  count = var.create_db_proxy ? 1 : 0

  name                   = "${local.name_prefix}-proxy"
  debug_logging          = false
  engine_family          = var.engine == "postgres" ? "POSTGRESQL" : "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = var.db_proxy_role_arn
  vpc_security_group_ids = var.security_group_ids
  vpc_subnet_ids         = var.subnet_ids

  dynamic "auth" {
    for_each = var.db_proxy_auth
    content {
      auth_scheme = auth.value.auth_scheme
      description = auth.value.description
      iam_auth    = auth.value.iam_auth
      secret_arn  = auth.value.secret_arn
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = "${local.name_prefix}-proxy"
    "PSA-Compliant" = "true"
  })

  lifecycle {
    precondition {
      condition     = var.db_proxy_role_arn != ""
      error_message = "db_proxy_role_arn is required when create_db_proxy is true."
    }
  }
}

resource "aws_db_proxy_default_target_group" "this" {
  count = var.create_db_proxy ? 1 : 0

  db_proxy_name = aws_db_proxy.this[0].name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "this" {
  count = var.create_db_proxy ? 1 : 0

  db_proxy_name          = aws_db_proxy.this[0].name
  target_group_name      = aws_db_proxy_default_target_group.this[0].name
  db_instance_identifier = var.create_aurora_cluster ? null : aws_db_instance.this[0].id
  db_cluster_identifier  = var.create_aurora_cluster ? aws_rds_cluster.this[0].id : null
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}
