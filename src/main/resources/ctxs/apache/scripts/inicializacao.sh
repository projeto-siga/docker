
#/bin/sh

#--- verifica conexao com app.server
cmd='resp=$(curl -w "%{http_code}" -o /dev/null -L -s   $web_server_check_url)'

echo "Testando conexao com app.server..."
ok=1
until [ $ok = 200 ]
do
        eval $cmd
        ok=$resp
        sleep 1
done

echo "Conexao OK!"
/usr/sbin/httpd -DFOREGROUND



