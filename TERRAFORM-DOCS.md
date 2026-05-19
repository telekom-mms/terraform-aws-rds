<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.1 |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_proxy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy) | resource |
| [aws_db_proxy_default_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group) | resource |
| [aws_db_proxy_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_alias.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g., prod, dev, test) | `string` | n/a | yes |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password for the master DB user. Note that this may show up in logs, and it is recommended to use Secrets Manager. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of VPC security groups to associate | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs | `list(string)` | n/a | yes |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes | `number` | `20` | no |
| <a name="input_aurora_instance_count"></a> [aurora\_instance\_count](#input\_aurora\_instance\_count) | Number of Aurora instances in the cluster | `number` | `2` | no |
| <a name="input_aurora_serverless_v2_scaling_configuration"></a> [aurora\_serverless\_v2\_scaling\_configuration](#input\_aurora\_serverless\_v2\_scaling\_configuration) | Aurora Serverless v2 scaling configuration | <pre>object({<br/>    max_capacity = number<br/>    min_capacity = number<br/>  })</pre> | `null` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `7` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled | `string` | `"03:00-06:00"` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | The identifier of the CA certificate for the DB instance | `string` | `"rds-ca-rsa2048-g1"` | no |
| <a name="input_create_aurora_cluster"></a> [create\_aurora\_cluster](#input\_create\_aurora\_cluster) | Whether to create an Aurora cluster instead of a standard RDS instance | `bool` | `false` | no |
| <a name="input_create_db_proxy"></a> [create\_db\_proxy](#input\_create\_db\_proxy) | Whether to create an RDS Proxy | `bool` | `false` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether to create a KMS key for RDS encryption | `bool` | `true` | no |
| <a name="input_create_parameter_group"></a> [create\_parameter\_group](#input\_create\_parameter\_group) | Whether to create a custom parameter group | `bool` | `true` | no |
| <a name="input_create_read_replica"></a> [create\_read\_replica](#input\_create\_read\_replica) | Whether to create a read replica | `bool` | `false` | no |
| <a name="input_custom_parameters"></a> [custom\_parameters](#input\_custom\_parameters) | Custom parameters to add to the parameter group | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database to create when the DB instance is created | `string` | `null` | no |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | The port on which the DB accepts connections | `number` | `5432` | no |
| <a name="input_db_proxy_auth"></a> [db\_proxy\_auth](#input\_db\_proxy\_auth) | Configuration block for DB Proxy authentication | <pre>list(object({<br/>    auth_scheme = string<br/>    description = optional(string)<br/>    iam_auth    = optional(string)<br/>    secret_arn  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_db_proxy_role_arn"></a> [db\_proxy\_role\_arn](#input\_db\_proxy\_role\_arn) | ARN of the IAM role for RDS Proxy to access Secrets Manager | `string` | `""` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Specifies whether to remove automated backups immediately after the DB instance is deleted | `bool` | `false` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true | `bool` | `true` | no |
| <a name="input_enable_enhanced_monitoring"></a> [enable\_enhanced\_monitoring](#input\_enable\_enhanced\_monitoring) | Specifies whether Enhanced Monitoring is enabled | `bool` | `false` | no |
| <a name="input_enable_performance_insights"></a> [enable\_performance\_insights](#input\_enable\_performance\_insights) | Specifies whether Performance Insights are enabled | `bool` | `true` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs | `list(string)` | <pre>[<br/>  "postgresql",<br/>  "upgrade"<br/>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use (postgres, mysql, mariadb, oracle-ee, sqlserver-ex, etc.) | `string` | `"postgres"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | `"15.4"` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether mapping of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `true` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `"db.t3.medium"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of an existing KMS key to use for encryption | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `"dbadmin"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | The upper limit to which Amazon RDS can automatically scale the storage of the DB instance | `number` | `100` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs | `string` | `""` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `true` | no |
| <a name="input_mysql_security_parameters"></a> [mysql\_security\_parameters](#input\_mysql\_security\_parameters) | Security-focused parameters for MySQL/MariaDB | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "require_secure_transport",<br/>    "value": "ON"<br/>  },<br/>  {<br/>    "name": "log_warnings",<br/>    "value": "2"<br/>  }<br/>]</pre> | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names (if not provided, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | The family of the DB parameter group | `string` | `"postgres15"` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the existing DB parameter group to use (if create\_parameter\_group is false) | `string` | `null` | no |
| <a name="input_postgres_security_parameters"></a> [postgres\_security\_parameters](#input\_postgres\_security\_parameters) | Security-focused parameters for PostgreSQL | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "rds.force_ssl",<br/>    "value": "1"<br/>  },<br/>  {<br/>    "name": "log_connections",<br/>    "value": "1"<br/>  },<br/>  {<br/>    "name": "log_disconnections",<br/>    "value": "1"<br/>  },<br/>  {<br/>    "name": "log_checkpoints",<br/>    "value": "1"<br/>  },<br/>  {<br/>    "name": "log_lock_waits",<br/>    "value": "1"<br/>  }<br/>]</pre> | no |
| <a name="input_replica_instance_class"></a> [replica\_instance\_class](#input\_replica\_instance\_class) | The instance type of the RDS read replica | `string` | `"db.t3.medium"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot | `string` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (general purpose SSD), or 'io1' (provisioned IOPS SSD) | `string` | `"gp3"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the Aurora cluster |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | The ARN of the RDS instance |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The RDS instance ID |
| <a name="output_db_proxy_endpoint"></a> [db\_proxy\_endpoint](#output\_db\_proxy\_endpoint) | The endpoint of the RDS Proxy |
| <a name="output_db_proxy_id"></a> [db\_proxy\_id](#output\_db\_proxy\_id) | The ID of the RDS Proxy |
| <a name="output_db_subnet_group_name"></a> [db\_subnet\_group\_name](#output\_db\_subnet\_group\_name) | The name of the DB subnet group |
| <a name="output_instance_identifier"></a> [instance\_identifier](#output\_instance\_identifier) | The primary database instance identifier |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_monitoring_role_arn"></a> [monitoring\_role\_arn](#output\_monitoring\_role\_arn) | The IAM role ARN used for enhanced monitoring |
| <a name="output_parameter_group_name"></a> [parameter\_group\_name](#output\_parameter\_group\_name) | The name of the active parameter group |
<!-- END_TF_DOCS -->