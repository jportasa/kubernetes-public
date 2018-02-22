FROM  jenkinsci/jenkins:2.67
MAINTAINER jporta@wtransnet.com
USER root

# Set the timezone.
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN  apt-get update 
RUN  apt-get install -y apt-transport-https ca-certificates wget curl gnupg2 software-properties-common 
RUN  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -  
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
RUN apt-get update 
RUN apt-get -y install docker-ce 
RUN systemctl enable docker

# Ruby para frontend, compilar estilos
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libxml2-dev libxslt-dev libreadline6-dev libyaml-dev \
 && cd /tmp \
 && wget http://ftp.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz \
 && tar -xvzf ruby-2.4.2.tar.gz \
 && cd ruby-2.4.2 \
 && ./configure --prefix=/usr/local \
 && make \
 && make install \ 
 && gem install compass \
 && rm /tmp/ruby-2.4.2.tar.gz \
 && rm -R /tmp/ruby-2.4.2

# Kubernetes, deploy de imagenes en el cluster
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install kubectl

RUN rm -rf /var/lib/apt/lists/*

USER jenkins

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]