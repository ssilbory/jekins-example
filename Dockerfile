# Yes you can build in a multistage dockerfile with a different image than you compile with.
FROM ubuntu:18.04 as compile

# Install ant and jdk
RUN apt-get update && apt-get -y install ant openjdk-8-jdk maven

# Get my source code
COPY webapp /src

WORKDIR /src
RUN mvn package
# No cleanup as this container is discarded

# Setup tomcat directory (name, location...)
FROM alpine:3.9 as installer
ENV TOMCAT_VERSION 8.0.53

RUN apk add wget
# Really we should mirror this in our network
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz

# We don't care about layers as we are throwing this containers away
RUN tar xf /tmp/tomcat.tgz -C /opt
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# No cleanup as this container is discarded
# Note this stage is overkill as we could do this entire thing in one RUN in the next stage.
# Still there are a lot of reason to do it like this for more complex builds. (addition packages, hiding where we download the tomcat image...)

# Final image
# Note that we could use our prior image by cleaning up, creating from scratch, and copying / from the prior image.`
# This takes more time, but let's us share the alpine:3.9 layer with everyone else.
FROM alpine:3.9
# Install just the jre 
RUN apk add --no-cache openjdk8-jre
# Upgrade our packages
RUN apk upgrade --no-cache
# Install the tomcat dir from the tomcat installer stage
COPY --from=installer /opt/tomcat /opt/tomcat
# Install the war file we built
COPY --from=compile /src/target/sparkjava-hello-world-1.0.war /opt/tomcat/webapps/sparkjava-hello-world-1.0.war
RUN ls -l /opt/tomcat/webapps/

# Run tomcat
CMD /opt/tomcat/bin/catalina.sh run
