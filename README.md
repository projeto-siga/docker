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

**c. Execute os seguintes comando no terminal do docker**

    sudo curl -O https://raw.githubusercontent.com/projeto-siga/docker/master/src/main/resources/scripts/siga-start.sh
    
    sudo chmod +x siga-start.sh
    
    ./siga-start.sh
    
  
**d. Acesse o siga**

**Observações**

1. Se o terminal do docker estiver fechado dê dois cliques no ícone Boot2Docker Start na área de trabalho.
2. O download é demorado na primeira vez (+/- 5 GB)
3. Nas próximas execuções, basta executar ./siga-start.sh no terminal

Experimente o SIGA no Linux
=============================
**a. Instale o docker no seu sistema operacional 64-bits**

  https://docs.docker.com/installation
  
**b. Execute os seguintes comando no terminal do docker**

    sudo curl -O https://raw.githubusercontent.com/projeto-siga/docker/master/src/main/resources/scripts/siga-start.sh
    
    sudo chmod +x siga-start.sh
    
    ./siga-start.sh
  
**c. Acesse o siga**  

**Observações**

1. Se o terminal do docker estiver fechado dê dois cliques no ícone Boot2Docker Start na área de trabalho.
2. O download é demorado na primeira vez (+/- 5 GB)
3. Nas próximas execuções, basta executar ./siga-start.sh no terminal


Usando o SIGA com seu banco de dados e servidor de e-mail
=========================================================

Para utilizar o siga com seu banco de dados Oracle e seu servidor de e-mail siga os passos abaixo.

**a. Instale o docker no seu sistema operacional 64-bits**

  https://docs.docker.com/installation
  
**b. Personalize os arquivos de configuração**

  Faça o download e altere os seguintes arquivos com os dados do seu ambiente:
  
  1. [siga.properties](https://raw.githubusercontent.com/projeto-siga/docker/master/ctxs/jboss/conf/siga.properties)
  2. [oracle-ds.xml](https://raw.githubusercontent.com/projeto-siga/docker/master/ctxs/jboss/conf/oracle-ds.xml)
   
**c. Disponibilize os arquivos de configuração**

  1. Copie os arquivos de configuração para o diretório /siga/siga-downloads
  2. Execute os seguites comandos:
   
* ```docker run --name jboss-conf-ds -v /siga/siga-downloads/oracle-ds.xml:/siga/jboss-eap-5.2/jboss-as/server/sigadoc/deploy/oracle-ds.xml busybox true```

* ```docker run --name jboss-conf-siga-prop -v /siga/siga-downloads/siga.properties:/siga/jboss-eap-5.2/jboss-as/server/sigadoc/conf/siga.properties busybox true```
 
**d. Inicie o servidor de aplicação**

Execute o seguinte comando

* ```docker run --name app.server -h app.server -p 8080:8080 -m=1g --dns=[seu_DNS] --dns-search=[seu_dominio_DNS] --volumes-from jboss-conf-ds --volumes-from jboss-conf-siga-prop -e db_server_name=[nome_do_servidor_BD] -e -e db_server_check_url=jdbc:oracle:thin:@//[nome_do_servidor_bd]:[porta_bd]/[instancia_bd] -t -i --rm siga/app.server[:versao_siga]```


Alterando os seguintes parâmetros:

```--dns=[seu_dns]``` - informe o DNS que será utilizado para o servidor de aplicações. Ex: ```--dns=10.0.2.3```

```--dns-search=[seu_dominio_dns]``` - informe o domínio do seu DNS. Ex: ```--dns-search=corp.jfrj.gov.br```

```-e db_server_name=[nome_do_servidor_bd]``` - Informe o nome de rede da máquina com o Oracle instalado. Ex: ```-e db_server_name=servidor_oracle```

```-e db_server_check_url=jdbc:oracle:thin:@//[nome_do_servidor_bd]:[porta_bd]/[instancia_bd]``` - Informe a string de conexão via jdbc para o banco de dados. Ex: ```-e db_server_check_url=jdbc:oracle:thin:@//servidor_oracle:1521/DESENV```

```siga/app.server[:versao_siga]``` - Informe o número da versão do siga a ser executada (versões docker são listadas [aqui](https://registry.hub.docker.com/u/siga/app.server/tags/manage/))

**e. Inicie o servidor web**

Execute o seguinte comando

* ```docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server /usr/sbin/httpd -DFOREGROUND```




  
