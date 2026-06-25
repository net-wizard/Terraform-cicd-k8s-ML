resource "aws_security_group" "retailrec_jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security for jenkins"
  vpc_id      = aws_vpc.retailrec_vpc.id
  ingress {
    description = "SSH access to Jenkins EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Browser access to Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Jenkins agent access"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Access to internet for GitHub, ECR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = merge(var.common_tags, { Name = "jenkins_sg" })

}

resource "aws_security_group" "retailrec_eks_sg" {
  name        = "eks_sg"
  description = "Security for EKS cluster"
  vpc_id      = aws_vpc.retailrec_vpc.id

  ingress {
    description = "kubectl API access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP Load Balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Access to internet for ECR to pull Image"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = merge(var.common_tags, { Name = "eks_sg" })

}