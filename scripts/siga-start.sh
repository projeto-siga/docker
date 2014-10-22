#!/bin/sh
docker run --name db.server -h db.server -d -p 49160:22 -p 49161:1521 -p 49162:8080 siga/db.server

docker  run --name app.server -h app.server -m=1g --link db.server:db.server -p 8080 -t -i --rm siga/app.server
