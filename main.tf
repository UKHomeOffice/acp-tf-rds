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
 */

# Get the VPC for this instance, we use the environment tag
data "aws_vpc" "selected" {
  tags {
    Env = "${var.environment}"
  }
}

# Get a list of subnets the RDS should reside
data "aws_subnet_ids" "selected" {
  vpc_id = "${data.aws_vpc.selected.id}"
  tags   = "${merge(map("Role", var.subnet_role), map("Env", var.environment))}"
}

# Get the hosting zone
data "aws_route53_zone" "selected" {
  name = "${var.dns_zone}."
}

# Security Group used to manage access to the RDS instance
resource "aws_security_group" "db" {
  name        = "${var.name}-sg-rds"
  description = "The security group used to manage access to rds: ${var.name}, environment: ${var.environment}"
  vpc_id      = "${data.aws_vpc.selected.id}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
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
resource "aws_db_instance" "db" {
  name                        = "${var.database_name}"
  allocated_storage           = "${var.allocated_storage}"
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  db_subnet_group_name        = "${aws_db_subnet_group.db.name}"
  engine                      = "${var.engine_type}"
  engine_version              = "${var.engine_version}"
  identifier                  = "${var.name}"
  instance_class              = "${var.instance_class}"
  multi_az                    = "${var.is_multi_az}"
  parameter_group_name        = "${aws_db_parameter_group.db.id}"
  password                    = "${var.database_password}"
  port                        = "${var.database_port}"
  publicly_accessible         = false
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  storage_encrypted           = "${var.storage_encrypted}"
  storage_type                = "${var.storage_type}"
  username                    = "${var.database_user}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
}

# Create the database parameters
resource "aws_db_parameter_group" "db" {
  name      = "${var.name}-db-parameters"
  family    = "${var.db_parameter_family}"
  parameter = "${var.db_parameters}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
}

# Create RDS Subnets
resource "aws_db_subnet_group" "db" {
  name        = "${var.name}-rds"
  description = "RDS Subnet Group for service: ${var.name}, environment: ${var.environment}"
  subnet_ids  = ["${data.aws_subnet_ids.selected.ids}"]

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
}

# Create a DNS name for the resource
resource "aws_route53_record" "dns" {
  zone_id = "${data.aws_route53_zone.selected.id}"
  name    = "${var.dns_name == "" ? var.name : var.dns_name}"
  type    = "${var.dns_type}"
  ttl     = "${var.dns_ttl}"
  records = ["${aws_db_instance.db.endpoint}"]
}
