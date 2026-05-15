resource "aws_security_group_rule" "this" {
  for_each = var.security_group_rules

  type                     = each.value.type
  security_group_id        = each.value.security_group_id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
}
