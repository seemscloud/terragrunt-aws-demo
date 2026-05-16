output "transit_gateway_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "vpc_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.vpc_id
}
