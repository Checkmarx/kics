# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding sha-hashed mysql native passwords" allow-rule-test
terraform {
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = "~> 3.0"
    }
  }
}

provider "mysql" {
  endpoint = "db.example.com:3306"
  username = "admin"
}

resource "mysql_user" "app_user" {
  user               = "app_user"
  host               = "%"
  auth_plugin         = "mysql_native_password"
  plaintext_password  = "*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9" # negative1
}

resource "mysql_grant" "app_user_grant" {
  user       = mysql_user.app_user.user
  host       = mysql_user.app_user.host
  database   = "app_db"
  privileges = ["SELECT", "INSERT", "UPDATE", "DELETE"]
}