# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding LifecycleActionToken Var"  allow-rule-test
variable "lifecycle_config" {
  default = {
    LifecycleActionToken = "placeholder-token-value"
  }
}