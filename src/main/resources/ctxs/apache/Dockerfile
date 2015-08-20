# -------------------------- Dockerfile (apache) -------------------------- #

FROM centos:7.1.1503
MAINTAINER tssesia@jfrj.jus.br

# --- HTTPD ----

RUN yum -y install httpd


#--- ARQUIVOS DE CONFIGURA..O DO APACHE ---
ADD conf/sigadoc.conf  /etc/httpd/conf.d/

RUN mkdir /siga

#--- inicializacao default
ADD scripts/inicializacao.sh /siga/
RUN chmod +x /siga/inicializacao.sh
CMD bash -c '/siga/inicializacao.sh'

EXPOSE 80

#--- variaveis ---

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


# -------------------------- Dockerfile (apache) -------------------------- #