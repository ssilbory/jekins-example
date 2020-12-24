pipeline {
  agent {
    kubernetes {
      //cloud 'kubernetes'
      defaultContainer 'kaniko'
      yaml """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug-539ddefcae3fd6b411a95982a830d987f4214251
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 9999999
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-credentials
          items:
            - key: .dockerconfigjson
              path: config.json
"""
    }
  }
  environment {
      NIRMATA_TOKEN     = credentials('NIRMATA_TOKEN')
  }
  stages {
    stage('Build with Kaniko') {
      steps {
        git 'https://github.com/silborynirmata/jekins-example.git'
        sh "/kaniko/executor --context `pwd` --destination ssilbory/alpine-tomcat:${env.BUILD_ID}"
        sh "sed  s/:latest/:${env.BUILD_ID}/ -i tomcat.yaml"
        sh '''if command -v nctl ;then
                nctl environments apps apply foo -e foo -f tomcat.yaml ''
              else
                if [ -f nctl ];then
                  nctl environments apps apply foo --url https://nirmata.io -e foo -f tomcat.yaml
                else
                  wget -O nctl.zip https://nirmata-downloads.s3.us-east-2.amazonaws.com/nctl/nctl_3.1.0-rc2/nctl_3.1.0-rc2_linux_64-bit.zip
                  unzip -o nctl.zip
                  chmod 500 nctl
                fi
                ./nctl environments apps apply foo --url https://nirmata.io -e foo -f tomcat.yaml 
              fi'''
      }
    }
  }
}
