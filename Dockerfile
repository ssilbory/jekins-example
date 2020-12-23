FROM ubuntu:latest
ENV TOMCAT_VERSION 8.0.53

# We don't care about our layer in this container
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install --no-install-recommends openjdk-8-jre-headless wget && apt-get clean && rm -r /var/lib/apt/lists/*
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz
RUN tar xf /tmp/tomcat.tgz -C /opt

# This is pretty extreme we might need these for debugging, package installation...
RUN dpkg --force-all -r apt bash perl-base wget
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm -rf /tmp/tomcat.tgz /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs /opt/tomcat/webapps/ROOT
RUN rm -rf  /usr/share/*

COPY src/sample.war /opt/tomcat/webapps/ROOT.war

# Next Stage
FROM scratch
# Note the --from=0 we are copying the prior stage.
# This makes for a smaller image, but it's not great for sharing layers.
COPY --from=0 / /
CMD /opt/tomcat/bin/catalina.sh run
