output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.retailrec_vpc.id

}
output "subnet_a_id" {
  description = "Subnet a ID"
  value       = aws_subnet.retailrec_subnet_public_a.id

}
output "subnet_b_id" {
  description = "Subnet b ID"
  value       = aws_subnet.retailrec_subnet_public_b.id

}
output "Jenkins_public_ip" {
    description = "Jenkins Instance public IP Address"
    value = aws_instance.jenkins_ec2.public_ip
  
}