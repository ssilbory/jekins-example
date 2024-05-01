# Using Jenkins file

This repo contains examples of using Jenkins to build a simple tomcat app in Kubernetes Pod.  This is harder than you might initially think as you can't simply run docker in another container.

To use
- Install or otherwise get access to Jenkins.
- Create a docker secret with your docker login called docker-credentials. Alternately pass this as a Jenkin credential.
"kubectl create secret docker-registry --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email> --dry-run -o yaml >docker-credentials.yaml"
https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials
- Use the Jenkinsfile.kaniko or the like to create the pipeline and adjust the varibles in the environment section to match your app.


*To use a jenkins credential for docker repo access you will need to

- Remove the volume and volume mount section from the pod template.
- Define a Jenkins Cred for REGISTRY_PASSWORD, and define a variable REGISTRY_USER
- For Kaniko create a file /kaniko/.docker/config.json with user and password for your docker repo using your docker repo creds.  Example
'''echo "{\"auths\":{\"$REGISTRY\":{\"username\":\"${REGISTRY_USER}\",\"password\":\"${REGISTRY_PASSWORD}\"}}}" > /kaniko/.docker/config.json'''
- For Img create /root/.docker/config.json as above or run "img login -u $REGISTRY_USER -p REGISTRY_PASSWORD $REGISTRY"

# Sample Jenkinsfiles
- Jenkinsfile.img
A Jenkinsfile using img (see img-jenkins dir for building a Docker image for this.)
https://github.com/genuinetools/img
- Jenkinsfile.kaniko        
A Jenkinsfile using Kaniko
https://github.com/GoogleContainerTools/kaniko
- Jenkinsfile.docker        
A simple Jenkinsfile Docker build for VMs and Docker in Docker.  This is bad idea for a number of reasons, and won't work in more modern clusters.
