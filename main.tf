/**
 * Module usage:
 *
 *      module "rds" {
 *         source              = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"
 *
 *         name                = "fake"
 *         allocated_storage   = "20"
 *         cidr_blocks         = [ "${values(module.compute.cidrs)}" ]
 *         database_name       = "keycloak"
 *         database_password   = "password"
 *         database_port       = "3306"
 *         database_user       = "root"
 *         db_parameter_family = "default.mysql5.6"
 *         dns_zone            = "${var.dns_zone}"
 *         engine_type         = "MariaDB"
 *         engine_version      = "10.1.19"
 *         environment         = "${var.environment}"
 *         instance_class      =  "db.t2.medium"
 *         db_parameters       = [
 *           {
 *             name  = "character_set_server"
 *             value = "utf8"
 *           },
 *           {
 *             name  = "character_set_client"
 *             value = "utf8"
 *           }
 *         ]
 *       }
 *
 *     module "aurora-rds" {
 *         source                     = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"
 *
 *         name                       = "aurorafake"
 *         database_name              = "aurorafake"
 *         number_of_aurora_instances = "2"
 *         allocated_storage          = "20"
 *         backup_retention_period    = "1"
 *         backup_window              = "22:00-23:59"
 *         cidr_blocks                = ["${values(var.compute_cidrs)}"]
 *         vpc_id                     = "${var.vpc_id}"
 *         subnet_group_name          = "${var.environment}-rds-subnet-group"
 *         database_password          = "password"
 *         database_port              = "3306"
 *         database_user              = "root"
 *         db_parameter_family        = "aurora-mysql5.7"
 *         dns_zone                   = "${var.dns_zone}"
 *         engine_type                = "aurora-mysql"
 *         engine_version             = "5.7"
 *         environment                = "${var.environment}"
 *         instance_class             = "db.t2.small"
 *         storage_encrypted          = "true"
 *     }
 */
locals {
  db_subnet_group_name = "${coalesce(var.subnet_group_name, element(concat(aws_db_subnet_group.db.*.id, list("")), 0))}"
  rds_instance_arn     = "${coalesce(element(concat(aws_db_instance.db_including_name.*.arn, list("")), 0), element(concat(aws_db_instance.db_excluding_name.*.arn, list("")), 0), element(concat(aws_rds_cluster_instance.aurora_cluster_instance.*.arn, list("")), 0))}"
}

# Get the hosting zone
data "aws_route53_zone" "selected" {
  name = "${var.dns_zone}."
}

# Security Group used to manage access to the RDS instance
resource "aws_security_group" "db" {
  name        = "${var.name}-sg-rds"
  description = "The security group used to manage access to rds: ${var.name}, environment: ${var.environment}"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Ingress Rule to permit inbound database port
resource "aws_security_group_rule" "database_port" {
  type              = "ingress"
  from_port         = "${var.database_port}"
  to_port           = "${var.database_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.cidr_blocks}"]
  security_group_id = "${aws_security_group.db.id}"
}

# Egress Rule to permit outbound to all
resource "aws_security_group_rule" "out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.db.id}"
}

