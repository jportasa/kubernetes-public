FROM ubuntu:16.04

MAINTAINER Joan Porta <sistemas@wtransnet.com>
RUN \
    apt-get update && \
    apt-get install -y gosu libcurl3 vim telnet tcpdump curl wget iputils-ping net-tools mailutils netcat&& \
    rm -rf /var/lib/apt/lists/*

#RUN groupadd -r mysql && useradd -r -g mysql mysql
#RUN mkdir -p /var/lib/mysql
#RUN chown -R mysql:mysql /var/lib/mysql


#COPY entrypoint.sh /usr/local/bin/entrypoint.sh
#RUN chmod +x /usr/local/bin/entrypoint.sh

#VOLUME /var/lib/mysql

#ENTRYPOINT ["entrypoint.sh"]
#CMD ["/script/run.sh"]
#CMD ["/bin/bash"]
CMD ["/bin/sleep","3600"]