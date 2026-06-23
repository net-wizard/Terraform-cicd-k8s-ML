pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "thoratshubham"
        IMAGE_TAG      = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Images') {
            steps {
                sh '''
                    docker build -t $DOCKERHUB_USER/ml-api:$IMAGE_TAG \
                        ./services/ml-api
                    docker build -t $DOCKERHUB_USER/data-service:$IMAGE_TAG \
                        ./services/data-service
                    docker build -t $DOCKERHUB_USER/monitor-service:$IMAGE_TAG \
                        ./services/monitor-service
                    docker build -t $DOCKERHUB_USER/ui:$IMAGE_TAG \
                        ./services/ui
                '''
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login \
                            -u $DOCKER_USER --password-stdin
                        docker push $DOCKERHUB_USER/ml-api:$IMAGE_TAG
                        docker push $DOCKERHUB_USER/data-service:$IMAGE_TAG
                        docker push $DOCKERHUB_USER/monitor-service:$IMAGE_TAG
                        docker push $DOCKERHUB_USER/ui:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Update K8s Manifests') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-credentials',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh '''
                        git config user.email "shubhamthorat2202@gmail.com"
                        git config user.name "Jenkins CI"

                        sed -i "s|image: thoratshubham/ml-api:.*|image: thoratshubham/ml-api:$IMAGE_TAG|g" \
                            k8s/ml-api/deployment.yaml
                        sed -i "s|image: thoratshubham/data-service:.*|image: thoratshubham/data-service:$IMAGE_TAG|g" \
                            k8s/data-service/deployment.yaml
                        sed -i "s|image: thoratshubham/monitor-service:.*|image: thoratshubham/monitor-service:$IMAGE_TAG|g" \
                            k8s/monitor-service/deployment.yaml
                        sed -i "s|image: thoratshubham/ui:.*|image: thoratshubham/ui:$IMAGE_TAG|g" \
                            k8s/ui/deployment.yaml

                        git add k8s/
                        git commit -m "ci: update image tags to $IMAGE_TAG [skip ci]"
                        git push https://$GIT_USER:$GIT_PASS@github.com/net-wizard/Terraform-cicd-k8s-ML.git HEAD:master
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded — images pushed as $IMAGE_TAG"
        }
        failure {
            echo "Pipeline failed — check logs above"
        }
        always {
            sh 'docker logout'
        }
    }
}