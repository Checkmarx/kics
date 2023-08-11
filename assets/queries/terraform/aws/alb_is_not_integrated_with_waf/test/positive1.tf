resource "aws_alb" "foo" {
  internal = false
  subnets  = [aws_subnet.foo.id, aws_subnet.bar.id]
}

resource "aws_wafregional_web_acl_association" "foo_waf" {
  resource_arn = aws_alb.fooooo.arn
  web_acl_id   = aws_wafregional_web_acl.foo.id
}

