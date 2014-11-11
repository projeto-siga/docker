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

    sudo curl -O https://raw.githubusercontent.com/projeto-siga/docker/master/scripts/siga-start.sh
    
    sudo chmod +x siga-start.sh
    
    ./siga-start.sh
    
  
**d. Acesse o siga**

**Observações**

1. Se o terminal do docker estiver fechado dê dois cliques no ícone Boot2Docker Start na área de trabalho.
2. O download é demorado na primeira vez (+/- 5 GB)
3. Nas próximas execuções, basta executar ./siga-start.sh no terminal

