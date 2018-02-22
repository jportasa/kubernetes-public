FROM registry.wtransnet.local:5000/sistemas/java8:latest

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r jetty && useradd -r -g jetty jetty

ENV JETTY_HOME /usr/local/jetty
ENV PATH $JETTY_HOME/bin:$PATH
#ENV JAVA_OPTIONS="-Xmx XXX"
RUN mkdir -p "$JETTY_HOME"
WORKDIR $JETTY_HOME

ENV JETTY_VERSION 9.3.6.v20151106
ENV JETTY_TGZ_URL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$JETTY_VERSION/jetty-distribution-$JETTY_VERSION.tar.gz

RUN set -xe \
	&& curl -SL "$JETTY_TGZ_URL" -o jetty.tar.gz \
	&& tar -xvf jetty.tar.gz --strip-components=1 \
	&& sed -i '/jetty-logging/d' etc/jetty.conf \
	&& rm -fr demo-base javadoc \
	&& rm jetty.tar.gz*

COPY start.ini $JETTY_HOME/start.ini
COPY lib/ext $JETTY_HOME/lib/ext
COPY lib/logging $JETTY_HOME/lib/logging
COPY etc/jetty-deploy.xml  $JETTY_HOME/etc/jetty-deploy.xml
COPY modules $JETTY_HOME/modules

RUN mkdir $JETTY_HOME/webapps-config
RUN mkdir -p /mnt/nfs/

RUN chown -R jetty.jetty /usr/local/jetty

ENV TMPDIR /tmp/jetty
RUN set -xe \
	&& mkdir -p "$TMPDIR" \
	&& chown -R jetty:jetty "$TMPDIR"

RUN set -xe \
	&& java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start="server,http,deploy,jsp,jstl,ext,resources,websocket,setuid,jmx-remote" \
	&& rm -rf /tmp/hsperfdata_root

EXPOSE 8080

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["java", "-jar", "/usr/local/jetty/start.jar"]


#CMD [""]

#Para hacer troubleshooting
#COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
#RUN chmod a+x /usr/local/bin/docker-entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
