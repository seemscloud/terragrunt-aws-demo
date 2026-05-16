output "addon_arns" {
  value = { for k, addon in aws_eks_addon.this : k => addon.arn }
}

output "addon_names" {
  value = { for k, addon in aws_eks_addon.this : k => addon.addon_name }
}
