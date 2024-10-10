locals {
  secrets = {
    my_secret = random_password.my_password.result
  }
}
