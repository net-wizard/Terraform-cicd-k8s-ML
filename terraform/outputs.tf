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
  value       = aws_instance.jenkins_ec2.public_ip

}
output "ecr_jenkins_url" {
  description = "Jenkins ECR repo URL"
  value       = aws_ecr_repository.retailrec_jenkins.repository_url

}
output "ecr_ml_api_url" {
  description = "ML-API ECR repo URL"
  value       = aws_ecr_repository.retailrec_ml_api.repository_url

}
output "ecr_data_service_url" {
  description = "Data Service ECR repo URL"
  value       = aws_ecr_repository.retailrec_data_service.repository_url

}
output "ecr_monitor_service_url" {
  description = "Monitor Service ECR repo URL"
  value       = aws_ecr_repository.retailrec_monitor_service.repository_url

}
output "ecr_ui_url" {
  description = "UI ECR repo URL"
  value       = aws_ecr_repository.retailrec_ui.repository_url

}