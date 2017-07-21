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



## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| allocated_storage | The allocated storage in GBs for the RDS | - | yes |
| allow_major_version_upgrade | Allow major version upgrade | `false` | no |
| auto_minor_version_upgrade | Allow automated minor version upgrade | `true` | no |
| backup_retention_period | How long will we retain backups | `0` | no |
| backup_window | When AWS can run snapshot, can't overlap with maintenance window | `22:00-03:00` | no |
| cidr_blocks | A list of network cidr block which are permitted acccess | `<list>` | no |
| copy_tags_to_snapshot | Copy tags from DB to a snapshot | `true` | no |
| database_name | The name of the database to create | - | yes |
| database_password | The default password for the specified user for RDS | - | yes |
| database_port | The database port being used by the RDS instance, i.e. 3306, 5342 | - | yes |
| database_user | The username for the RDS to be created | `root` | no |
| db_parameter_family | Parameter group, depends on DB engine used | - | yes |
| db_parameters | A map of database parameters for the RDS instance | `<list>` | no |
| dns_name | The dns name added the dns zone, else defaults to var.name | `` | no |
| dns_ttl | The dns record type for the RDS instance, defaults to CNAME | `300` | no |
| dns_type | The dns record type for the RDS instance, defaults to CNAME | `CNAME` | no |
| dns_zone | The required route53 domain name we are added the dns entry to i.e. example.com | - | yes |
| engine_type | Database engine type | - | yes |
| engine_version | Database engine version, depends on engine type | - | yes |
| environment | The environment the RDS is running in i.e. dev, prod etc | - | yes |
| instance_class | Class of RDS instance | `db.t2.medium` | no |
| is_multi_az | Set to true on production | `false` | no |
| name | A descriptive name for the RDS instance | - | yes |
| skip_final_snapshot | If true (default), no snapshot will be made before deleting DB | `true` | no |
| storage_encrypted | Indicates you want the underlining storage to be encrypted | `true` | no |
| storage_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). | `standard` | no |
| subnet_role | A role used to filter out which subnets the RDS should reside, defaults to Role=compute | `compute` | no |
| tags | A map of tags to add to all resources | `<map>` | no |

