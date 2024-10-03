---
title: ElastiCache Replication Group Not Encrypted At Transit
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

-   **Query id:** 1afbb3fa-cf6c-4a3d-b730-95e9f4df343e
-   **Query name:** ElastiCache Replication Group Not Encrypted At Transit
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Encryption
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/311.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/311.html')">311</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws/elasticache_replication_group_not_encrypted_at_transit)

### Description
ElastiCache Replication Group encryption should be enabled at Transit<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group#transit_encryption_enabled)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="1"
resource "aws_elasticache_replication_group" "example" {
  automatic_failover_enabled    = true
  availability_zones            = ["us-west-2a", "us-west-2b"]
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.m4.large"
  number_cache_clusters         = 2
  port                          = 6379
}

```
```tf title="Positive test num. 2 - tf file" hl_lines="9"
resource "aws_elasticache_replication_group" "example" {
  automatic_failover_enabled    = true
  availability_zones            = ["us-west-2a", "us-west-2b"]
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.m4.large"
  number_cache_clusters         = 2
  port                          = 6379
  transit_encryption_enabled    = false
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "aws_elasticache_replication_group" "example3" {
  automatic_failover_enabled    = true
  availability_zones            = ["us-west-2a", "us-west-2b"]
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.m4.large"
  number_cache_clusters         = 2
  port                          = 6379
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
}

```
