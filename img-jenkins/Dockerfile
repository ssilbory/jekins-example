FROM ubuntu:latest

USER root
RUN apt-get update && apt-get -y install wget uidmap unzip && wget https://github.com/genuinetools/img/releases/download/v0.5.11/img-linux-amd64 -O /usr/local/bin/img && chmod 555 /usr/local/bin/img

