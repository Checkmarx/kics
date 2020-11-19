#this code is a correct code for which the query should not find any result
resource "aws_security_group" "http_positive" {
  name        = "http_positive"
  description = "Doesn't get the htttp port open"
}