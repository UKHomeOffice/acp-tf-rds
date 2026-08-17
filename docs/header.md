# acp-tf-rds

Terraform module for provisioning RDS instances (standard and Aurora) with associated networking, DNS, and IAM resources.

## Usage

```hcl
module "rds" {
  source = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=v0.x.x"

  name                = "my-service-db"
  environment         = var.environment
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  dns_zone            = var.dns_zone
  cidr_blocks         = var.compute_cidrs

  engine_type         = "postgres"
  engine_version      = "14.9"
  instance_class      = "db.t3.medium"
  db_parameter_family = "postgres14"

  allocated_storage   = 50
  max_allocated_storage = 200

  database_name     = "myapp"
  database_user     = "myapp"
  database_password = var.db_password
  database_port     = 5432
}
```

## Notes

The module does not currently support Aurora I/O Optimised storage types. In order to use these, do not define `storage_type` and simply make the change in the AWS console.

For an RDS instance with `storage_type` using `gp3`, be aware that `iops` cannot be specified if the `allocated_storage` value is below a per-`engine` threshold. See the [RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#gp3-storage) for details.
If the `storage_type` is set to `gp3` but `iops` is unspecified, this module will determine an appropriate baseline value.
