---
title: Redshift Cluster Logging Disabled
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

-   **Query id:** 15ffbacc-fa42-4f6f-a57d-2feac7365caa
-   **Query name:** Redshift Cluster Logging Disabled
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws/redshift_cluster_logging_disabled)

### Description
Make sure Logging is enabled for Redshift Cluster<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster#enable)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="9 13"
resource "aws_redshift_cluster" "positive1" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "Mustbe8characters"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
  logging {
      enable = false
  }
}

resource "aws_redshift_cluster" "positive2" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "Mustbe8characters"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
}
```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "aws_redshift_cluster" "negative1" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "Mustbe8characters"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
  logging {
      enable = true
      bucket_name = "nameOfAnExistingS3Bucket"
  }
}
```
