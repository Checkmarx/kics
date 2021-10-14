  module "mq_broker" {
    source = "cloudposse/mq-broker/aws"
    version     = "0.14.0"

    namespace                  = "eg"
    stage                      = "test"
    name                       = "mq-broker"
    apply_immediately          = true
    auto_minor_version_upgrade = true
    deployment_mode            = "ACTIVE_STANDBY_MULTI_AZ"
    engine_type                = "ActiveMQ"
    engine_version             = "5.15.14"
    host_instance_type         = "mq.t3.micro"
    publicly_accessible        = false
    general_log_enabled        = true
    audit_log_enabled          = true
    encryption_enabled         = true
    use_aws_owned_key          = true
    vpc_id                     = var.vpc_id
    subnet_ids                 = var.subnet_ids
    security_groups            = var.security_groups
  }
