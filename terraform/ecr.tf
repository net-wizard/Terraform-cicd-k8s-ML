resource "aws_ecr_repository" "retailrec_jenkins" {
  name                 = "retailrec-jenkins"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  tags                 = merge(var.common_tags, { Name = "retailrec_jenkins" })

}
resource "aws_ecr_repository" "retailrec_ml_api" {
  name                 = "retailrec-ml-api"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  tags                 = merge(var.common_tags, { Name = "retailrec_ml_api" })

}
resource "aws_ecr_repository" "retailrec_data_service" {
  name                 = "retailrec-data-service"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  tags                 = merge(var.common_tags, { Name = "retailrec_data_service" })

}
resource "aws_ecr_repository" "retailrec_ui" {
  name                 = "retailrec-ui"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  tags                 = merge(var.common_tags, { Name = "retailrec_ui" })

}
resource "aws_ecr_repository" "retailrec_monitor_service" {
  name                 = "retailrec-monitor-service"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  tags                 = merge(var.common_tags, { Name = "retailrec_monitor_service" })

}