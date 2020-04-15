#/bin/sh
echo "========================================================================="
echo "                            Check Database"
echo "========================================================================="
echo ""
set -x
#--- verifica conexao com db.server
pass=$db_server_check_pass

cd /siga/jdbcsql
cmd='java -jar jdbcsql-1.0.zip -m mysql -p 3306 -P '$pass' -U '$db_server_check_user' -d information_schema -h '$db_server_name' "SELECT CURRENT_TIMESTAMP"'

echo "Testando conexao com banco..."
echo "db_server_check_sql=$db_server_check_sql"
echo "db_server_check_user=$db_server_check_user"
echo "pass=$pass"
echo "db_server_name=$db_server_name"
echo "db_server_check_url=$db_server_check_url"
echo "cmd=$cmd"

cmd_ping='ping '$db_server_name' -c 3'
eval $cmd_ping

ok=1
until [ $ok = 0 ]
do
        eval $cmd
        ok=$?
        sleep 1
done

echo "========================================================================="
echo "                        Inicializa Banco de Dados"
echo "========================================================================="
echo ""

if [ "$init_db" == "on" ]
        then
        cd /siga/jdbcsql
        java -jar jdbcsql-1.0.zip -m mysql -p 3306 -P $pass -U $db_server_check_user -d information_schema -h $db_server_name "ALTER TABLE corporativo.cp_marca DROP FOREIGN KEY cp_marca_ibfk_5"
        java -jar jdbcsql-1.0.zip -m mysql -p 3306 -P $pass -U $db_server_check_user -d information_schema -h $db_server_name "DROP DATABASE IF EXISTS siga"
		java -jar jdbcsql-1.0.zip -m mysql -p 3306 -P $pass -U $db_server_check_user -d information_schema -h $db_server_name "DROP DATABASE IF EXISTS corporativo"
        java -jar jdbcsql-1.0.zip -m mysql -p 3306 -P $pass -U $db_server_check_user -d information_schema -h $db_server_name "DROP DATABASE IF EXISTS sigawf"
fi

echo "========================================================================="
echo "                            Flyway - Carga"
echo "========================================================================="
echo ""

if [ "$flyway_run" == "on" -o "$flyway_run" == "auto" ]
        then
                cd /
                sudo rm -rf /siga/flyway-3.0/siga-updates
                sudo mkdir /siga/flyway-3.0/siga-updates
                sudo mkdir /siga/flyway-3.0/sql
                sudo mkdir /siga/flyway-3.0/sql/corporativo
                sudo mkdir /siga/flyway-3.0/sql/siga
                sudo mkdir /siga/flyway-3.0/sql/sigawf
                #sudo mkdir /siga/flyway-3.0/sql/sigatp
                #sudo mkdir /siga/flyway-3.0/sql/sigasr
                #sudo mkdir /siga/flyway-3.0/sql/sigagc

                sudo unzip -j $JBOSS_HOME/standalone/deployments/siga.war WEB-INF/lib/siga-cp-1.2-SNAPSHOT.jar  -d /siga/flyway-3.0/siga-updates
                sudo unzip -j /siga/flyway-3.0/siga-updates/siga-cp-1.2-SNAPSHOT.jar db/mysql/* -d /siga/flyway-3.0/sql/corporativo/

                sudo unzip -j $JBOSS_HOME/standalone/deployments/sigaex.war WEB-INF/lib/siga-ex-1.2-SNAPSHOT.jar  -d /siga/flyway-3.0/siga-updates
                sudo unzip -j /siga/flyway-3.0/siga-updates/siga-ex-1.2-SNAPSHOT.jar db/mysql/* -d /siga/flyway-3.0/sql/siga/

                sudo unzip -j $JBOSS_HOME/standalone/deployments/sigawf.war WEB-INF/lib/siga-wf-1.2-SNAPSHOT.jar  -d /siga/flyway-3.0/siga-updates
                sudo unzip -j /siga/flyway-3.0/siga-updates/siga-wf-1.2-SNAPSHOT.jar db/mysql/* -d /siga/flyway-3.0/sql/sigawf/

                #sudo cp $JBOSS_HOME/standalone/deployments/sigatp.war/WEB-INF/lib/siga-tp-1.2-SNAPSHOT.jar/db/mysql/* /siga/flyway-3.0/sql/sigatp/
                #sudo cp $JBOSS_HOME/standalone/deployments/sigasr.war/WEB-INF/lib/siga-sr-1.2-SNAPSHOT.jar/db/mysql/* /siga/flyway-3.0/sql/sigasr/
                #sudo cp $JBOSS_HOME/standalone/deployments/sigagc.war/WEB-INF/lib/siga-gc-1.2-SNAPSHOT.jar/db/mysql/* /siga/flyway-3.0/sql/sigagc/

                sudo /siga/flyway-3.0/flyway -configFile=conf/flyway.corporativo.properties migrate
                sudo /siga/flyway-3.0/flyway -configFile=conf/flyway.siga.properties migrate
                sudo /siga/flyway-3.0/flyway -configFile=conf/flyway.sigawf.properties migrate
                #sudo /siga/flyway-3.0/flyway -configFile=conf/flyway.sigasr.properties migrate
                #sudo /siga/flyway-3.0/flyway -configFile=conf/flyway.sigagc.properties migrate
                #sudo /siga/flyway-3.0/flyway -configFile=conf/flyway.sigatp.properties migrate

                sudo rm -rf /siga/flyway-3.0/siga-updates/*

fi
