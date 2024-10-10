---
title: Beta - Check use no LTS Spark Version
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

-   **Query id:** 5a627dfa-a4dd-4020-a4c6-5f3caf4abcd6
-   **Query name:** Beta - Check use no LTS Spark Version
-   **Platform:** Terraform
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Best Practices
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/807.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/807.html')">807</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/databricks/use_lts_spark_version)

### Description
Spark Version is not a Long-term Support<br>
[Documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/spark_version)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="8"
data "databricks_node_type" "postive1_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

data "databricks_spark_version" "postive1_gpu_ml" {
  gpu = true
  ml  = true
}

resource "databricks_cluster" "positive1_research" {
  cluster_name            = "Research Cluster"
  spark_version           = data.databricks_spark_version.postive1_gpu_ml.id
  node_type_id            = data.databricks_node_type.postive1_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

```
```tf title="Positive test num. 2 - tf file" hl_lines="11"
data "databricks_node_type" "positive2_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

data "databricks_spark_version" "positive2_gpu_ml" {
  gpu = true
  ml  = true
  long_term_support = false
}

resource "databricks_cluster" "positive2_research" {
  cluster_name            = "Research Cluster"
  spark_version           = data.databricks_spark_version.positive2_gpu_ml.id
  node_type_id            = data.databricks_node_type.positive2_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

```
```tf title="Positive test num. 3 - tf file" hl_lines="10"
data "databricks_node_type" "positive3_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

resource "databricks_cluster" "positive3_research" {
  cluster_name            = "Research Cluster"
  spark_version           = "3.3.1"
  node_type_id            = data.databricks_node_type.positive2_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
data "databricks_node_type" "negative1_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

data "databricks_spark_version" "negative1_gpu_ml" {
  gpu = true
  ml  = true
  long_term_support = true
}

resource "databricks_cluster" "negative1_research" {
  cluster_name            = "Research Cluster"
  spark_version           = data.databricks_spark_version.negative1_gpu_ml.id
  node_type_id            = data.databricks_node_type.negative1_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

```
```tf title="Negative test num. 2 - tf file"
data "databricks_node_type" "negative2_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

resource "databricks_cluster" "negative2_research" {
  cluster_name            = "Research Cluster"
  spark_version           = "3.2.1"
  node_type_id            = data.databricks_node_type.negative2_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

```
