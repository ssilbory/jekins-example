# jekins-example

This repo contains an example of using Nirmata and nctl to deploy a simple tomcat app.  It makes use of Kaniko to build in a container without needed access to the docker daemon.

To use
- Install or otherwise get access to Jenkins.
- Create a API Key in Nirmata and create a secret text credentials called NIRMATA_TOKEN accessable by your Jenkins pipeline.
- Create a docker secret with your docker login called docker-credentials. Alternately pass this as a Jenkin credential*.
"kubectl create secret docker-registry --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email> --dry-run -o yaml >file"
https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials
- Use the Jenkinsfile to create adjusting the varibles in the environment secition to match your apps, and Nirmata installation.

Additional files:
- update-app.sh           Updates a running app.
- update-catalog-app.sh   Updates a catalog app.
- create-app.sh           Creates a running app.
- create-catalog-app.sh   Create a catalog app.


*You will need to create a file /kaniko/.docker/config.json with user and password for your docker repo using your docker repo creds.  Example
echo "{\"auths\":{\"$REGISTRY\":{\"username\":\"${REGISTRY_USER}\",\"password\":\"${REGISTRY_PASSWORD}\"}}}" > /kaniko/.docker/config.json

# Jenkins Setup
- Import jenkins helm repo Catalog -> Helm -> Add Helm Repo use https://charts.jenkins.io
- Import Jenkins chart to a catalog app named jenkins.
- Edit application and select Other catagory.
- Download and Import SA yaml for cluster access.
https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml 
- Deploy as a standard app or as an addon.  Note that you will need to be an admin and the namespace must be jenkins.
- Login into Jenkins UI with password stord in the key jenkins-admin-password in the secret-latest-jenkins secret.
- Update plugin
