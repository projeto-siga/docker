#!/bin/sh
echo "Iniciando mysql.server..."
docker run --name mysql.server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=siga -d mysql:5.7.29

#echo "Iniciando email.server..."
docker run -d --name email.server -h email.server -p 49163:1080 -p 49164:25 schickling/mailcatcher

echo "Iniciando viz.server..."
docker run -d --name viz.server -h viz.server -p 49165:8080 omerio/graphviz-server 8080

echo "Iniciando bluc.server..."
docker run -d --name bluc.server -h bluc.server -p 50010:8080 siga/bluc.server

echo "Iniciando app.server..."
docker run -d --name app.server -h app.server -m=2g --link mysql.server:mysql.server --link bluc.server:bluc.server --link viz.server:viz.server -e init_db=on -e flyway_run=auto -p 50000:8080 -p 9990:9990 -t -i siga/app.mysql.server

echo "Iniciando web.server..."
docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server  

echo "Containers inicializados!"
echo ""
echo ""
echo "Dentro de 3 minutos acesse (substitua pelo seu endereco do docker):"
echo ""
echo "http://<<endereço do docker>>/siga"
echo ""
echo ""
echo ""
echo "**** Outras informações ****"
echo ""
echo "----- Para acompanhar os logs dos containers ----"
echo ""
echo "docker logs -f mysql.server"
echo "docker logs -f app.server"
echo "docker logs -f web.server"
echo "docker logs -f email.server"
echo "docker logs -f viz.server"
echo ""
echo ""
echo ""
echo "----- Portas e enderecos (substitua pelo seu endereco do docker) ----"
echo "Mysql (conexao bd): jdbc:mysql@<<endereço do docker>>:3306/<<nome do banco>>"
echo "Mysql (via ssh): docker exec -ti mysql.server bash"
echo ""
echo "JBOSS (siga bypass apache): http://<<endereço do docker>>:50000/siga"
echo "JBOSS (web admin): http://<<endereço do docker>>:8080"
echo ""
echo "Apache: http://<<endereço do docker>>"
echo ""
echo "GraphViz server: curl -X POST -d 'digraph G { a -> b -> c; a-> c; b -> d; c-> d; }' http://<<endereço do docker>>:49165/svg"
echo ""
echo "STMP server (fake): <<endereço do docker>> porta 49164"
echo "STMP server (fake): (visualizar emails): http://<<endereço do docker>>:49163"

