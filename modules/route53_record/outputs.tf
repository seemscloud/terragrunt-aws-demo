output "fqdns" {
  value = { for k, record in aws_route53_record.this : k => record.fqdn }
}
