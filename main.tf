/**
 * Module usage:
 * 
 *     module "rds" {
 *        source                = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"
 *
 *         name                         = "fake"
 *        allocated_storage            = "20"
 *        apply_immediately            = false
 *        cidr_blocks                  = ["${values(var.compute.cidrs)}"]
 *        database_name                = "keycloak"
 *        database_password            = "password"
 *        database_port                = "3306"
 *        database_user                = "root"
 *        db_parameter_family          = "default.mysql5.6"
 *        dns_zone                     = "${var.dns\_zone}"
 *        engine_type                  = "MariaDB"
 *        engine_version               = "10.1.19"
 *        environment                  = "${var.environment}"
 *        instance_class               = "db.t2.medium"
 *        max_allocated_storage        = 100
 *        snapshot_identifier          = "rds:production-2015-06-26-06-05"
 *        performance_insights_enabled = true
 */

locals {
  db_subnet_group_name = var.subnet_group_name != "" || length(aws_db_subnet_group.db) != 0 ? element(compact(concat([var.subnet_group_name], aws_db_subnet_group.db.*.id)), 0) : ""
  rds_instance_arn = element(concat(compact(concat(
    aws_db_instance.db_including_name.*.arn,
    aws_db_instance.db_read_replica.*.arn,
    aws_db_instance.db_excluding_name.*.arn,
    aws_rds_cluster_instance.aurora_cluster_instance.*.arn,
  )), [""]), 0)
  rds_cluster_arn = join("", aws_rds_cluster.aurora_cluster.*.arn)
  target_arn      = element(concat(compact([local.rds_cluster_arn, local.rds_instance_arn]), [""]), 0)
  rds_instance_resource_id = element(concat(compact(concat(
    aws_db_instance.db_including_name.*.resource_id,
    aws_db_instance.db_read_replica.*.resource_id,
    aws_db_instance.db_excluding_name.*.resource_id,
    aws_rds_cluster_instance.aurora_cluster_instance.*.dbi_resource_id,
  )), [""]), 0)
  email_tags = { for i, email in var.email_addresses : "email${i}" => email }
}

# Get the hosting zone
data "aws_route53_zone" "selected" {
  name = "${var.dns_zone}."
}

