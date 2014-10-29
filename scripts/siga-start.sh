#!/bin/sh
echo "Iniciando db.server..."
docker run --name db.server -h db.server -d -p 49160:22 -p 49161:1521 -p 49162:8080 siga/db.server

echo "Iniciando app.server..."
docker run --name app.server -h app.server -m=1g --link db.server:db.server -p 50000:8080 -t -i --rm siga/app.server

echo "Iniciando web.server..."
docker run -d -t --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server

echo "OK!"
