pipeline {
    agent any

    stages {
        stage('CI') {
            steps {
                git ' https://github.com/loaywalid/DevOps-Challenge-Demo-Code '
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                sh """
                docker login -u ${USERNAME} -p ${PASSWORD}
                docker build -f Dockerfile --network host  -t loaywalid/app:v1 . 
                docker push loaywalid/app:v1
                """
            
            }
            }
            
        }
        stage('CD'){
            steps{
                     withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                sh """
                docker login -u ${USERNAME} -p ${PASSWORD}
                kubectl apply -f deployment-redis.yml
                kubectl apply -f redis-service.yml
                kubectl apply -f app-deployment.yml
                kubectl apply -f lb.yml
                """
                     }
            }
        }
        
    }
}
