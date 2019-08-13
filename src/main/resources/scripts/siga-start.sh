#!/bin/sh
echo "Iniciando db.server..."
docker run -d --name db.server -h db.server -p 49160:22 -p 49161:1521 -p 49162:8080 christophesurmont/oracle-xe-11g

echo "Iniciando email.server..."
docker run -d --name email.server -h email.server -p 49163:1080 -p 49164:25 schickling/mailcatcher

echo "Iniciando viz.server..."
docker run -d --name viz.server -h viz.server -p 49165:8080 omerio/graphviz-server 8080

echo "Iniciando bluc.server..."
docker run -d --name bluc.server -h bluc.server -p 50010:8080 siga/bluc.server

echo "Iniciando app.server..."
docker run -d --name app.server -h app.server -m=2g --link db.server:db.server --link email.server:email.server --link bluc.server:bluc.server --link viz.server:viz.server -e init_db=on -e flyway_run=auto -p 50000:8080 -p 9990:9990 siga/app.server

echo "Iniciando web.server..."
docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server  

echo "Containers inicializados!"
echo ""
echo ""
echo "Dentro de 3 minutos acesse (substitua pelo seu endereco do docker):"
echo ""
echo "http://192.168.59.103/siga"
echo ""
echo ""
echo ""
echo "**** Outras informações ****"
echo ""
echo "----- Para acompanhar os logs dos containers ----"
echo ""
echo "docker logs -f db.server"
echo "docker logs -f app.server"
echo "docker logs -f web.server"
echo "docker logs -f email.server"
echo "docker logs -f viz.server"
echo ""
echo ""
echo ""
echo "----- Portas e enderecos (substitua pelo seu endereco do docker) ----"
echo "Oracle (conexao bd): jdbc:oracle:thin:@192.168.59.103:49161:xe"
echo "Oracle (via ssh): 192.168.59.103:22"
echo "Oracle (via web admin): 192.168.59.103:49162"
echo ""
echo "JBOSS (siga bypass apache): http://192.168.59.103:50000/siga"
echo "JBOSS (web admin): http://192.168.59.103:8080"
echo ""
echo "Apache: http://192.168.59.103"
echo ""
echo "GraphViz server: curl -X POST -d 'digraph G { a -> b -> c; a-> c; b -> d; c-> d; }' http://192.168.59.103:49165/svg"
echo ""
echo "STMP server (fake): 192.168.59.103 porta 49164"
echo "STMP server (fake): (visualizar emails): http://192.168.59.103:49163"

