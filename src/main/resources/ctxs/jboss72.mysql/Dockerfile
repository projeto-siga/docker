# -------------------------- Dockerfile (jboss) -------------------------- #

FROM daggerok/jboss-eap-7.2:7.2.5-centos
MAINTAINER aloysioy@gmail.com

COPY apps/fly.sh ${JBOSS_HOME}
RUN sudo chmod 755 ${JBOSS_HOME}/fly.sh

RUN sudo mkdir /siga/
RUN sudo mkdir /siga/jdbcsql/

#-JDBC SQL
COPY apps/jdbcsql-1.0.zip /siga/jdbcsql/

#-- Flyway ---
RUN  sudo curl -k -L -o flyway-commandline-3.0.tar.gz https://www.dropbox.com/s/dqwxui71wc64ano/flyway-commandline-3.0.tar.gz?dl=0 \
  && sudo mv flyway-commandline-3.0.tar.gz /siga/

# -- Instalacao flyway --
COPY lib/ojdbc6.jar /siga/flyway-3.0/jars/ojdbc6.jar
COPY lib/mysql-connector-java-5.1.48.jar /siga/flyway-3.0/jars/mysql-connector-java-5.1.48.jar
COPY conf/flyway/flyway.corporativo.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.siga.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigawf.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigasr.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigagc.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigatp.properties /siga/flyway-3.0/conf/

RUN sudo tar -xzf /siga/flyway-commandline-3.0.tar.gz -C /siga/

# --- flyway ---#
#-- init_db:
#-- on ou off - cria usuarios corporativo,siga,sigawf,etc. (off para ambiente de producao)
ENV init_db off
ENV flyway_run off
ENV db_server_name mysql.server
ENV db_server_check_user root
ENV db_server_check_pass siga
ENV db_server_check_url jdbc:mysql://mysql.server:3306
ENV db_server_check_sql "SELECT CURRENT_TIMESTAMP"


#-- Copiar arquivo Modulos
RUN    curl -k -L -o modules.tar.gz https://www.dropbox.com/s/zx1jpwrreivyzjp/modules.tar.gz?dl=0 \
  && mv modules.tar.gz ${JBOSS_HOME}
  
RUN sudo tar -zxf ${JBOSS_HOME}/modules.tar.gz -C ${JBOSS_HOME}

ADD deploy/* ${JBOSS_HOME}/standalone/deployments/

ADD conf/jboss/standalone.xml  ${JBOSS_HOME}/standalone/configuration/standalone.xml

ADD apps/siga-ext.jar ${JBOSS_HOME}/sigadoc/ext/main/

RUN sudo chown -R jboss ${JBOSS_HOME}

CMD ["${JBOSS_HOME}/fly.sh ; ${JBOSS_HOME}/bin/standalone.sh -b 0.0.0.0"]
