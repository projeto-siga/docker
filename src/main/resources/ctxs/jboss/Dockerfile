# -------------------------- Dockerfile (jboss) -------------------------- #

FROM centos:7.1.1503
MAINTAINER tssesia@jfrj.jus.br

#--- UTILITARIOS ---
RUN yum -y install unzip
RUN yum -y install tar
RUN yum -y install curl

# Cria estruturas de diretorios
RUN  mkdir -p /opt/jboss-eap-6.2/welcome-content/ckeditor/        \
  && mkdir -p /home/resource/               \
  && mkdir -p /opt/jboss-eap-6.2/modules/   \
  && mkdir -p /siga/jdbctool-1.0/           \
  && mkdir -p /siga

# Adiciona JDK homologada com aplicaÃ§Ã£o SIGA
ADD    apps/jdk-7u71-linux-x64.rpm /tmp/jdk-7u71-linux-x64.rpm

# Adiciona pacote initscripts para uso pelo script de inicializaÃ§Ã£o do JBoss
ADD    apps/initscripts-9.49.24-1.el7.x86_64.rpm /tmp/initscripts-9.49.24-1.el7.x86_64.rpm

# Adiciona software JBoss EAP 6.2 sem deploys
COPY    apps/jboss-eap-6.2.tar.gz /opt/jboss-eap-6.2/jboss-eap-6.2.tar.gz

COPY    apps/jboss-eap-6.2.3-patch.zip /opt/jboss-eap-6.2/jboss-eap-6.2.3-patch.zip


COPY    scripts/patchapply.sh /opt/jboss-eap-6.2/

# Adiciona recursos adicionais utilizados pela aplicacao Siga
ADD    apps/home_resource.tar.gz /home/resource/

# Adiciona recursos adicionais utilizados pela aplicacao Siga
ADD    apps/fop.tar.gz /home/jboss/

#Arquivos relacionados ao JBOSS EAP 6.2 para o sistema SIGA
ADD    apps/initd_sigadoc.tar.gz  /opt/jboss-eap-6.2/bin/init.d/
COPY    apps/modulos-siga.tar.gz  /opt/jboss-eap-6.2/modules/modulos-siga.tar.gz

#-- jdbc tool ---
COPY    apps/jdbctool-1.0.tar.gz  /siga/jdbctool-1.0/jdbctool-1.0.tar.gz

#-- Flyway ---
COPY    apps/flyway-commandline-3.0.tar.gz  /siga/flyway-commandline-3.0.tar.gz


ADD    apps/jboss-eap-6.2-sigadoc.tar.gz /opt/jboss-eap-6.2/sigadoc
COPY   conf/jboss/standalone.xml  /opt/jboss-eap-6.2/sigadoc/configuration/standalone.xml


# Instala Oracle JVM 7 update 71 e pacote initscripts
RUN     rpm -ivh --nodeps /tmp/initscripts-9.49.24-1.el7.x86_64.rpm     \
        && rm -f /tmp/initscripts-9.49.24-1.el7.x86_64.rpm              \
        && rpm -ivh /tmp/jdk-7u71-linux-x64.rpm                         \
        && rm -f /tmp/jdk-7u71-linux-x64.rpm


#-- Definicao do Random ---
COPY conf/java/java.security /usr/java/default/jre/lib/security/

# Atualiza pacotes US_export_policy.jar e local_policy.jar em JDK 7u71
ADD     apps/jdk-7u71-trf-addons.tar.gz /

# Acrescenta o ckeditor
ADD     apps/ckeditor_4.5.7_full.zip /siga/
RUN     unzip /siga/ckeditor_4.5.7_full.zip -d /opt/jboss-eap-6.2/welcome-content/ckeditor/

