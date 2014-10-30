#/bin/sh

#--- verifica conexao com app.server
app_server_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' app.server)

cmd='ok=$(curl -w "%{http_code}" -o /dev/null -L -s   http://$app_server_ip:8080/siga)'

echo "Testando conexao com app.server..."
ok=1
until [ $ok = 200 ]
do
        eval $cmd
        ok=$resp
        sleep 1
done

service httpd start

