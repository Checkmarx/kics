---
title: KMS Crypto Key is Publicly Accessible
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

-   **Query id:** 16cc87d1-dd47-4f46-b3ce-4dfcac8fd2f5
-   **Query name:** KMS Crypto Key is Publicly Accessible
-   **Platform:** Terraform
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Encryption
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/gcp/kms_crypto_key_publicly_accessible)

### Description
KMS Crypto Key should not be publicly accessible. In other words, the KMS Crypto Key policy should not set 'allUsers' or 'allAuthenticatedUsers' in the attribute 'member'/'members'<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_kms_crypto_key_iam#google_kms_crypto_key_iam_policy)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="24"
resource "google_kms_key_ring" "positive1" {
  name     = "keyring-example"
  location = "global"
}
resource "google_kms_crypto_key" "positive1" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.positive1.id
  rotation_period = "100000s"
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "positive1" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypter"

    member = "allUsers"
  }
}

resource "google_kms_crypto_key_iam_policy" "positive1" {
  crypto_key_id = google_kms_crypto_key.positive1.id
  policy_data = data.google_iam_policy.positive1.policy_data
}

```
```tf title="Positive test num. 2 - tf file" hl_lines="24"
resource "google_kms_key_ring" "positive2" {
  name     = "keyring-example"
  location = "global"
}
resource "google_kms_crypto_key" "positive2" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.positive2.id
  rotation_period = "100000s"
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "positive2" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypter"

    member = "allAuthenticatedUsers"
  }
}

resource "google_kms_crypto_key_iam_policy" "positive2" {
  crypto_key_id = google_kms_crypto_key.keyyy.id
  policy_data = data.google_iam_policy.positive2.policy_data
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "google_kms_key_ring" "negative" {
  name     = "negative-example"
  location = "global"
}
resource "google_kms_crypto_key" "negative" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.negative.id
  rotation_period = "100000s"
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "negative" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypter"

    members = [
      "user:jane@example.com",
    ]
  }
}

resource "google_kms_crypto_key_iam_policy" "negative" {
  crypto_key_id = google_kms_crypto_key.negative.id
  policy_data = data.google_iam_policy.negative.policy_data
}

```