# Security Group used to manage access to the RDS instance
resource "aws_security_group" "db" {
  name        = "${var.name}-sg-rds"
  description = "The security group used to manage access to rds: ${var.name}, environment: ${var.environment}"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Ingress Rule to permit inbound database port
resource "aws_security_group_rule" "database_port" {
  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.db.id
}

# Egress Rule to permit outbound to all
resource "aws_security_group_rule" "out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}

# The database instance with created database
resource "aws_db_instance" "db_including_name" {
  count = var.database_name != "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" && var.replicate_source_db == "" ? 1 : 0

  db_name                               = var.database_name
  allocated_storage                     = var.allocated_storage
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  db_subnet_group_name                  = local.db_subnet_group_name
  engine                                = var.engine_type
  engine_version                        = var.engine_version
  final_snapshot_identifier             = var.name
  identifier                            = var.name
  instance_class                        = var.instance_class
  license_model                         = var.license_model
  maintenance_window                    = var.maintenance_window
  max_allocated_storage                 = var.max_allocated_storage
  multi_az                              = var.is_multi_az
  parameter_group_name                  = aws_db_parameter_group.db.id
  option_group_name                     = var.custom_option_group_name != "" ? var.custom_option_group_name : null
  password                              = var.database_password
  port                                  = var.database_port
  publicly_accessible                   = var.publicly_accessible
  vpc_security_group_ids                = [aws_security_group.db.id]
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  username                              = var.database_user
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# The database instance itself with read replica
resource "aws_db_instance" "db_read_replica" {
  count = var.replicate_source_db != "" ? 1 : 0

  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  final_snapshot_identifier             = var.name
  identifier                            = var.name
  instance_class                        = var.instance_class
  license_model                         = var.license_model
  maintenance_window                    = var.maintenance_window
  multi_az                              = var.is_multi_az
  parameter_group_name                  = aws_db_parameter_group.db.id
  option_group_name                     = var.custom_option_group_name != "" ? var.custom_option_group_name : null
  port                                  = var.database_port
  publicly_accessible                   = var.publicly_accessible
  vpc_security_group_ids                = [aws_security_group.db.id]
  replicate_source_db                   = var.replicate_source_db
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# The database instance without created database
resource "aws_db_instance" "db_excluding_name" {
  count = var.database_name == "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" && var.replicate_source_db == "" ? 1 : 0

  allocated_storage                     = var.allocated_storage
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  db_subnet_group_name                  = local.db_subnet_group_name
  engine                                = var.engine_type
  engine_version                        = var.engine_version
  final_snapshot_identifier             = var.name
  identifier                            = var.name
  instance_class                        = var.instance_class
  license_model                         = var.license_model
  maintenance_window                    = var.maintenance_window
  max_allocated_storage                 = var.max_allocated_storage
  multi_az                              = var.is_multi_az
  parameter_group_name                  = aws_db_parameter_group.db.id
  option_group_name                     = var.custom_option_group_name != "" ? var.custom_option_group_name : null
  password                              = var.database_password
  port                                  = var.database_port
  publicly_accessible                   = var.publicly_accessible
  vpc_security_group_ids                = [aws_security_group.db.id]
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  username                              = var.database_user
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Cluster for Amazon Aurora
resource "aws_rds_cluster" "aurora_cluster" {
  # aurora = MySQL 5.6-compatible, aurora-mysql = MySQL 5.7-compatible
  count = var.engine_type == "aurora" || var.engine_type == "aurora-mysql" || var.engine_type == "aurora-postgresql" ? 1 : 0

  apply_immediately               = var.apply_immediately
  backup_retention_period         = var.backup_retention_period
  cluster_identifier              = var.name
  database_name                   = var.database_name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db[0].id
  db_subnet_group_name            = local.db_subnet_group_name
  engine                          = var.engine_type
  engine_version                  = var.engine_version
  final_snapshot_identifier       = var.name
  master_password                 = var.database_password
  master_username                 = var.database_user
  port                            = var.database_port
  preferred_backup_window         = var.backup_window
  preferred_maintenance_window    = var.maintenance_window
  skip_final_snapshot             = var.skip_final_snapshot
  snapshot_identifier             = var.snapshot_identifier
  storage_encrypted               = var.storage_encrypted
  vpc_security_group_ids          = [aws_security_group.db.id]
}

# Aurora cluster instance
resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  count = var.engine_type == "aurora" || var.engine_type == "aurora-mysql" || var.engine_type == "aurora-postgresql" ? var.number_of_aurora_instances : 0

  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  apply_immediately            = var.apply_immediately
  cluster_identifier           = aws_rds_cluster.aurora_cluster[0].id
  db_subnet_group_name         = local.db_subnet_group_name
  db_parameter_group_name      = aws_db_parameter_group.db.id
  engine                       = var.engine_type
  identifier                   = "${var.name}${count.index > 0 ? "-${count.index}" : ""}"
  instance_class               = var.instance_class
  publicly_accessible          = var.publicly_accessible
  preferred_maintenance_window = var.maintenance_window
  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Create the database parameters
resource "aws_db_parameter_group" "db" {
  name = "${var.name}-db-parameters"

  description = "Database Parameters Group for RDS: ${var.environment}.${var.name}"
  family      = var.db_parameter_family

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Create the RDS cluster parameters
resource "aws_rds_cluster_parameter_group" "db" {
  count = var.engine_type == "aurora" || var.engine_type == "aurora-mysql" || var.engine_type == "aurora-postgresql" ? 1 : 0

  name = "${var.name}-cluster-db-parameters"

  description = "Database Parameters Group for RDS cluster: ${var.environment}.${var.name}"
  family      = var.db_cluster_parameter_family

  dynamic "parameter" {
    for_each = var.db_cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Create RDS Subnets
resource "aws_db_subnet_group" "db" {
  count = var.subnet_group_name == "" && length(var.subnet_ids) != 0 ? 1 : 0

  name        = "${var.name}-rds"
  description = "RDS Subnet Group for service: ${var.name}, environment: ${var.environment}"
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Create a DNS name for the resource
resource "aws_route53_record" "dns_including_dbname" {
  count = var.database_name != "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" && var.replicate_source_db == "" ? 1 : 0

  zone_id = data.aws_route53_zone.selected.id
  name    = var.dns_name == "" ? var.name : var.dns_name
  type    = var.dns_type
  ttl     = var.dns_ttl
  records = [aws_db_instance.db_including_name[0].address]
}

# Create a DNS name for the resource
resource "aws_route53_record" "dns_read_replica_db" {
  count = var.replicate_source_db != "" ? 1 : 0

  zone_id = data.aws_route53_zone.selected.id
  name    = var.dns_name == "" ? var.name : var.dns_name
  type    = var.dns_type
  ttl     = var.dns_ttl
  records = [aws_db_instance.db_read_replica[0].address]
}

resource "aws_route53_record" "dns_excluding_dbname" {
  count = var.database_name == "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" && var.replicate_source_db == "" ? 1 : 0

  zone_id = data.aws_route53_zone.selected.id
  name    = var.dns_name == "" ? var.name : var.dns_name
  type    = var.dns_type
  ttl     = var.dns_ttl
  records = [aws_db_instance.db_excluding_name[0].address]
}

# User with access to RDS logs
resource "aws_iam_user" "rds_logs_iam_user" {
  count = var.log_access_enabled ? 1 : 0

  name = "${var.name}-Logs"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )

}

resource "aws_iam_policy" "rds_log_policy" {
  count = var.log_access_enabled ? 1 : 0

  name        = "${var.name}-LogAccessPolicy"
  description = "Allows access to logs for the RDS instance: ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AccessRDSLogs",
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBLogFiles",
        "rds:DownloadDBLogFilePortion"
      ],
      "Resource": "${local.rds_instance_arn}"
    }
  ]
}
EOF

}

resource "aws_iam_user_policy_attachment" "rds_log_policy_attachement" {
  count = var.log_access_enabled ? 1 : 0

  user       = aws_iam_user.rds_logs_iam_user[0].name
  policy_arn = aws_iam_policy.rds_log_policy[0].arn
}

# User with management access (logs and start/stop)
resource "aws_iam_user" "rds_management_iam_user" {
  count = var.management_access_enabled ? 1 : 0

  name = "${var.name}-Management"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )

}

resource "aws_iam_policy" "rds_management_policy" {
  count = var.management_access_enabled ? 1 : 0

  name        = "${var.name}-ManagementPolicy"
  description = "Allows starting/stopping RDS instance: ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RDSmanagelogs",
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBLogFiles",
        "rds:DownloadDBLogFilePortion"
      ],
      "Resource": "${local.rds_instance_arn}"
    },
    {
      "Sid": "RDSstartstop",
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBClusters",
        "rds:DescribeDBInstances",
        "rds:RebootDBInstance",
        "rds:StartDBCluster",
        "rds:StartDBInstance",
        "rds:StopDBCluster",
        "rds:StopDBInstance"
      ],
      "Resource": [
        "${local.target_arn}",
        "${local.rds_instance_arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "rds_management_policy_attachment" {
  count = var.management_access_enabled ? 1 : 0

  user       = aws_iam_user.rds_management_iam_user[0].name
  policy_arn = aws_iam_policy.rds_management_policy[0].arn
}

# User with performance insights access
resource "aws_iam_user" "rds_performance_insights_iam_user" {
  count = var.performance_insights_enabled ? 1 : 0

  name = "${var.name}-PerformanceInsights"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )
}

resource "aws_iam_policy" "rds_performance_insights_policy" {
  count = var.performance_insights_enabled ? 1 : 0

  name        = "${var.name}-PerformanceInsightsPolicy"
  description = "Read PI for RDS instance: ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RDSreadpimetrics",
      "Effect": "Allow",
      "Action": [
        "pi:GetResourceMetrics",
        "pi:DescribeDimensionKeys"
      ],
      "Resource": "arn:aws:pi:*:*:metrics/rds/${local.rds_instance_resource_id}"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "rds_performance_insights_policy_attachment" {
  count = var.performance_insights_enabled ? 1 : 0

  user       = aws_iam_user.rds_performance_insights_iam_user[0].name
  policy_arn = aws_iam_policy.rds_performance_insights_policy[0].arn
}

module "self_serve_access_keys" {
  source = "git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys?ref=v0.1.0"

  user_names = concat(aws_iam_user.rds_logs_iam_user.*.name, aws_iam_user.rds_management_iam_user.*.name)
}
