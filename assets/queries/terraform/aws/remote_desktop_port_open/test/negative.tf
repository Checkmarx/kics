#this code is a correct code for which the query should not find any result
resource "aws_security_group" "negative_rdp" {
  name        = "Dont open remote desktop port"
  description = "Doesn't enable the remote desktop port"

}