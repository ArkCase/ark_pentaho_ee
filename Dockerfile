FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base_java8:latest
ENV BASE_PATH=/home/pentaho/app/pentaho/pentaho-server \
    PENTAHO_LICENSE_PATH=/home/pentaho/install \
    PENTAHO_LICENSE_INSTALLER=/home/pentaho/app/pentaho/license-installer \
    PENTAHO_PDI_LICENSE=/home/pentaho/app/pentaho-pdi/license-installer \
    PENTAHO_USER=pentaho \
    PENTAHO_PDI=pentaho-pdi
    
ARG RESOURCE_PATH="artifacts"
ARG PENTAHO_SERVER_EE="8.3.0.0-371"
ARG PENTAHO_SERVER_LICENSES="2020"
ARG PIR_PLUGIN_EE="8.3.0.0-371"
ARG PAZ_PLUGIN_EE="8.3.0.0-371"
ARG PDD_PLUGIN_EE="8.3.0.0-371"
ARG PDI_EE_CLIENT="8.3.0.0-371"
ARG MYSQL_CONNECTOR_VERSION="8.0.25"
ARG MARIADB_CONNECTOR_VERSION="2.2.6"
ARG ARKCASE_PRE_AUTH_VERSION="4-1.1.1"
ARG PENTAHO_PORT="2002"

LABEL ORG="Armedia LLC" \
      APP="Pentaho EE" \
      VERSION="1.0" \
      IMAGE_SOURCE=https://github.com/ArkCase/ark_pentaho_ee \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>"

#-----------PENTAHO SETUP-------------------------------------
RUN mkdir -p /home/pentaho/data/pentaho && \
    mkdir -p /home/pentaho/app/pentaho && \
    mkdir -p /home/pentaho/tmp/pentaho && \
    mkdir -p /home/pentaho/install     &&  \
    mkdir -p /home/pentaho/install/pentaho-pdi && \
    mkdir -p /home/pentaho/tmp/pentaho-pdi && \
    mkdir -p /home/pentaho/app/pentaho-pdi && \
    mkdir -p /home/pentaho/data/pentaho-pdi && \
    mkdir -p /home/pentaho-pdi/.pentaho && \
    mkdir -p /home/pentaho/.pentaho && \
    mkdir -p /home/pentaho/.kettle &&\
    yum install -y unzip && \
    useradd --system --user-group ${PENTAHO_USER} && \
    useradd --system --user-group ${PENTAHO_PDI} && \
    yum install -y expect && \
    yum clean -y all

COPY ${RESOURCE_PATH}/pentaho-server-licenses-${PENTAHO_SERVER_LICENSES}.zip \
     ${RESOURCE_PATH}/pir-plugin-ee-${PIR_PLUGIN_EE}-dist.zip \
     ${RESOURCE_PATH}/paz-plugin-ee-${PAZ_PLUGIN_EE}-dist.zip  \
     ${RESOURCE_PATH}/pdd-plugin-ee-${PDD_PLUGIN_EE}-dist.zip \
     ${RESOURCE_PATH}/pentaho-server-ee-${PENTAHO_SERVER_EE}-dist.zip /home/pentaho/install/
