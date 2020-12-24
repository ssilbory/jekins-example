FROM ubuntu:18.04
ENV TOMCAT_VERSION 8.0.53

# We will set kaniko to do --single-snapshot so we skip intermediate layers

# Get my source code
COPY webapp /src
WORKDIR /src

# Install ant and jdk
RUN apt-get update 
RUN apt-get -y install ant openjdk-11-jdk maven wget

# Build
RUN mvn package

# install tomcat
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz
RUN tar xf /tmp/tomcat.tgz -C /opt 
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Cleanup
RUN apt-get -y install openjdk-11-jre-headless
RUN apt-get -y remove ant openjdk-11-jdk maven wget
RUN apt-get -y auto-remove
RUN apt-get clean all

RUN mv /src/target/sparkjava-hello-world-1.0.war /opt/tomcat/webapps/sparkjava-hello-world-1.0.war
RUN rm -rf /src
RUN ls -l /opt/tomcat/webapps/

# Run tomcat
CMD /opt/tomcat/bin/catalina.sh run
