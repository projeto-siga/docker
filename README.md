docker
======

Repositório Docker para o SIGA

Experimente o SIGA no Windows
=============================

Este texto explica como executar os servidores do SIGA no Windows para fins de teste. Para outras plataformas veja: https://docs.docker.com/installation/#installation.

**a. Faça o download do Docker**

* Baixe o instalador em https://github.com/boot2docker/windows-installer/releases/latest

**b. Instale o Docker**

* Execute o arquivo docker-install.exe

  **Observações**
  
  1. É recomendável remover o Virtual Box se ele já estiver instalado em sua máquina;
  2. Após a instalação do Docker, é necessário aumentar a memória da máquina virtual boot2docker-vm 
    3. dê dois cliques no ícone Boot2Docker Start (aparecerá um terminal);
    4. abra o Oracle Virtual Box;
    5. clique com o botão direito em boot2docker-vm e depois em Fechar/Desligar;
    6. clique com o botão direito em boot2docker-vm, e depois  em Configurações/Sistema;
    7. aumente a memória base de 2048MB para 4096MB;
    8. clique em OK;
    9. feche o Oracle Virtual Box;

**c. Execute o seguinte comando no terminal do docker**

    sudo curl -O https://raw.githubusercontent.com/projeto-siga/docker/master/src/main/resources/scripts/siga-start.sh && sudo chmod +x siga-start.sh && sudo ./siga-start.sh
    
  
**d. Acesse o siga**

  - Será necessário aguardar alguns minutos até que o JBoss tenha concluído o startup e o Siga esteja disponível  
  - O acesso para testes é feito usando o login ZZ99999 e a senha Password1

**Observações**

1. Se o terminal do docker estiver fechado dê dois cliques no ícone Boot2Docker Start na área de trabalho.
2. O download é demorado na primeira vez (+/- 5 GB)
3. Nas próximas execuções, basta executar ./siga-start.sh no terminal

