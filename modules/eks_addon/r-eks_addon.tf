resource "aws_eks_addon" "this" {
  for_each = var.eks_addons

  cluster_name                = each.value.cluster_name
  addon_name                  = each.value.addon_name
  addon_version               = each.value.addon_version
  configuration_values        = each.value.configuration_values
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  tags                        = merge(var.tags, each.value.tags)
}
