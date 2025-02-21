---
title: ActionTrail Trail OSS Bucket is Publicly Accessible
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

-   **Query id:** 69b5d7da-a5db-4db9-a42e-90b65d0efb0b
-   **Query name:** ActionTrail Trail OSS Bucket is Publicly Accessible
-   **Platform:** Terraform
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/668.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/668.html')">668</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/alicloud/actiontrail_trail_oss_bucket_is_publicly_accessible)

### Description
ActionTrail Trail OSS Bucket should not be publicly accessible<br>
[Documentation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/actiontrail_trail)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="3"
resource "alicloud_oss_bucket" "bucket_actiontrail3" {
  bucket = "bucket_actiontrail_3"
  acl    = "public-read"
}

resource "alicloud_actiontrail_trail" "actiontrail3" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_3"
  event_rw           = "All"
  trail_region       = "All"
}


```
```tf title="Positive test num. 2 - tf file" hl_lines="3"
resource "alicloud_oss_bucket" "bucket_actiontrail4" {
  bucket = "bucket_actiontrail_4"
  acl    = "public-read-write"
}

resource "alicloud_actiontrail_trail" "actiontrail4" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_4"
  event_rw           = "All"
  trail_region       = "All"
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "alicloud_oss_bucket" "bucket_actiontrail1" {
  bucket = "bucket_actiontrail_1"
  acl    = "private"
}

resource "alicloud_actiontrail_trail" "actiontrail1" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_1"
  event_rw           = "All"
  trail_region       = "All"
}

```
```tf title="Negative test num. 2 - tf file"
resource "alicloud_oss_bucket" "bucket_actiontrail2" {
  bucket = "bucket_actiontrail_2"
}

resource "alicloud_actiontrail_trail" "actiontrail2" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_2"
  event_rw           = "All"
  trail_region       = "All"
}

```
