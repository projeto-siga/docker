#/bin/sh

#--- verifica conexao com db.server
pass=$db_server_check_pass

cd /siga/jdbctool-1.0
cmd='echo $db_server_check_sql | java -cp jdbctool.jar:lib/java-getopt-1.0.13.jar:lib/libreadline-java-0.8.0.jar:lib/ojdbc6.jar  com.quuxo.jdbctool.JdbcTool -u $db_server_check_user -p $pass $db_server_check_url > /dev/null'

echo "Testando conexao com banco..."
echo "db_server_check_sql=$db_server_check_sql"
echo "db_server_check_user=$db_server_check_user"
echo "pass=$pass"
echo "db_server_name=$db_server_name"
echo "db_server_check_url=$db_server_check_url"
echo "cmd=$cmd"

#--- inicializa banco de dados ---
if [ "$init_db" == "on" ]
	then
	cmd_jdbctool=' | java -cp jdbctool.jar:lib/java-getopt-1.0.13.jar:lib/libreadline-java-0.8.0.jar:lib/ojdbc6.jar  com.quuxo.jdbctool.JdbcTool -u system -p oracle $db_server_check_url > /dev/null'
	cmd_1='echo ALTER USER SYSTEM IDENTIFIED BY oracle'
	cmd_2='echo CREATE USER corporativo IDENTIFIED BY corporativo default tablespace USERS'
	cmd_3='echo CREATE USER siga IDENTIFIED BY siga default tablespace USERS'
	cmd_4='echo CREATE USER sigawf IDENTIFIED BY sigawf default tablespace USERS'
	cmd_5='echo GRANT CONNECT,RESOURCE TO SIGA'
	cmd_6='echo GRANT CONNECT,RESOURCE TO SIGAWF'
	cmd_7='echo GRANT CONNECT,RESOURCE TO CORPORATIVO'
	eval $cmd_1$cmd_jdbctool
	eval $cmd_2$cmd_jdbctool
	eval $cmd_3$cmd_jdbctool
	eval $cmd_4$cmd_jdbctool
	eval $cmd_5$cmd_jdbctool
	eval $cmd_6$cmd_jdbctool
	eval $cmd_7$cmd_jdbctool
fi

ok=1
until [ $ok = 0 ]
do
        eval $cmd
        ok=$?
        sleep 1
done

#--- atualiza banco de dados ---
if [ "$flyway_run" == "on" -o "$flyway_run" == "auto" ]
	then
		cd /
		rm -rf /siga/flyway-3.0/siga-updates
		mkdir /siga/flyway-3.0/siga-updates

		unzip -j /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/siga.war WEB-INF/lib/siga-cp-0.0.1-SNAPSHOT.jar -d /siga/flyway-3.0/siga-updates
		unzip  /siga/flyway-3.0/siga-updates/siga-cp-0.0.1-SNAPSHOT.jar db/migration/* -d /siga/flyway-3.0/sql/corporativo/

		unzip -j /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigaex.war WEB-INF/lib/siga-ex-0.0.1-SNAPSHOT.jar -d /siga/flyway-3.0/siga-updates
		unzip  /siga/flyway-3.0/siga-updates/siga-ex-0.0.1-SNAPSHOT.jar db/migration/* -d /siga/flyway-3.0/sql/siga/

		unzip -j /siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/sigawf.war WEB-INF/lib/siga-wf-0.0.1-SNAPSHOT.jar -d /siga/flyway-3.0/siga-updates
		unzip  /siga/flyway-3.0/siga-updates/siga-wf-0.0.1-SNAPSHOT.jar db/migration/* -d /siga/flyway-3.0/sql/sigawf/

		/siga/flyway-3.0/flyway -configFile=conf/flyway.corporativo.properties migrate
		/siga/flyway-3.0/flyway -configFile=conf/flyway.siga.properties migrate
		/siga/flyway-3.0/flyway -configFile=conf/flyway.sigawf.properties migrate

		rm /siga/flyway-3.0/siga-updates/*
	
fi

if [ "$flyway_run" == "off" -o "$flyway_run" == "auto" ]
	then
		/siga/jboss-eap-5.2/jboss-as/bin/run.sh -b 0.0.0.0 -c sigadoc
fi