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
**a. Instale o docker no seu sistema operacional 64-bits** ([Veja o vídeo da instalação no Centos7](https://drive.google.com/file/d/0B_WTuFAmL6ZEUXhIU3dDODNLWWs/view?usp=sharing))

  https://docs.docker.com/installation
  
**b. Execute os seguintes comando no terminal do docker** ([Veja o vídeo da instalação](https://drive.google.com/file/d/0B_WTuFAmL6ZEdXNDaDYyR2FLX3c/view?usp=sharing))

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
  
  1. [standalone.xml](https://raw.githubusercontent.com/projeto-siga/docker/master/src/main/resources/ctxs/jboss/conf/jboss/standalone.xml)

**c. Disponibilize os arquivos de configuração**

  1. Execute o procedimento para [disponibilizar os arquivos](https://github.com/projeto-siga/docker/wiki/Configurando-o-SIGA-em-seu-ambiente-(jboss6-com-docker)) configurados para seu ambiente
  2. Faça a pré-configuração do volume (você pode usar -v na linha de comando e omitir esse passo se não usar o --volumes-from no próximo comando ):
   
* ```docker run --name jboss-conf -v /siga_conf/standalone.xml:/opt/jboss-eap-6.2/sigadoc/configuration/standalone.xml busybox true```

**d. Inicie o servidor de aplicação**

Execute o seguinte comando

* ```docker run --name app.server -h app.server -p 8080:8080 -m=1g --dns=[seu_DNS] --dns-search=[seu_dominio_DNS] --volumes-from jboss-conf --volumes-from jboss-conf-siga-prop -e db_server_name=[nome_do_servidor_BD] -e  db_server_check_url=jdbc:oracle:thin:@//[nome_do_servidor_bd]:[porta_bd]/[instancia_bd] -e db_server_check_user=[usuario_check] -e db_server_check_pass=[senha_usuario_check] -t -i --rm siga/app.server[:versao_siga]```


Alterando os seguintes parâmetros:

```--dns=[seu_dns]``` - informe o DNS que será utilizado para o servidor de aplicações. Ex: ```--dns=10.0.2.3```

```--dns-search=[seu_dominio_dns]``` - informe o domínio do seu DNS. Ex: ```--dns-search=corp.jfrj.gov.br```

```-e db_server_name=[nome_do_servidor_bd]``` - Informe o nome de rede da máquina com o Oracle instalado. Ex: ```-e db_server_name=servidor_oracle```

```-e db_server_check_url=jdbc:oracle:thin:@//[nome_do_servidor_bd]:[porta_bd]/[instancia_bd]``` - Informe a string de conexão via jdbc para o banco de dados. Ex: ```-e db_server_check_url=jdbc:oracle:thin:@//servidor_oracle:1521/DESENV```

```siga/app.server[:versao_siga]``` - Informe o número da versão do siga a ser executada (versões docker são listadas [aqui](https://registry.hub.docker.com/u/siga/app.server/tags/manage/))

```-e db_server_check_user=[usuario_check]``` - Informe o nome do usuário utilizado para testar se banco de dados estar no ar (UP). Ex: ```-e db_server_check_user=system```

```-e db_server_check_pass=[senha_usuario_check]``` - Informe a senha do usuário utilizado para testar se banco de dados estar no ar (UP). Ex: ```-e db_server_check_pass=oracle```

**e. Inicie o servidor web**

Execute o seguinte comando

* ```docker run -d --name web.server -h web.server -p 80:80 --link app.server:app.server siga/web.server /usr/sbin/httpd -DFOREGROUND```
