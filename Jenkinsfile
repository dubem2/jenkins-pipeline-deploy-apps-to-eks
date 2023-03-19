#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                    }
                }
            }
        }
        stage("Deploy sock-shop to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name myapp-eks-cluster"
                        sh "kubectl apply -f complete-demo.yaml"
                    }
                }
            }
        }
        stage("Deploy nginx to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name myapp-eks-cluster"
                        sh "kubectl apply -f nginx-deployment.yaml"
                    }
                }
            }
        }
         stage("Deploy prometheus and grafana") {
            steps {
                script {
                    dir('monitoring') {
                        sh "aws eks update-kubeconfig --name myapp-eks-cluster"
                        sh "kubectl create -f 00-monitoring-ns.yaml"
                        sh "kubectl apply \$(ls *-prometheus-*.yaml | awk ' { print "-f" \$1 }' )"
                        sh "kubectl apply \$(ls *-grafana-*.yaml | awk ' { print "-f" \$1 }'  | grep -v grafana-import)"
                        sh "kubectl apply -f 23-grafana-import-dash-batch.yaml"
                    }
                }
            }
        }
    }
}