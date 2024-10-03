---
title: Beta - CLB Instance Log Setting Disabled
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

-   **Query id:** ada01ed1-b10c-4f2a-b110-b20fa4f9baa6
-   **Query name:** Beta - CLB Instance Log Setting Disabled
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Encryption
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/tencentcloud/clb_instance_log_setting_disabled)

### Description
CLB Instance should set log enabled<br>
[Documentation](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_instance#log_set_id)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="19"
resource "tencentcloud_vpc" "vpc_test" {
  name       = "clb-test"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_route_table" "rtb_test" {
  name   = "clb-test"
  vpc_id = tencentcloud_vpc.vpc_test.id
}

resource "tencentcloud_subnet" "subnet_test" {
  name              = "clb-test"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-guangzhou-3"
  vpc_id            = tencentcloud_vpc.vpc_test.id
  route_table_id    = tencentcloud_route_table.rtb_test.id
}

resource "tencentcloud_clb_instance" "internal_clb" {
  network_type                 = "INTERNAL"
  clb_name                     = "clb_example"
  project_id                   = 0
  vpc_id                       = tencentcloud_vpc.vpc_test.id
  subnet_id                    = tencentcloud_subnet.subnet_test.id
  load_balancer_pass_to_target = true

  tags = {
    test = "tf"
  }
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "tencentcloud_vpc" "vpc_test" {
  name       = "clb-test"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_route_table" "rtb_test" {
  name   = "clb-test"
  vpc_id = tencentcloud_vpc.vpc_test.id
}

resource "tencentcloud_subnet" "subnet_test" {
  name              = "clb-test"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-guangzhou-3"
  vpc_id            = tencentcloud_vpc.vpc_test.id
  route_table_id    = tencentcloud_route_table.rtb_test.id
}

resource "tencentcloud_clb_log_set" "set" {
  period = 7
}

resource "tencentcloud_clb_log_topic" "topic" {
  log_set_id = tencentcloud_clb_log_set.set.id
  topic_name = "clb-topic"
}

resource "tencentcloud_clb_instance" "internal_clb" {
  network_type                 = "INTERNAL"
  clb_name                     = "clb_example"
  project_id                   = 0
  vpc_id                       = tencentcloud_vpc.vpc_test.id
  subnet_id                    = tencentcloud_subnet.subnet_test.id
  load_balancer_pass_to_target = true
  log_set_id                   = tencentcloud_clb_log_set.set.id
  log_topic_id                 = tencentcloud_clb_log_topic.topic.id

  tags = {
    test = "tf"
  }
}

```
