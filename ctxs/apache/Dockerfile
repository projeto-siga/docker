# -------------------------- Dockerfile (apache) -------------------------- #

FROM centos:centos6
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

# -------------------------- Dockerfile (apache) -------------------------- #