COPY ${RESOURCE_PATH}/pdi-ee-client-${PDI_EE_CLIENT}-dist.zip /home/pentaho/tmp/pentaho-pdi
COPY ${RESOURCE_PATH}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${BASE_PATH}/tomcat/lib/
#------------------Unzipping all packages-------------------------------------------------------
RUN cd /home/pentaho/install && \
    unzip pir-plugin-ee-${PIR_PLUGIN_EE}-dist.zip && \
    unzip paz-plugin-ee-${PAZ_PLUGIN_EE}-dist.zip && \
    unzip pdd-plugin-ee-${PDD_PLUGIN_EE}-dist.zip && \
    unzip pentaho-server-ee-${PENTAHO_SERVER_EE}-dist.zip && \
    unzip pentaho-server-licenses-${PENTAHO_SERVER_LICENSES}.zip && \
    cp -rf pentaho-server-ee-${PENTAHO_SERVER_EE}/* /home/pentaho/app/pentaho && \
    cd /home/pentaho/tmp/pentaho-pdi && \
    unzip pdi-ee-client-${PDI_EE_CLIENT}-dist.zip && \
    cp -rf /home/pentaho/tmp/pentaho-pdi/pdi-ee-client-${PDI_EE_CLIENT}/* /home/pentaho/app/pentaho-pdi && \
    rm /home/pentaho/install/*.zip
#----------------COPYING expect script-----------------------------------------------------------     
COPY expect-script.exp /home/pentaho/app/pentaho/
COPY expect-script-paz.exp ${PENTAHO_LICENSE_PATH}/paz-plugin-ee-${PAZ_PLUGIN_EE}
COPY expect-script-pdd.exp ${PENTAHO_LICENSE_PATH}/pdd-plugin-ee-${PDD_PLUGIN_EE}
COPY expect-script-pir.exp ${PENTAHO_LICENSE_PATH}/pir-plugin-ee-${PIR_PLUGIN_EE}
COPY expect-script-pdi.exp /home/pentaho/app/pentaho-pdi
#-----------Expect script to extract all packages-------------------------------
RUN cd /home/pentaho/app/pentaho/ && \
    ./expect-script.exp && \
     cd ${PENTAHO_LICENSE_PATH}/paz-plugin-ee-${PAZ_PLUGIN_EE} && \
    ./expect-script-paz.exp && \
    cd ${PENTAHO_LICENSE_PATH}/pdd-plugin-ee-${PDD_PLUGIN_EE} && \
    ./expect-script-pdd.exp && \
    cd ${PENTAHO_LICENSE_PATH}/pir-plugin-ee-${PIR_PLUGIN_EE} && \
    ./expect-script-pir.exp && \
    cd /home/pentaho/app/pentaho-pdi && \
    ./expect-script-pdi.exp
#--------------------Database configuration templates------------------
COPY ${RESOURCE_PATH}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${BASE_PATH}/tomcat/lib/
COPY ${RESOURCE_PATH}/mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar ${BASE_PATH}/tomcat/lib/
RUN chmod -R 644 ${BASE_PATH}/tomcat/conf/server.xml
    
#---------preauthentication setup----------------------------------------------
COPY ${RESOURCE_PATH}/arkcase-preauth-springsec-v${ARKCASE_PRE_AUTH_VERSION}-bundled.jar ${BASE_PATH}/tomcat/webapps/pentaho/WEB-INF/lib/
#---------Update Pentaho to support report designer within ArkCase iframe---------
RUN cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/home/properties/ ${BASE_PATH}/tomcat/webapps/pentaho/mantle/ && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/home/content ${BASE_PATH}/tomcat/webapps/pentaho/mantle && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/home/css ${BASE_PATH}/tomcat/webapps/pentaho/mantle && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/home/js ${BASE_PATH}/tomcat/webapps/pentaho/mantle && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/home/images/ ${BASE_PATH}/tomcat/webapps/pentaho/mantle/images && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/browser/lib ${BASE_PATH}/tomcat/webapps/pentaho/mantle && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/browser/css/browser.css ${BASE_PATH}/tomcat/webapps/pentaho/mantle/css && \
    cp -rf  ${BASE_PATH}/tomcat/webapps/pentaho/mantle/browser/* ${BASE_PATH}/tomcat/webapps/pentaho/mantle && \
    chown -R pentaho:pentaho /home/pentaho/* && \
    chmod -R 777  /home/pentaho/* && \
    chmod -R 777  /home/pentaho/ && \
    sed -i  "s/l\&\&l.className\&\&l/l&&l/g" ${BASE_PATH}/pentaho-solutions/system/reporting/reportviewer/compressed/reportviewer-app.js
ENV PATH=${BASE_PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
USER pentaho 
RUN sh ${PENTAHO_LICENSE_INSTALLER}/install_license.sh  install -q "${PENTAHO_LICENSE_PATH}/Pentaho Analysis Enterprise Edition.lic" && \
    sh ${PENTAHO_LICENSE_INSTALLER}/install_license.sh  install -q "${PENTAHO_LICENSE_PATH}/Pentaho BI Platform Enterprise Edition.lic" && \
    sh ${PENTAHO_LICENSE_INSTALLER}/install_license.sh  install -q "${PENTAHO_LICENSE_PATH}/Pentaho Dashboard Designer.lic" && \
    sh ${PENTAHO_LICENSE_INSTALLER}/install_license.sh  install -q "${PENTAHO_LICENSE_PATH}/Pentaho Reporting Enterprise Edition.lic" && \
    sh ${PENTAHO_PDI_LICENSE}/install_license.sh  install -q "${PENTAHO_LICENSE_PATH}/Pentaho Analysis Enterprise Edition.lic" && \
    sh ${PENTAHO_PDI_LICENSE}/install_license.sh  install -q "${PENTAHO_LICENSE_PATH}/Pentaho PDI Enterprise Edition.lic" && \
    rm ${PENTAHO_LICENSE_PATH}/*.lic
EXPOSE ${PENTAHO_PORT}
WORKDIR ${BASE_PATH}
CMD ["start-pentaho.sh"]