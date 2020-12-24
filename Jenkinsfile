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
      NIRMATA_URL       = 'https://nirmata.io'
      NCTL_URL          = 'https://nirmata-downloads.s3.us-east-2.amazonaws.com/nctl/nctl_3.1.0-rc2/nctl_3.1.0-rc2_linux_64-bit.zip'
      GIT_REPO          = 'ssilbory/alpine-tomcat'
      APP_NAME          = 'alpine-tomcat'
      ENV_NAME          = 'tomcat'
      YAML_FILE         = 'tomcat.yaml'
  }
  stages {
    stage('Build with Kaniko') {
      steps {
        git 'https://github.com/silborynirmata/jekins-example.git'
        sh "/kaniko/executor --context `pwd` --destination ${GIT_REPO}:${env.BUILD_ID}"
        sh "sed  s/:latest/:${env.BUILD_ID}/ -i ${YAML_FILE}"
        sh '''if command -v nctl ;then
                nctl environments apps apply ${APP_NAME} -e ${ENV_NAME} -f ${YAML_FILE}
              else
                if [ -f nctl ];then
                  chmod +x nctl
                else
                  wget -O nctl.zip ${NCTL_URL}
                  unzip -o nctl.zip
                  chmod 500 nctl
                fi
                ./nctl environments apps apply ${APP_NAME} -e ${ENV_NAME} -f ${YAML_FILE}
              fi'''
      }
    }
  }
}
