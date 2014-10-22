#/bin/sh
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

/siga/jboss-eap-5.2/jboss-as/bin/run.sh -b 0.0.0.0 -c sigadoc
