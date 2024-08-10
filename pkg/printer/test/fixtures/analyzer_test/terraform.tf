resource "aws_alb" "foo33" {
  internal = false
  subnets  = [aws_subnet.foo.id, aws_subnet.bar.id]
}

resource "aws_wafregional_web_acl_association" "foo_waf33" {
  resource_arn = aws_alb.foo33.arn
  web_acl_id   = aws_wafregional_web_acl.foo.id
}
# trigger validation
