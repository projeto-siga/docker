# -------------------------- Dockerfile (jboss) -------------------------- #

FROM centos:centos6
MAINTAINER tssesia@jfrj.jus.br

#--- UTILITARIOS ---
RUN yum -y install unzip
RUN yum -y install tar

#--- JDK ---
ADD apps/jdk-6u25-linux-x64-rpm.bin /siga/
RUN chmod +x /siga/jdk-6u25-linux-x64-rpm.bin
RUN /siga/jdk-6u25-linux-x64-rpm.bin
RUN rm /siga/jdk-6u25-linux-x64-rpm.bin
ENV JAVA_HOME /usr/java/jdk1.6.0_25/

#--- JBOSS ---
ADD apps/jboss-eap-5.2.0.zip /siga/
RUN unzip /siga/jboss-eap-5.2.0.zip -d /siga/
RUN rm /siga/jboss-eap-5.2.0.zip

#--- CRIAÇÃO DA INSTANCIA SIGA ---
RUN cp -dpfR /siga/jboss-eap-5.2/jboss-as/server/default /siga/jboss-eap-5.2/jboss-as/server/sigadoc


#--- BIBLIOTECAS JBOSS ---
ADD lib/ /siga/jboss-eap-5.2/jboss-as/server/sigadoc/lib/

#--- ARQUIVOS DE CONFIGURACAO DO JAVA ---

#-- Definicao do Random ---
ADD conf/java/java.security /usr/java/default/jre/lib/security/

#--- Java Cryptography Extension Unlimited Strength Jurisdiction Policy Files ---
ADD jce/local_policy.jar /usr/java/default/jre/lib/security/local_policy.jar
ADD jce/US_export_policy.jar /usr/java/default/jre/lib/security/US_export_policy.jar


#--- ARQUIVOS DE CONFIGURAÇÃO DO JBOSS ---
ADD conf/login-config.xml /siga/jboss-eap-5.2/jboss-as/server/sigadoc/conf/
ADD conf/jboss-log4j.xml /siga/jboss-eap-5.2/jboss-as/server/sigadoc/conf/
ADD conf/jboss-service.xml /siga/jboss-eap-5.2/jboss-as/server/sigadoc/conf/
ADD conf/siga.properties /siga/jboss-eap-5.2/jboss-as/server/sigadoc/conf/
ADD conf/jbossweb.sar/server.xml /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/jbossweb.sar/

ADD conf/oracle-ds.xml /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/
ADD conf/properties-service.xml /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/

ADD conf/run.conf /siga/jboss-eap-5.2/jboss-as/server/sigadoc/


#--- ARQUIVOS DE RECURSOS PARA ASSINATURA DIGITAL ---

ADD sigadoc_resource/ /home/resource/


ADD deploy/siga-ext-assinatura.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/siga-ext-assinatura.war


#-- jdbc tool ---
ADD apps/jdbctool-1.0.tar /siga
ADD lib/ojdbc6.jar /siga/jdbctool-1.0/lib/ojdbc6.jar


#-- Flyway ---
ADD apps/flyway-commandline-3.0.tar.gz /siga/

ADD lib/ojdbc6.jar /siga/flyway-3.0/jars/ojdbc6.jar
ADD conf/flyway/flyway.corporativo.properties /siga/flyway-3.0/conf/
ADD conf/flyway/flyway.siga.properties /siga/flyway-3.0/conf/
ADD conf/flyway/flyway.sigawf.properties /siga/flyway-3.0/conf/

CMD /siga/flyway-3.0/flyway -configFile=conf/flyway.corporativo.properties migrate
CMD /siga/flyway-3.0/flyway -configFile=conf/flyway.siga.properties migrate
CMD /siga/flyway-3.0/flyway -configFile=conf/flyway.sigawf.properties migrate

#--- inicializacao default
ADD scripts/inicializacao.sh /siga/
RUN chmod +x /siga/inicializacao.sh
CMD bash -c '/siga/inicializacao.sh'

#Portas expostas internamente
EXPOSE 8009

#--- variaveis ---

# --- flyway ---#
ENV flyway_run off

# --- db.server ---#
ENV db_server_name db.server

ENV db_server_check_user corporativo
ENV db_server_check_pass corporativo
ENV db_server_check_url jdbc:oracle:thin:@//db.server:1521/xe
ENV db_server_check_sql "SELECT SYSDATE FROM DUAL"

# --- email.server ---#
ENV email_server_name email.server


# --- app.server ---#
ENV app_server_name app.server


# --- web.server ---#
ENV web_server_name web.server

ENV web_server_check_url http://app.server:8080/siga

#--- APLICACÕES WEB AUXILIARES  ---
ADD apps/ckeditor.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/ckeditor.war

#--- APLICACÕES WEB (siga) ---
ADD deploy/siga.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/siga.war
ADD deploy/sigaex.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigaex.war
ADD deploy/sigacd.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigacd.war
ADD deploy/sigawf.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigawf.war
ADD deploy/sigagc.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigagc.war
ADD deploy/sigasr.war /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigasr.war
ADD deploy/siga-ext.jar /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/siga-ext.jar

#--- usuarios e grupos ---
RUN groupadd jboss
RUN adduser jboss -p jboss -g jboss
RUN chown -R jboss:jboss /siga
USER jboss


# -------------------------- Dockerfile (jboss) -------------------------- #
