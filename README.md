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
        subnet_group_name          = "${var.environment}-rds-subnet-group"
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
| allocated\_storage | The allocated storage in GBs for the RDS | string | n/a | yes |
| allow\_major\_version\_upgrade | Allow major version upgrade | string | `"false"` | no |
| auto\_minor\_version\_upgrade | Allow automated minor version upgrade | string | `"false"` | no |
| backup\_retention\_period | How long will we retain backups | string | `"0"` | no |
| backup\_window | When AWS can run snapshot, can't overlap with maintenance window | string | `"22:00-03:00"` | no |
| cidr\_blocks | A list of network cidr block which are permitted acccess | list | `<list>` | no |
| copy\_tags\_to\_snapshot | Copy tags from DB to a snapshot | string | `"true"` | no |
| database\_name | The name of the database to create | string | `""` | no |
| database\_password | The default password for the specified user for RDS | string | n/a | yes |
| database\_port | The database port being used by the RDS instance, i.e. 3306, 5342 | string | n/a | yes |
| database\_user | The username for the RDS to be created | string | `"root"` | no |
| db\_cluster\_parameter\_family | Cluster parameter group, depends on DB engine used | string | `""` | no |
| db\_cluster\_parameters | A map of database parameters for the RDS Cluster instance | list | `<list>` | no |
| db\_parameter\_family | Parameter group, depends on DB engine used | string | n/a | yes |
| db\_parameters | A map of database parameters for the RDS instance | list | `<list>` | no |
| dns\_name | The dns name added the dns zone, else defaults to var.name | string | `""` | no |
| dns\_ttl | The dns record type for the RDS instance, defaults to CNAME | string | `"300"` | no |
| dns\_type | The dns record type for the RDS instance, defaults to CNAME | string | `"CNAME"` | no |
| dns\_zone | The required route53 domain name we are added the dns entry to i.e. example.com | string | n/a | yes |
| engine\_type | Database engine type | string | n/a | yes |
| engine\_version | Database engine version, depends on engine type | string | n/a | yes |
| environment | The environment the RDS is running in i.e. dev, prod etc | string | n/a | yes |
| instance\_class | Class of RDS instance | string | `"db.t2.medium"` | no |
| is\_multi\_az | Set to true on production | string | `"false"` | no |
| license\_model | License model information required for some DBs like Oracle SE2 | string | `""` | no |
| log\_access\_enabled | Create a user with access to the instance's logs | string | `"false"` | no |
| name | A descriptive name for the RDS instance (leave blank only when rds requires it to be blank) | string | n/a | yes |
| number\_of\_aurora\_instances | The number of Aurora instances to create | string | `"1"` | no |
| publicly\_accessible | If true, the RDS will be publicly accessible | string | `"false"` | no |
| replicate\_source\_db | Specifies that this resource is a Replicate database, and to use this value as the source database. | string | `""` | no |
| skip\_final\_snapshot | If true (false by default), no snapshot will be made before deleting DB | string | `"false"` | no |
| storage\_encrypted | Indicates you want the underlining storage to be encrypted | string | `"true"` | no |
| storage\_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). | string | `"gp2"` | no |
| subnet\_group\_name | The name/ID of the subnet group for the instance | string | `""` | no |
| subnet\_ids | The list of subnet IDs associated to a vpc | list | `<list>` | no |
| subnet\_role | A role used to filter out which subnets the RDS should reside, defaults to Role=compute | string | `"compute"` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |
| vpc\_id | The VPC ID to create the resources within | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_excluding\_name\_instance\_id | ID of the instance |
| db\_including\_name\_instance\_id | ID of the instance |

