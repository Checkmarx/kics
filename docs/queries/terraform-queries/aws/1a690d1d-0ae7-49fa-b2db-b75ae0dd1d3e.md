---
title: Aurora With Disabled at Rest Encryption
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** 1a690d1d-0ae7-49fa-b2db-b75ae0dd1d3e
-   **Query name:** Aurora With Disabled at Rest Encryption
-   **Platform:** Terraform
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Encryption
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/311.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/311.html')">311</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws/aurora_with_disabled_at_rest_encryption)

### Description
Amazon Aurora does not have encryption for data at rest enabled. To prevent such a scenario, update the attribute 'StorageEncrypted' to 'true'.<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#storage_encrypted)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="16"
provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_rds_cluster" "my_cluster" {
  cluster_identifier            = "my-cluster"
  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.08.0"
  master_username              = "admin"
  master_password              = "password"
  backup_retention_period      = 7
  preferred_backup_window      = "02:00-03:00"
  deletion_protection          = false
  skip_final_snapshot          = true
  apply_immediately            = true
  storage_encrypted            = false
}

resource "aws_rds_cluster_instance" "my_cluster_instance" {
  identifier                    = "my-cluster-instance"
  cluster_identifier            = aws_rds_cluster.my_cluster.id
  engine                        = "aurora-mysql"
  instance_class                = "db.r5.large"
  publicly_accessible           = false
  availability_zone             = "us-west-2a"  # Replace with your desired availability zone
}

output "cluster_endpoint" {
  value = aws_rds_cluster.my_cluster.endpoint
}

```
```tf title="Positive test num. 2 - tf file" hl_lines="5"
provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_rds_cluster" "my_cluster" {
  cluster_identifier            = "my-cluster"
  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.08.0"
  master_username              = "admin"
  master_password              = "password"
  backup_retention_period      = 7
  preferred_backup_window      = "02:00-03:00"
  deletion_protection          = false
  skip_final_snapshot          = true
  apply_immediately            = true
}

resource "aws_rds_cluster_instance" "my_cluster_instance" {
  identifier                    = "my-cluster-instance"
  cluster_identifier            = aws_rds_cluster.my_cluster.id
  engine                        = "aurora-mysql"
  instance_class                = "db.r5.large"
  publicly_accessible           = false
  availability_zone             = "us-west-2a"  # Replace with your desired availability zone
}

output "cluster_endpoint" {
  value = aws_rds_cluster.my_cluster.endpoint
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_rds_cluster" "my_cluster" {
  cluster_identifier            = "my-cluster"
  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.08.0"
  master_username              = "admin"
  master_password              = "password"
  backup_retention_period      = 7
  preferred_backup_window      = "02:00-03:00"
  deletion_protection          = false
  skip_final_snapshot          = true
  apply_immediately            = true
  storage_encrypted            = true
}

resource "aws_rds_cluster_instance" "my_cluster_instance" {
  identifier                    = "my-cluster-instance"
  cluster_identifier            = aws_rds_cluster.my_cluster.id
  engine                        = "aurora-mysql"
  instance_class                = "db.r5.large"
  publicly_accessible           = false
  availability_zone             = "us-west-2a"  # Replace with your desired availability zone
}

output "cluster_endpoint" {
  value = aws_rds_cluster.my_cluster.endpoint
}

```