Experimente o SIGA no Linux
=============================
**a. Instale o docker no seu sistema operacional 64-bits** ([Veja o vídeo da instalação no Centos7](https://drive.google.com/file/d/0B_WTuFAmL6ZEUXhIU3dDODNLWWs/view?usp=sharing))

  https://docs.docker.com/installation
  
**b. Execute o seguinte comando no terminal do docker** ([Veja o vídeo da instalação](https://drive.google.com/file/d/0B_WTuFAmL6ZEdXNDaDYyR2FLX3c/view?usp=sharing))

    sudo curl -O https://raw.githubusercontent.com/projeto-siga/docker/master/src/main/resources/scripts/siga-start.sh && sudo chmod +x siga-start.sh && sudo ./siga-start.sh
  
**c. Acesse o siga**  

  - Será necessário aguardar alguns minutos até que o JBoss tenha concluído o startup e o Siga esteja disponível  
  - O acesso para testes é feito usando o login ZZ99999 e a senha Password1

**Observações**

1. Se o terminal do docker estiver fechado dê dois cliques no ícone Boot2Docker Start na área de trabalho.
2. O download é demorado na primeira vez (+/- 5 GB)
3. Nas próximas execuções, basta executar ./siga-start.sh no terminal

Usando o SIGA com seu servidor de e-mail
========================================

Para utilizar o siga com seu servidor de e-mail siga os passos abaixo.

**a. Instale o docker no seu sistema operacional 64-bits**

  https://docs.docker.com/installation
  
**b. Personalize os arquivos de configuração**

  Faça o download e altere os seguintes arquivos com os dados do seu ambiente:
  
  1. [standalone.xml](https://raw.githubusercontent.com/projeto-siga/docker/mysql/src/main/resources/ctxs/jboss/conf/jboss/standalone.xml)
  
  As propriedades que configuram o servidor de e-mail são:
  
```
<property name="servidor.smtp" value="email.server"/>
<property name="servidor.smtp.porta" value="1025"/>
<property name="servidor.smtp.auth" value="true"/>
<property name="servidor.smtp.auth.usuario" value="siga"/>
<property name="servidor.smtp.auth.senha" value="siga"/>
<property name="servidor.smtp.debug" value="false"/>
<property name="servidor.smtp.usuario.remetente" value="Administrador do Siga&lt;sigadocs@jfrj.jus.br>"/>
```

**c. Disponibilize os arquivos de configuração**

  1. Execute o procedimento para [disponibilizar os arquivos](https://github.com/projeto-siga/docker/wiki/Configurando-o-SIGA-em-seu-ambiente-(jboss6-com-docker)) configurados para seu ambiente

**d. Inicie o servidor de aplicação**

Execute o seguinte comando

* ```docker run --name app.server -h app.server -p 8080:8080 -m=2g --dns=[seu_DNS] --dns-search=[seu_dominio_DNS] -v /[caminho]/standalone.xml::/home/jboss/jboss-eap-7.2/standalone/configuration/standalone.xml -t -i --rm siga/app.mysql.server[:versao_siga]```


Alterando os seguintes parâmetros:

```--dns=[seu_dns]``` - informe o DNS que será utilizado para o servidor de aplicações. Ex: ```--dns=10.0.2.3```

```--dns-search=[seu_dominio_dns]``` - informe o domínio do seu DNS. Ex: ```--dns-search=corp.jfrj.gov.br```

```siga/app.mysql.server[:versao_siga]``` - Informe o número da versão do siga a ser executada (versões docker são listadas [aqui](https://registry.hub.docker.com/u/siga/app.mysql.server/tags/manage/))

**e. Inicie o servidor web**

Execute o seguinte comando

* ```docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server /usr/sbin/httpd -DFOREGROUND```


Usando o SIGA com seu servidor de banco de dados MySQL/MariaDB
==============================================================

Para utilizar o siga com seu banco de dados MySQL/MariaDB siga os passos abaixo.

**a. Instale o docker no seu sistema operacional 64-bits**

  https://docs.docker.com/installation
  
**b. Personalize os arquivos de configuração**

  Faça o download e altere os seguintes arquivos com os dados do seu ambiente:
  
  1. [standalone.xml](https://raw.githubusercontent.com/projeto-siga/docker/mysql/src/main/resources/ctxs/jboss72.mysql/conf/jboss/standalone.xml)
  
  Você deve procurar no arquivo standalone.xml one estão as configurações dos datasources, e as propriedades que configuram o servidor de banco de dados são:
  
  
```
<datasource jndi-name="java:/jboss/datasources/SigaCpDS" pool-name="SigaCpDS" enabled="true">
                <connection-url>jdbc:mysql://mysql.server:3306/corporativo?useSSL=false&amp;noAccessToProcedureBodies=true</connection-url>
                    <driver-class>com.mysql.jdbc.Driver</driver-class>
                    <driver>mysql.jar</driver>
                    <pool>
                        <min-pool-size>1</min-pool-size>
                        <max-pool-size>4</max-pool-size>
                    </pool>
                    <security>
                        <user-name>root</user-name>
                        <password>siga</password>
                    </security>
                    <timeout>
                        <idle-timeout-minutes>5</idle-timeout-minutes>
                    </timeout>
                </datasource>
```

  Os parâmetros que devem ser alterados são:

  - connection-url deve-se colocar o nome do servidor de banco de dados;
  - user-name deve-se colocar o usuário do sistema;
  - password deve-se colocar a senha do usuário.

  Ao fazer isso é necessário que os arquivos de criação do flyway também sejam alterados, caso contrário não será feito a carga inicial, e para isso serão necessários seguir os seguintes passos:

  1. [flyway.corporativo.properties](https://raw.githubusercontent.com/projeto-siga/docker/mysql/src/main/resources/ctxs/jboss72.mysql/conf/flyway/flyway.corporativo.properties)

```
flyway.driver=com.mysql.jdbc.Driver
flyway.url=jdbc:mysql://mysql.server:3306/information_schema?useSSL=false&characterEncoding=UTF-8&useUnicode=true
flyway.user=root
flyway.password=siga
flyway.schemas=corporativo
flyway.sqlMigrationPrefix=CORPORATIVO_UTF8_V
flyway.placeholderPrefix=flyway${
flyway.validateOnMigrate=false
```

  Os parâmetros que devem ser alterados são:
  
  - flyway.url, deve substituir o mysql.server pelo seu servidor de banco de dados;
  - flyway.user, deve substituir pelo usuário do banco de dados;
  - flyway.password, deve substituir pela senha do usuário do banco de dados.
  
  Você deve fazer isso para todos os bancos do SIGADOC, atualmente são o CORPORATIVO e o Siga
  
**c. Disponibilize os arquivos de configuração**

  1. Execute o procedimento para [disponibilizar os arquivos](https://github.com/projeto-siga/docker/wiki/Configurando-o-SIGA-em-seu-ambiente-(jboss6-com-docker)) configurados para seu ambiente

**d. Inicie o servidor de aplicação**

Execute o seguinte comando


* ```docker run --name app.server -h app.server -p 8080:8080 -m=2g --dns=[seu_DNS] --dns-search=[seu_dominio_DNS] -v /[caminho]/standalone.xml:/home/jboss/jboss-eap-7.2/standalone/configuration/standalone.xml -v /[caminho]/flyway.siga.properties:/siga/flyway-3.0/conf/flyway.siga.properties -v /[caminho]/flyway.corporativo.properties:/siga/flyway-3.0/conf/flyway.corporativo.properties -t -i --rm siga/app.mysql.server[:versao_siga]```


Alterando os seguintes parâmetros:

```--dns=[seu_dns]``` - informe o DNS que será utilizado para o servidor de aplicações. Ex: ```--dns=10.0.2.3```

```--dns-search=[seu_dominio_dns]``` - informe o domínio do seu DNS. Ex: ```--dns-search=corp.jfrj.gov.br```

**e. Inicie o servidor web**

Execute o seguinte comando

* ```docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server /usr/sbin/httpd -DFOREGROUND```
