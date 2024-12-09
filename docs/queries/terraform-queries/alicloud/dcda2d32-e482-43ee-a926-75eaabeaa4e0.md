---
title: RAM Security Preference Not Enforce MFA Login
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

-   **Query id:** dcda2d32-e482-43ee-a926-75eaabeaa4e0
-   **Query name:** RAM Security Preference Not Enforce MFA Login
-   **Platform:** Terraform
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/287.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/287.html')">287</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/alicloud/ram_security_preference_not_enforce_mfa)

### Description
RAM Security preferences should enforce MFA login for RAM users<br>
[Documentation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_security_preference#enforce_mfa_for_login)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="11"
# Create a new RAM user.
resource "alicloud_ram_user" "user1" {
  name         = "user_test"
  display_name = "user_display_name"
  mobile       = "86-18688888888"
  email        = "hello.uuu@aaa.com"
  comments     = "yoyoyo"
  force        = true
}

resource "alicloud_ram_security_preference" "example1" {
  enable_save_mfa_ticket        = false
  allow_user_to_change_password = true
}

```
```tf title="Positive test num. 2 - tf file" hl_lines="14"
# Create a new RAM user.
resource "alicloud_ram_user" "user2" {
  name         = "user_test"
  display_name = "user_display_name"
  mobile       = "86-18688888888"
  email        = "hello.uuu@aaa.com"
  comments     = "yoyoyo"
  force        = true
}

resource "alicloud_ram_security_preference" "example2" {
  enable_save_mfa_ticket        = false
  allow_user_to_change_password = true
  enforce_mfa_for_login = false
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
# Create a new RAM user.
resource "alicloud_ram_user" "user0" {
  name         = "user_test"
  display_name = "user_display_name"
  mobile       = "86-18688888888"
  email        = "hello.uuu@aaa.com"
  comments     = "yoyoyo"
  force        = true
}

resource "alicloud_ram_security_preference" "example0" {
  enable_save_mfa_ticket        = false
  allow_user_to_change_password = true
  enforce_mfa_for_login = true
}

```
