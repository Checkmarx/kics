#this code is a correct code for which the query should not find any result
resource "aws_elb" "negative1" {
  name               = "wu-tang"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port      = 443
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::000000000000:server-certificate/wu-tang.net"
  }

  tags = {
    Name = "wu-tang"
  }
}

resource "aws_load_balancer_policy" "negative2" {
  load_balancer_name = aws_elb.wu-tang.name
  policy_name        = "wu-tang-ca-pubkey-policy"
  policy_type_name   = "PublicKeyPolicyType"

  policy_attribute {
    name  = "PublicKey"
    value = file("wu-tang-pubkey")
  }
}

resource "aws_load_balancer_policy" "negative3" {
  load_balancer_name = aws_elb.wu-tang.name
  policy_name        = "wu-tang-root-ca-backend-auth-policy"
  policy_type_name   = "BackendServerAuthenticationPolicyType"

  policy_attribute {
    name  = "PublicKeyPolicyName"
    value = aws_load_balancer_policy.wu-tang-root-ca-pubkey-policy.policy_name
  }
}

resource "aws_load_balancer_policy" "negative4" {
  load_balancer_name = aws_elb.wu-tang.name
  policy_name        = "wu-tang-ssl"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
    value = "true"
  }

  policy_attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }
}

resource "aws_load_balancer_policy" "negative5" {
  load_balancer_name = aws_elb.wu-tang.name
  policy_name        = "wu-tang-ssl"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "Reference-Security-Policy"
    value = "ELBSecurityPolicy-TLS-1-1-2017-01"
  }
}

resource "aws_load_balancer_backend_server_policy" "negative6" {
  load_balancer_name = aws_elb.wu-tang.name
  instance_port      = 443

  policy_names = [
    aws_load_balancer_policy.wu-tang-root-ca-backend-auth-policy.policy_name,
  ]
}

resource "aws_load_balancer_listener_policy" "negative7" {
  load_balancer_name = aws_elb.wu-tang.name
  load_balancer_port = 443

  policy_names = [
    aws_load_balancer_policy.wu-tang-ssl.policy_name,
  ]
}