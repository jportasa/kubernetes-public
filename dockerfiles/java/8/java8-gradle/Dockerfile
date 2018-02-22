#
# Oracle Java 8 Dockerfile
#
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/oracle-java8
#

# Pull base image.
FROM registry.wtransnet.local:5000/sistemas/ubuntu16.04:latest

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# Define working directory.
#WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ADD entrypoint.sh /usr/bin
RUN chmod 755 /usr/bin/entrypoint.sh

#WORKDIR /git/wtn-auth

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
#La variable MICROSERVICE_NAME se le pasa a través del configmap.
#CMD ["/git/$MICROSERVICE_NAME/gradlew","bootRun"]