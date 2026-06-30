resource "aws_iam_role" "jenkins_ec2_role" {
  name = "jenkins-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      }
    ]
  })
  tags = merge(var.common_tags, { Name = "jenkins_ec2_role" })


}
resource "aws_iam_role_policy" "jenkins_ec2_policy" {
  name = "jenkins-ec2-policy"
  role = aws_iam_role.jenkins_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "secretsmanager:GetSecretValue"
      ]
      Resource = "*"
      Effect   = "Allow"
    }]
  })


}
resource "aws_iam_role_policy_attachment" "jenkins_ecr_full" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_ec2_role.name
  tags = merge(var.common_tags, { Name = "jenkins_profile" })

}