# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  - "Avoiding TF resource access"  allow-rule-test
locals {
  secrets = {
    my_secret = random_password.my_password.result
  }
}
