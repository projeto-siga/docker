#!/bin/sh
echo "Iniciando db.server..."
docker run -d --name db.server -h db.server -p 49160:22 -p 49161:1521 -p 49162:8080 siga/db.server

echo "Iniciando email.server..."
docker run -d --name email.server -h email.server -p 49163:1080 -p 49164:25 previousnext/mailcatcher

echo "Iniciando app.server..."
docker run -d --name app.server -h app.server -m=1g --link db.server:db.server --link email.server:email.server -p 50000:8080 siga/app.server

echo "Iniciando web.server..."
docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server /usr/sbin/httpd -DFOREGROUND 

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
echo "STMP server (fake): 192.168.59.103 porta 49164"
echo "STMP server (fake): (visualizar emails): http://192.168.59.103:49163"