# The database instance itself
resource "aws_db_instance" "db_including_name" {
  count = "${var.database_name != "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" ? 1 : 0}"

  name                        = "${var.database_name}"
  allocated_storage           = "${var.allocated_storage}"
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  db_subnet_group_name        = "${local.db_subnet_group_name}"
  engine                      = "${var.engine_type}"
  engine_version              = "${var.engine_version}"
  final_snapshot_identifier   = "${var.name}"
  identifier                  = "${var.name}"
  instance_class              = "${var.instance_class}"
  license_model               = "${var.license_model}"
  multi_az                    = "${var.is_multi_az}"
  parameter_group_name        = "${aws_db_parameter_group.db.id}"
  password                    = "${var.database_password}"
  port                        = "${var.database_port}"
  publicly_accessible         = "${var.publicly_accessible}"
  vpc_security_group_ids      = ["${aws_security_group.db.id}"]
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  storage_encrypted           = "${var.storage_encrypted}"
  storage_type                = "${var.storage_type}"
  username                    = "${var.database_user}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# The database instance itself
resource "aws_db_instance" "db_excluding_name" {
  count = "${var.database_name == "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" ? 1 : 0}"

  allocated_storage           = "${var.allocated_storage}"
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  db_subnet_group_name        = "${local.db_subnet_group_name}"
  engine                      = "${var.engine_type}"
  engine_version              = "${var.engine_version}"
  final_snapshot_identifier   = "${var.name}"
  identifier                  = "${var.name}"
  instance_class              = "${var.instance_class}"
  license_model               = "${var.license_model}"
  multi_az                    = "${var.is_multi_az}"
  parameter_group_name        = "${aws_db_parameter_group.db.id}"
  password                    = "${var.database_password}"
  port                        = "${var.database_port}"
  publicly_accessible         = "${var.publicly_accessible}"
  vpc_security_group_ids      = ["${aws_security_group.db.id}"]
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  storage_encrypted           = "${var.storage_encrypted}"
  storage_type                = "${var.storage_type}"
  username                    = "${var.database_user}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Cluster for Amazon Aurora
resource "aws_rds_cluster" "aurora_cluster" {
  # aurora = MySQL 5.6-compatible, aurora-mysql = MySQL 5.7-compatible
  count = "${var.engine_type == "aurora" || var.engine_type == "aurora-mysql" || var.engine_type == "aurora-postgresql" ? 1 : 0}"

  backup_retention_period         = "${var.backup_retention_period}"
  cluster_identifier              = "${var.name}"
  database_name                   = "${var.name}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.db.id}"
  db_subnet_group_name            = "${local.db_subnet_group_name}"
  engine                          = "${var.engine_type}"
  engine_version                  = "${var.engine_version}"
  final_snapshot_identifier       = "${var.name}"
  master_password                 = "${var.database_password}"
  master_username                 = "${var.database_user}"
  port                            = "${var.database_port}"
  preferred_backup_window         = "${var.backup_window}"
  skip_final_snapshot             = "${var.skip_final_snapshot}"
  storage_encrypted               = "${var.storage_encrypted}"
  vpc_security_group_ids          = ["${aws_security_group.db.id}"]
}

# Aurora cluster instance
resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  count = "${var.engine_type == "aurora" || var.engine_type == "aurora-mysql" || var.engine_type == "aurora-postgresql" ? var.number_of_aurora_instances : 0}"

  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  cluster_identifier         = "${aws_rds_cluster.aurora_cluster.id}"
  db_subnet_group_name       = "${local.db_subnet_group_name}"
  db_parameter_group_name    = "${aws_db_parameter_group.db.id}"
  engine                     = "${var.engine_type}"
  identifier                 = "${var.name}${var.number_of_aurora_instances != 1 ? "-${count.index}" : "" }"
  instance_class             = "${var.instance_class}"
  publicly_accessible        = "${var.publicly_accessible}"
  tags                       = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Create the database parameters
resource "aws_db_parameter_group" "db" {
  name = "${var.name}-db-parameters"

  description = "Database Parameters Group for RDS: ${var.environment}.${var.name}"
  family      = "${var.db_parameter_family}"
  parameter   = "${var.db_parameters}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Create the RDS cluster parameters
resource "aws_rds_cluster_parameter_group" "db" {
  count = "${var.engine_type == "aurora" || var.engine_type == "aurora-mysql" || var.engine_type == "aurora-postgresql" ? 1 : 0}"

  name = "${var.name}-cluster-db-parameters"

  description = "Database Parameters Group for RDS cluster: ${var.environment}.${var.name}"
  family      = "${var.db_cluster_parameter_family}"
  parameter   = "${var.db_cluster_parameters}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Create RDS Subnets
resource "aws_db_subnet_group" "db" {
  count = "${var.subnet_group_name == "" && length(var.subnet_ids) != 0 ? 1 : 0}"

  name        = "${var.name}-rds"
  description = "RDS Subnet Group for service: ${var.name}, environment: ${var.environment}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Create a DNS name for the resource
resource "aws_route53_record" "dns_including_dbname" {
  count = "${var.database_name != "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.selected.id}"
  name    = "${var.dns_name == "" ? var.name : var.dns_name}"
  type    = "${var.dns_type}"
  ttl     = "${var.dns_ttl}"
  records = ["${aws_db_instance.db_including_name.address}"]
}

resource "aws_route53_record" "dns_excluding_dbname" {
  count = "${var.database_name == "" && var.engine_type != "aurora" && var.engine_type != "aurora-mysql" && var.engine_type != "aurora-postgresql" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.selected.id}"
  name    = "${var.dns_name == "" ? var.name : var.dns_name}"
  type    = "${var.dns_type}"
  ttl     = "${var.dns_ttl}"
  records = ["${aws_db_instance.db_excluding_name.address}"]
}

# User with access to RDS logs
resource "aws_iam_user" "rds_logs_iam_user" {
  count = "${var.log_access_enabled ? 1 : 0}"

  name = "${var.name}-Logs"
}

resource "aws_iam_policy" "rds_log_policy" {
  count = "${var.log_access_enabled ? 1 : 0}"

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
  count = "${var.log_access_enabled ? 1 : 0}"

  user       = "${aws_iam_user.rds_logs_iam_user.name}"
  policy_arn = "${aws_iam_policy.rds_log_policy.arn}"
}
