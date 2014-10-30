#!/bin/sh
echo "Iniciando db.server..."
docker run -d --name db.server -h db.server -p 49160:22 -p 49161:1521 -p 49162:8080 siga/db.server

echo "Iniciando email.server..."
docker run -d --name email.server -h email.server -p 49163:1080 -p 49164:25 previousnext/mailcatcher

echo "Iniciando app.server..."
docker run -d --name app.server -h app.server -m=1g --link db.server:db.server --link email.server:email.server -p 50000:8080 siga/app.server

echo "Iniciando web.server..."
docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server

echo "OK!"
