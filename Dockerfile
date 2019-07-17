#
# image-service is based on tomcat7 official image
# 
#
FROM tomcat:7-jre8-alpine

RUN mkdir -p /data \
	/data/images \
	/data/images/config \
    /data/images/elasticsearch \
    /data/images/store \
    /data/images/incoming \
    /data/images/bin/imgcnv

ARG ARTIFACT_URL=https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/ala-images/0.9.2/ala-images-0.9.2.war
ARG WAR_NAME=images
ENV IMAGE_SERVICE_BASE_URL http://localhost:8080/images

# Copia war para imagem
# ADD https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/ala-images/0.9/ala-images-0.9.war $CATALINA_HOME/webapps/images.war
RUN wget $ARTIFACT_URL -q -O /tmp/$WAR_NAME && \
    apk add --update tini && \
    mkdir -p $CATALINA_HOME/webapps/$WAR_NAME && \
    unzip /tmp/$WAR_NAME -d $CATALINA_HOME/webapps/$WAR_NAME && \
    rm /tmp/$WAR_NAME

#    mv $CATALINA_HOME/webapps/$WAR_NAME $CATALINA_HOME/webapps/images


# FIX DO ERRO DE JS COM URL HARD-CODED PARA IMAGE-SERVER
#RUN unzip $CATALINA_HOME/webapps/$WAR_NAME plugins/images-client-plugin-0.8/js/ala-image-viewer.js -d /tmp/ && \
#    sed 's#    var imageServiceBaseUrl = .*#    var imageServiceBaseUrl = "https\://images\.ala-dev\.vertigo\.com\.br/images";#g' -i /tmp/plugins/images-client-plugin-0.8/js/ala-image-viewer.js && \
#    cd /tmp/ && \
#    zip -d $CATALINA_HOME/webapps/$WAR_NAME plugins/images-client-plugin-0.8/js/ala-image-viewer.js && \
#    zip -u $CATALINA_HOME/webapps/$WAR_NAME plugins/images-client-plugin-0.8/js/ala-image-viewer.js

# default DB is "jdbc:postgresql://pgdbimage/images"
COPY ./data/images/config/images-config.properties /data/images/config/

# Tomcat configs
#COPY ./tomcat-conf/* /usr/local/tomcat/conf/	

VOLUME /data/images/store /data/images/elasticsearch

EXPOSE 8080

# replace-string para corrigir domains (kubernetes)
#COPY ./scripts/* /opt/
#ENV ALA_REPLACE_FILES /data/images/config/images-config.properties
# muda entrypoint, mantém cmd
#ENTRYPOINT ["/opt/ala-entrypoint.sh","tini", "--"]

ENTRYPOINT ["tini", "--"]
CMD ["catalina.sh", "run"]
