FROM alpine:latest
MAINTAINER Joan Porta
RUN apk --update add openssh && \
    apk add rsync && \
	sed -i "s/#PermitRootLogin.*/PermitRootLogin\ yes/" /etc/ssh/sshd_config && \
	/usr/bin/ssh-keygen -A && \
	rm -rf /var/cache/apk/* && \
	echo -e root:toor | chpasswd
EXPOSE 22
CMD ["/usr/sbin/sshd","-D","-E","/dev/stderr"]