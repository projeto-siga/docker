# -------------------------- Dockerfile (apache) -------------------------- #

FROM jetty:9.3.9-jre8
MAINTAINER tssesget@trf2.jus.br


#--- DEPLOY DO ARQUIVO .WAR ---
ADD deploy/blucservice.war /var/lib/jetty/webapps/ 

#--- DEPLOY DO REPOSITÓRIO DE CERTIFICADOS ---
ADD deploy/acrepo/ /var/lib/blucservice/acrepo/

EXPOSE 8080

# -------------------------- Dockerfile (blucservice) -------------------------- #