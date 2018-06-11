Module usage:

     module "rds" {
        source              = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"

        name                = "fake"
        allocated_storage   = "20"
        cidr_blocks         = [ "${values(module.compute.cidrs)}" ]
        database_name       = "keycloak"
        database_password   = "password"
        database_port       = "3306"
        database_user       = "root"
        db_parameter_family = "default.mysql5.6"
        dns_zone            = "${var.dns_zone}"
        engine_type         = "MariaDB"
        engine_version      = "10.1.19"
        environment         = "${var.environment}"
        instance_class      =  "db.t2.medium"
        db_parameters       = [
          {
            name  = "character_set_server"
            value = "utf8"
          },
          {
            name  = "character_set_client"
            value = "utf8"
          }
        ]
      }

    module "aurora-rds" {
        source                     = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"

        name                       = "aurorafake"
        database_name              = "aurorafake"
        number_of_aurora_instances = "2"
        allocated_storage          = "20"
        backup_retention_period    = "1"
        backup_window              = "22:00-23:59"
        cidr_blocks                = ["${values(var.compute_cidrs)}"]
        vpc_id                     = "${var.vpc_id}"
        subnet_ids                 = ["${data.aws_subnet_ids.private.ids}"]
        database_password          = "password"
        database_port              = "3306"
        database_user              = "root"
        db_parameter_family        = "aurora-mysql5.7"
        dns_zone                   = "${var.dns_zone}"
        engine_type                = "aurora-mysql"
        engine_version             = "5.7"
        environment                = "${var.environment}"
        instance_class             = "db.t2.small"
        storage_encrypted          = "true"
    }


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allocated_storage | The allocated storage in GBs for the RDS | string | - | yes |
| allow_major_version_upgrade | Allow major version upgrade | string | `false` | no |
| auto_minor_version_upgrade | Allow automated minor version upgrade | string | `true` | no |
| backup_retention_period | How long will we retain backups | string | `0` | no |
| backup_window | When AWS can run snapshot, can't overlap with maintenance window | string | `22:00-03:00` | no |
| cidr_blocks | A list of network cidr block which are permitted acccess | string | `<list>` | no |
| copy_tags_to_snapshot | Copy tags from DB to a snapshot | string | `true` | no |
| database_name | The name of the database to create | string | `` | no |
| database_password | The default password for the specified user for RDS | string | - | yes |
| database_port | The database port being used by the RDS instance, i.e. 3306, 5342 | string | - | yes |
| database_user | The username for the RDS to be created | string | `root` | no |
| db_cluster_parameter_family | Cluster parameter group, depends on DB engine used | string | `<list>` | no |
| db_cluster_parameters | A map of database parameters for the RDS Cluster instance | string | `<list>` | no |
| db_parameter_family | Parameter group, depends on DB engine used | string | - | yes |
| db_parameters | A map of database parameters for the RDS instance | string | `<list>` | no |
| dns_name | The dns name added the dns zone, else defaults to var.name | string | `` | no |
| dns_ttl | The dns record type for the RDS instance, defaults to CNAME | string | `300` | no |
| dns_type | The dns record type for the RDS instance, defaults to CNAME | string | `CNAME` | no |
| dns_zone | The required route53 domain name we are added the dns entry to i.e. example.com | string | - | yes |
| engine_type | Database engine type | string | - | yes |
| engine_version | Database engine version, depends on engine type | string | - | yes |
| environment | The environment the RDS is running in i.e. dev, prod etc | string | - | yes |
| instance_class | Class of RDS instance | string | `db.t2.medium` | no |
| is_multi_az | Set to true on production | string | `false` | no |
| name | A descriptive name for the RDS instance (leave blank only when rds requires it to be blank) | string | - | yes |
| number_of_aurora_instances | The number of Aurora instances to create | string | `1` | no |
| skip_final_snapshot | If true (default), no snapshot will be made before deleting DB | string | `true` | no |
| storage_encrypted | Indicates you want the underlining storage to be encrypted | string | `true` | no |
| storage_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). | string | `gp2` | no |
| subnet_ids | The list of subnet IDs associated to a vpc | string | `<list>` | no |
| subnet_role | A role used to filter out which subnets the RDS should reside, defaults to Role=compute | string | `compute` | no |
| tags | A map of tags to add to all resources | string | `<map>` | no |
| vpc_id | The VPC ID to create the resources within | string | - | yes |

