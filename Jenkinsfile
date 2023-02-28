pipeline {
    agent any 

    environment{
        DOCKER_REGISTRY = 'https://hub.docker.com/repository/docker/jaybamaniya/my-app/general'
       // DOCKER_USERNAME = 'jaybamaniya'
       // DOCKER_PASSWORD = 'upvision@123'
        DOCKER_IMAGE_NAME = 'jaybamnaiya/my-app:jay-tf-1.0'
        //DOCKER_FILE_PATH = ''
    }
    
    stages{
        stage('test on dev'){
            steps{
                script{
                    echo "hello python"
                }
            }
        }
        stage('build docker image'){
            steps{
                // Define the Docker credentials
                withCredentials([usernamePassword(credentialsId: 'jay-docker', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    // Login to Docker registry
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    
                    // Build and push Docker image
                    sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."

                    sh "docker push ${env.DOCKER_IMAGE_NAME}"
                    
                    // Logout of Docker registry
                }

                // script{
                //     echo "Building docker images"
                //     sh 'docker login -u ${env.DOCKER_USERNAME} -p ${env.DOCKER_PASSWORD} ${env.DOCKER_REGISTRY}'
                //     sh 'docker build -t ${env.DOCKER_IMAGE_NAME} . '
                //     sh 'docker push ${env.DOCKER_IMAGE_NAME}'

                // }
            }
        }
        stage('provision server'){
            environment{
                AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps{
                script{
                    dir('terraform')
                        sh "terrraform init"
                        sh "terraform apply -auto-approve"
                       EC2_PUBLIC_IP = sh(
                          script: "terraform output ec2_ip",
                          returnStdout: true
                       ).trim()
                }
            }
        }
        stage('test on prod'){
            steps{
                script{
                    echo 'deploying docker image in ec2'

                    def shellcmd = "./compose.sh ${DOCKER_IMAGE_NAME}"
                    def ec2Instance = "ubuntu@${EC2_PUBLIC_IP}"

                    sshagent(credentials: ['ssh-server']){
                        sh "scp compose.sh ${ec2Instance}:/home/ubuntu"
                        sh "scp docker-compose.yml ${ec2Instance}:/home/ubuntu"
                        sh "ssh -i ${ec2Instance} ${shellcmd}"
                    
                    }
                    
                    
                }
            }
        }
    }
}


// piepline {
//     agent any {
    
//     stages{
//         stage('test on dev'){
//             steps{
//                 sh 'python demo.py'
//             }
//         }
//         stage('test on stage'){
//             steps{
//                 sh 'python demo.py'
//             }
//         }

//         stage('test on prod'){
//             steps{
//                 script{

//                 }
                
//             }
//         }
//     }

//     }
// }
