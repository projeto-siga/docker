# -------------------------- Dockerfile (apache) -------------------------- #

FROM centos:7.1.1503
MAINTAINER tssesia@jfrj.jus.br

# --- HTTPD ----

RUN yum -y install httpd
RUN yum -y install unzip

#-JDBC SQL
COPY apps/html.zip /var/www/

#--- ARQUIVOS DE CONFIGURA..O DO APACHE ---
ADD conf/sigadoc.conf  /etc/httpd/conf.d/

RUN mkdir /siga
RUN unzip /var/www/html.zip -d /var/www

#--- inicializacao default
ADD scripts/inicializacao.sh /siga/
RUN chmod +x /siga/inicializacao.sh
CMD bash -c '/siga/inicializacao.sh'

EXPOSE 80

# --- email.server ---#
ENV email_server_name email.server

# --- app.server ---#
ENV app_server_name app.server


# --- web.server ---#
ENV web_server_name web.server

ENV web_server_check_url http://app.server:8080/siga


# -------------------------- Dockerfile (apache) -------------------------- #
