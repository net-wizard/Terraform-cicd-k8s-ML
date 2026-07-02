resource "null_resource" "push_jenkins_image" {
  depends_on = [aws_ecr_repository.retailrec_jenkins]

  triggers = {
    ecr_repo_url    = aws_ecr_repository.retailrec_jenkins.repository_url
    dockerfile_hash = filemd5("${path.module}/../jenkins/Dockerfile")

  }
  provisioner "local-exec" {
    command = <<-EOT
        aws ecr get-login-password | docker login --username AWS --password-stdin ${aws_ecr_repository.retailrec_jenkins.repository_url}
        docker build -t ${aws_ecr_repository.retailrec_jenkins.repository_url}:latest ../jenkins/.
        docker push ${aws_ecr_repository.retailrec_jenkins.repository_url}:latest 
        EOT

  }

}