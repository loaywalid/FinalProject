# ITI - Final Project

# Project overview : 


Deploy a backend applicatoin on kubernetes cluster using CI/CD jenkins pipeline


        
# 1) Build infrastrucutre using terraform 
                terraform init
                terraform plan
                terraform apply
                
                
                
# Components created : 
   1-EKS Cluster <BR>
   2-VPC ( Public subnet - Private subnet ) <BR>
   3-Bastion Host <BR>
        
        
# 2) Dockerfile for building custom image for jenkins 
                docker build -t loaywalid/custom-jenkins .
                
 # 3) Using jenkins to make the CI/CD for the application 
                application : https://github.com/atefhares/DevOps-Challenge-Demo-Code.git
