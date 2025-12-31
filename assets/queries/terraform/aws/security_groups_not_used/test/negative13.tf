resource "aws_security_group" "MSK-SG" {
  count = var.enabled ? 1 : 0

  name        = local.msk_cluster_name
  description = join(" ", [local.msk_cluster_name, "SG"])
  vpc_id      = module.data_infra_lookups[0].vpc_id

  tags = merge(
    module.tags[0].map,
    { Name = local.msk_cluster_name }
  )
}

resource "aws_security_group_rule" "inbound_to_communicate_with_prometheus" {
  count = var.enabled ? 1 : 0

  description       = "Rule which allows prometheus to connect to kafka"
  type              = "ingress"
  from_port         = 11001
  to_port           = 11002
  protocol          = "tcp"
  cidr_blocks       = flatten([module.tf-common-network-blocks[0].office_ip_cidrs, module.data_infra_lookups[0].all_vpc_cidrs])
  security_group_id = aws_security_group.MSK-SG[0].id
}
