# Dockerfile de Postgresql 9.5 Para Backups

FROM registry.wtransnet.local:5000/sistemas/ubuntu16.04:latest
MAINTAINER jporta@wtransnet.com

RUN mkdir -p /usr/local/wtn/bin

########POSTGRES########
ENV DEBIAN_FRONTEND noninteractive
ENV DEBUG        true

ENV PGOSUSER     postgres
ENV PGOSUSERID   54321
ENV PGOSGROUP    postgres
ENV PGOSGROUPID  54321

ENV PGVERSION    9.5

# Usuario y grupo de postgresql
RUN groupadd -r ${PGOSGROUP} --gid=${PGOSGROUPID} \
 && useradd -r -g ${PGOSGROUP} --uid=${PGOSUSERID} ${PGOSUSER}

RUN apt-get update \
 && apt-get install -y wget

# Respositorio de postgresql 
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y gosu \
 && apt-get install -y postgresql-common \
 && cp /etc/postgresql-common/createcluster.conf /etc/postgresql-common/createcluster.conf.original \
 && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
 && apt-get install -y postgresql-${PGVERSION} postgresql-client-${PGVERSION} postgresql-contrib-${PGVERSION}

###########POSTFIX#################
# Install Postfix.
# RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
# RUN echo "postfix postfix/mailname string mail.cpd.wtransnet.net" >> preseed.txt
# Use Mailbox format.
# RUN debconf-set-selections preseed.txt
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

# RUN postconf -e myhostname="cron.wtransnet.com"
# RUN postconf -e relayhost="mail.cpd.wtransnet.net"
# RUN service postfix start
############SWAKS (Swiss army knife SMTP)##############
# Servirá como cliente para mandar mails del contenedor "cron" al contenedor "postfix", ya que "mail" no funciona
RUN apt-get install -y swaks
############SSH#####################
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:wtn' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
###########TAREAS EN CABINA########
# The host scripting tools kits are available from the Technical Support website if you have a support
# account: http://support.dell.com/EqualLogic -->Download --->Firmware 7.1.14 Host Scripting Tools - Linux 
# ej: EqlCliExec.py -g 192.168.6.81 -a grpadmin -p PASSWORD "volume create int-pv-pg2-pgdata 5GB snap-reserve 40%"
# ej: EqlCliExec.py -g 192.168.6.81 -a grpadmin -p PASSWORD "volume select int-pv-pg2-pgdata 100MB access create ipaddress 192.168.6.190"
# ej: EqlCliExec.py -g 192.168.6.81 -a grpadmin -p PASSWORD "volume select int-pv-pg2-pgdata snapshot create-now" 
# Mas docu: http://people.stern.nyu.edu/nwhite/scrc/ps4000e/110-6028-EN-R1_CLI_REFERENCE_V5.0.pdf
RUN apt-get remove -y python3
RUN apt-get install -y python
RUN apt-get install -y python-pip
RUN pip install paramiko
ADD equallogic-script/ /tmp/
RUN cd /tmp && python setup.py install
###########END#####################
run rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /usr/bin/
RUN chmod a+x /usr/bin/entrypoint.sh
ENTRYPOINT  ["entrypoint.sh"]