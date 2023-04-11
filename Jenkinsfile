podTemplate(label: 'mypod', serviceAccount: 'jenkins', containers: [ 
    containerTemplate(
      name: 'docker', 
      image: 'docker', 
      command: 'cat', 
      resourceRequestCpu: '50m',
      resourceLimitCpu: '150m',
      resourceRequestMemory: '150Mi',
      resourceLimitMemory: '250Mi',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'kubectl', 
      image: 'amaceog/kubectl',
      resourceRequestCpu: '10m',
      resourceLimitCpu: '200m',
      resourceRequestMemory: '150Mi',
      resourceLimitMemory: '250Mi', 
      ttyEnabled: true, 
      command: 'cat'
    ),
    containerTemplate(
      name: 'helm', 
      image: 'alpine/helm:3.11.1', 
      resourceRequestCpu: '50m',
      resourceLimitCpu: '150m',
      resourceRequestMemory: '150Mi',
      resourceLimitMemory: '250Mi',
      ttyEnabled: true, 
      command: 'cat'
    )
  ],

  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    hostPathVolume(mountPath: '/usr/local/bin/helm', hostPath: '/usr/local/bin/helm')
  ]
  ) {
    node('mypod') {

        def REPOSITORY_URI = "sisipka/nginx"
        def HELM_APP_NAME = "nginx-app"
        def HELM_CHART_DIRECTORY = "helm_nginx"

        stage('Get latest version of code') {
          checkout scm
        }
        stage('Check running containers') {
            container('docker') {  
                sh 'hostname'
                sh 'hostname -i' 
                sh 'docker ps'
                sh 'ls'
              
            }
            container('kubectl') { 
                sh 'kubectl get pods -n jenkins'  
            }
            container('helm') { 
                sh 'helm list'
                sh 'helm version'     
            }
        }  

        stage('Build Image'){
            container('docker'){

              withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker login --username="${USERNAME}" --password="${PASSWORD}"'
                sh "docker build -t ${REPOSITORY_URI}:${BUILD_NUMBER} ."
                sh 'docker image ls' 
              } 
                
            }
        } 

        stage('Testing') {
            container('docker') { 
              sh 'whoami'
              sh 'hostname -i'
              sh 'cat /etc/os-release'
              sh 'echo ${currentVersion}'
              sh 'echo ${newVersion}'                  
            }
        }

        stage('Push Image'){
            container('docker'){
              withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker image ls'
                sh "docker push ${REPOSITORY_URI}:${BUILD_NUMBER}"
              }                 
            }
        } 
        
        stage('Deploy Image to k8s'){
            when { tag "v*" }
            container('helm'){
              sh 'helm list'
              sh "helm lint ./${HELM_CHART_DIRECTORY}"
              sh "helm upgrade -i -n jenkins --set image.tag=$tag ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}"
              sh "helm list | grep ${HELM_APP_NAME}"
              sh 'echo "$tag"'
              }
            
         }      
        
    }
}