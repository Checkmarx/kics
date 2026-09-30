# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"  allow-rule-test
provider "slack" {
  token = var.slack_token # negative1
}