# Cria usuÃ¡rio jboss para execuÃ§Ã£o do JBoss EAP
RUN     groupadd -g 52677 jboss                                         \
        && useradd -m -u 52677 -g jboss -c "JBoss EAP Admin User" jboss \
        && ln -s /opt/jboss-eap-6.2 /opt/jboss                          \
        && mkdir -p /var/log/jboss/sigadoc                              \
        && mkdir -p /siga	 					\
        && mkdir -p /opt/jboss/sigadoc/deployments                      \
        && chown -R jboss:jboss /home/jboss/                            \
	&& chown -R jboss:root /siga/				        \
        && chown -R jboss:jboss /home/resource/                         \
        && chown -R jboss:jboss /opt/jboss-eap-6.2                      \
        && chown -R jboss:jboss /var/log/jboss                          \
        && chmod -R 775 /var/log/jboss                                  \
        && chmod +x /opt/jboss/bin/init.d/sigadoc.sh


#Aplicacao de Pacht do JBOSS EAP 6.3


#ADD deploy/siga-ext-assinatura.war /opt/jboss/sigadoc/deployments/siga-ext-assinatura.war

# -- Instalacao jdbctool --
COPY lib/ojdbc6.jar /siga/jdbctool-1.0/lib/ojdbc6.jar

# -- Instalacao flyway --
COPY lib/ojdbc6.jar /siga/flyway-3.0/jars/ojdbc6.jar
COPY conf/flyway/flyway.corporativo.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.siga.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigawf.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigasr.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigagc.properties /siga/flyway-3.0/conf/
COPY conf/flyway/flyway.sigatp.properties /siga/flyway-3.0/conf/

#--- inicializacao default e aplicacao de patch do JBOSS
RUN tar -xzf /opt/jboss-eap-6.2/jboss-eap-6.2.tar.gz  -C /opt/jboss-eap-6.2/
RUN unzip /opt/jboss-eap-6.2/jboss-eap-6.2.3-patch.zip -d /opt/jboss-eap-6.2/
RUN tar -xzf /opt/jboss-eap-6.2/modules/modulos-siga.tar.gz -C /opt/jboss-eap-6.2/modules/
RUN tar -xzf /siga/jdbctool-1.0/jdbctool-1.0.tar.gz -C /siga/jdbctool-1.0/
RUN tar -xzf /siga/flyway-commandline-3.0.tar.gz -C /siga/

RUN chmod +x /opt/jboss-eap-6.2/patchapply.sh
RUN /opt/jboss-eap-6.2/patchapply.sh
ADD scripts/inicializacao.sh /siga/
RUN chmod +x /siga/inicializacao.sh
CMD bash -c '/siga/inicializacao.sh'

#Portas expostas internamente
EXPOSE 8009

#--- variaveis ---

# --- flyway ---#
#-- init_db:
#-- on ou off - cria usuarios corporativo,siga,sigawf,etc. (off para ambiente de producao)
ENV init_db off

#-- flyway_run: on/auto ou off - executa atualizacao automatica do flyway   (off para ambiente de producao)
ENV flyway_run off

# --- db.server ---#
ENV db_server_name db.server

#-- conexao para testar se o banco de dados está rodando (UP)
ENV db_server_check_user system
ENV db_server_check_pass oracle
ENV db_server_check_url jdbc:oracle:thin:@//db.server:1521/xe
ENV db_server_check_sql "SELECT SYSDATE FROM DUAL"

# --- email.server ---#
ENV email_server_name email.server


# --- app.server ---#
ENV app_server_name app.server


# --- web.server ---#
ENV web_server_name web.server

ENV web_server_check_url http://app.server:8080/siga

#--- APLICACÕES WEB (siga) ---
ADD deploy/* /opt/jboss/sigadoc/deployments/

# --- modules ---
COPY deploy/siga-ext.jar /opt/jboss-eap-6.2/modules/sigadoc/ext/main/siga-ext.jar
COPY lib/siga-ext-busca-textual-1.1.jar /opt/jboss-eap-6.2/modules/sigadoc/ext/main/siga-ext-busca-textual-1.1.jar

#ENTRYPOINT      ["/siga/inicializacao.sh"]

# -------------------------- Dockerfile (jboss) -------------------------- #
