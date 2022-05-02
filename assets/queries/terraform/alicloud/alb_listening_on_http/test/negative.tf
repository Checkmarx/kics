resource "alicloud_alb_listener" "negative" {
  load_balancer_id     = alicloud_alb_load_balancer.default_3.id
  listener_protocol    = "HTTPS"
  listener_port        = 443
  listener_description = "createdByTerraform"
  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.default.id
      }
    }
  }
  certificates {
    certificate_id = join("", [alicloud_ssl_certificates_service_certificate.default.id, "-cn-hangzhou"])
  }
  acl_config {
    acl_type = "White"
    acl_relations {
      acl_id = alicloud_alb_acl.example.id
    }
  }
}
