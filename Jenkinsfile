pipeline {
    agent any
    
    

    tools {
        maven "maven"
    }

    stages {
        stage('Initialize'){
            steps{
                git credentialsId: 'Gitlab', url: 'https://git.nagarro.com/freshertraining2022/prasadpatil.git'
            }
        }
        stage('Build'){
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean install"
            }
        post{
            success {
                junit '**/target/surefire-reports/TEST-*.xml'
                archiveArtifacts 'target/*.war'
                }
            }
        }
        stage('SonarQube analysis') {
            steps{
            withSonarQubeEnv('sq1') { 
                sh "mvn sonar:sonar \
                -Dsonar.projectKey=Assignment \
                -Dsonar.host.url=http://192.168.56.105:9000 \
                -Dsonar.login=fddeeaa514c580cb0e8e6d690a8098e4d67622de"
                }
            }
        }
        stage ('Server') {
            steps {
              rtServer (
                     id: "Artifactory",
                     url: 'http://192.168.56.105:8081/artifactory',
                     username: 'prasad',
                     password: 'Prasad@123'
                    )
                }
            }
        stage('Upload') {
            steps{
                rtUpload (
                    serverId:"Artifactory" ,
                    spec: '''{
                        "files": [
                            {
                                "pattern": "*.war",
                                "target": "prasadpatil"
                            }
                        ]
                    }''',
                )
            }
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "Artifactory"
                )
            }
        }
        
         stage('Build Docker Image'){
            steps{
                script{
                    dockerImage = docker.build "calculator"
                }
            }
        }
    //     stage('Uploading Image'){
    //             steps{
    //                 script{
    //                     docker.withRegistry( '', registryCredential ) {
    //                     dockerImage.push()
    //                 }
    //             }
    //         }
    //     }
        
     stage('Pushing to ECR') {
        steps{
         script {
                docker.withRegistry('https://876724398547.dkr.ecr.us-west-2.amazonaws.com', 'ecr:us-west-2:AWS-ECR') {
                def myImage = docker.build('prasad-assignment-9')
                myImage.push('latest')
                
            }
         }
        }
      }
      
       stage('Run docker image on EC2'){
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'AWS-ECR']]){
                        sh 'sudo ssh -o StrictHostKeyChecking=no -i "prasad-keypair.pem" ec2-user@ec2-35-88-95-62.us-west-2.compute.amazonaws.com "docker ps "'
                        sh 'sudo ssh -o StrictHostKeyChecking=no -i "prasad-keypair.pem" ec2-user@ec2-35-88-95-62.us-west-2.compute.amazonaws.com "docker pull 876724398547.dkr.ecr.us-west-2.amazonaws.com/prasad-assignment-9:latest"'
                        sh 'sudo ssh -o StrictHostKeyChecking=no -i "prasad-keypair.pem" ec2-user@ec2-35-88-95-62.us-west-2.compute.amazonaws.com "docker run -d -p 8090:8080 876724398547.dkr.ecr.us-west-2.amazonaws.com/prasad-assignment-9:latest"'
                        sh 'sudo ssh -o StrictHostKeyChecking=no -i "prasad-keypair.pem" ec2-user@ec2-35-88-95-62.us-west-2.compute.amazonaws.com  "docker ps"'
                    }
                }
        }
        
    }
}

