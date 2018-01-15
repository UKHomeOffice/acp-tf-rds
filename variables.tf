variable "name" {
  description = "A descriptive name for the RDS instance (leave blank only when rds requires it to be blank)"
}

variable "environment" {
  description = "The environment the RDS is running in i.e. dev, prod etc"
}

variable "dns_name" {
  description = "The dns name added the dns zone, else defaults to var.name"
  default     = ""
}

variable "dns_zone" {
  description = "The required route53 domain name we are added the dns entry to i.e. example.com"
}

variable "database_name" {
  description = "The name of the database to create"
  default     = ""
}

variable "database_user" {
  description = "The username for the RDS to be created"
  default     = "root"
}

variable "database_password" {
  description = "The default password for the specified user for RDS"
}

variable "database_port" {
  description = "The database port being used by the RDS instance, i.e. 3306, 5342"
}

variable "cidr_blocks" {
  description = "A list of network cidr block which are permitted acccess"
  default     = ["0.0.0.0/0"]
}

variable "subnet_role" {
  description = "A role used to filter out which subnets the RDS should reside, defaults to Role=compute"
  default     = "compute"
}

variable "dns_type" {
  description = "The dns record type for the RDS instance, defaults to CNAME"
  default     = "CNAME"
}

variable "dns_ttl" {
  description = "The dns record type for the RDS instance, defaults to CNAME"
  default     = "300"
}

# This is for a custom parameter to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "db_parameter_family" {
  description = "Parameter group, depends on DB engine used"

  # default = "mysql5.6"
  # default = "postgres9.5"
}

variable "db_parameters" {
  description = "A map of database parameters for the RDS instance"
  default     = []
}

variable "is_multi_az" {
  description = "Set to true on production"
  default     = false
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Indicates you want the underlining storage to be encrypted"
  default     = true
}

variable "allocated_storage" {
  description = "The allocated storage in GBs for the RDS"
}

variable "engine_type" {
  description = "Database engine type"

  # Valid types are
  # - mysql
  # - postgres
  # - oracle-*
  # - sqlserver-*
  # See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  # --engine
}

variable "engine_version" {
  description = "Database engine version, depends on engine type"

  # For valid engine versions, see:
  # See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  # --engine-version
}

variable "instance_class" {
  description = "Class of RDS instance"

  # Valid values
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
  default = "db.t2.medium"
}

variable "auto_minor_version_upgrade" {
  description = "Allow automated minor version upgrade"
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  default     = false
}

variable "skip_final_snapshot" {
  description = "If true (default), no snapshot will be made before deleting DB"
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "Copy tags from DB to a snapshot"
  default     = true
}

variable "backup_window" {
  description = "When AWS can run snapshot, can't overlap with maintenance window"
  default     = "22:00-03:00"
}

variable "backup_retention_period" {
  description = "How long will we retain backups"
  type        = "string"
  default     = 0
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
