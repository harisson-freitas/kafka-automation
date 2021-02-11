# Kafka Automation Test

<p>Ferramenta para criar, produzir, consumir e excluir eventos e tópicos do Kafka.
</p>

## Configurações
- [Pré-requisitos](#Pré-requisitos)
- [Ambiente](#Configuração-Ambiente) 
- [Linux](#Configuração-Linux)
- [Windows](#Configuração-Windows)

## Utilização
- Local(Linux)
- Docker(Linux/Windows)
- Ambiente de TST

## Pré-requisitos
 - [**_build-essential(Make)_**](#Instalando-Build-Essential)
 - [**_jq_**](#Instalando-jq)
 - [**_docker_**(Obrigatório para Windows)](#Instalando-Docker)

<br/>OBS: Para às instalações e configurações acima, se estiver utilizando o **_Windows_** deve-se cofigurar o Bash Shell de alguma das
<br/>distribuições de **_Linux_** homologadas.   

## Instalando Build Essential
 O build-essential é necessário para que tenhamos como executar o comando **_make_**(GNU Make) referente ao arquivo **_Makefile_**;
 <br/>Abra seu **_terminal(Linux Bash Shell no Windows)_**, e execute o seguinte comando:`sudo apt-get install build-essential`;
 <br/>Para verificar se instalou com sucesso, basta executar: `make --version` e deverá ter uma saída igual à:<br/> 

```
GNU Make 4.2.1
Compilado para x86_64-pc-linux-gnu
Copyright (C) 1988-2016 Free Software Foundation, Inc.
Licença GPLv3+: GNU GPL versão 3 ou posterior <http://gnu.org/licenses/gpl.html>
Isto é um aplicativo livre: você pode alterá-lo e redistribui-lo livremente.
NÃO HÁ GARANTIAS, exceto o que for permitido por lei.
```

## Instalando jq
O jq é um processador JSON de linha de comando leve e flexível, sendo como sed para dados JSON,você pode usá-lo para cortar,
<br/>filtrar, mapear e transformar dados estruturados com a mesma facilidade que sed, awk, grep.
<br/>Abra seu **_terminal(Linux Bash Shell no Windows)_**, e execute o seguinte comando:`sudo apt-get install jq`;
<br/>Para verificar se instalou com sucesso, basta executar: `jq --version` e deverá ter uma saída igual à:`jq-1.6`

## Instalando Docker
Docker é uma plataforma de código aberto, desenvolvido na linguagem Go e criada pelo próprio Docker.Inc. 
<br/>Por ser de alto desempenho, o software garante maior facilidade na criação e administração de ambientes isolados, 
<br/>garantindo a rápida disponibilização de programas para o usuário final.
<br/> Processo de instalação [aqui](#https://docs.docker.com/engine/install/)

## Configuração Ambiente
Antes de executar os testes, é necessário realizar às seguintes configurações:
   - Executar o comando `make config` para dar às permissões para tornar os scripts executáveis;
   - Abrir o arquivo **_bin/main.sh_** para configurar às varáveis abaixo:
     -  Gerais: <br/>
        
        | Nome                        | Descrição                                                           | Exemplo                                           |          
        |:-------------               | :-------------                                                      | :-------------:                                   |
        | IS_DOCKER                   | Define se o server do Kafka está em execução em um container Docker | S(Docker), N(Local)                               |
        | TOPIC                       | Tópico do Kafka                                                     | arquitetura.local.v1                              |
        | BROKER                      | Endereço do broker Kafka                                            | localhost:9092                                    |
        | ZKS                         | Endereço do zookeeper                                               | localhost:2181                                    |
        | PATH_MAIN                   | Caminho principal do projeto                                        | ${HOME}/kafka-automation                          |
        | PATH_JSON                   | Caminho onde está o arquivo .json para teste                        | ${HOME}/testes/json                               |
        
     - Local - Sem Docker(Apenas para Linux):<br/>
       
        | Nome                        | Descrição                                                           | Exemplo                                           |          
        |:-------------               | :-------------                                                      | :-------------:                                   |
        | PATH_KAFKA                  | Caminho onde está o diretório bin do Kafka                          | ${HOME}/kafka                                     |
        | PATH_OUT                    | Caminho onde são gerado os arquivos de saída(log)                   | ${PATH_MAIN}/out                                  |
     
     - Docker(Linux/Windows):<br/>  
       
        | Nome                        | Descrição                                                           | Exemplo                                           |          
        |:-------------               | :-------------                                                      | :-------------:                                   |
        | PATH_DOCKER                 | Caminho do volume mapeado do docker - externo                       | ${HOME}/kafka-docker                              |
        | PATH_DATA                   | Caminho docker para acesso ao arquivo .json - interno               | /ops/json                                         |
        | SO                          | Define o sistema operacional                                        |  L/l(Linux) ou W/w(Windows)                       |
    
## Configuração Linux
Basicamente no linux, foram homologados às seguindes distribuições:
- Ubuntu 16.+
- Kubuntu 16.+
- Mint 16.+
- Fedora 28.+(_A partir do fedora 32 há uma serie de conflitos com a engine do docker, sendo priorizado o uso do **podman**, 
  <br/> nesse caso oriento a não subir o server do Kafka através do docker_).<br/>

No Linux podemos tanto executar o server do Kafka localmente, quando dentro de um container docker. Porém ao optar pelo uso do **_DOCKER_**,
<br/>teremos que realizar à seguinte configuração:<br/>
- Ter o [docker](#Instalando-Docker) e docker-compose(opcional) instalados;
- Permissão para poder executar o comandos como root dentro do container:
  - Execute em seu terminal o comando `sudo visudo`;
  - Adicione o path do projeto kafka-automation na variável _**secure_path**_, no meu caso o meu path é<br/> 
    **_/home/harissonfreitas/kafka-automation_**:
    ```
    #
    # This file MUST be edited with the 'visudo' command as root.
    #
    # Please consider adding local content in /etc/sudoers.d/ instead of
    # directly modifying this file.
    #
    # See the man page for details on how to write a sudoers file.
    #
    Defaults        env_reset
    Defaults        mail_badpass
    Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/home/harissonfreitas/kafka-automation"

    # Host alias specification

    # User alias specification

    # Cmnd alias specification

    # User privilege specification
    root    ALL=(ALL:ALL) ALL

    # Members of the admin group may gain root privileges
    %admin ALL=(ALL) ALL

    # Allow members of group sudo to execute any command
    %sudo   ALL=(ALL:ALL) ALL

    # See sudoers(5) for more information on "#include" directives:

    #includedir /etc/sudoers.d
    ```
Para ambos(**_Local/Docker_**), realiza-se à seguinte configuração:
- Ter instalado o [**_build essential_**](#Instalando-Build-Essential);
- Ter instalado o [**_jq_**](#Instalando-jq);  
- Dar permissão e tornar os scripts executáveis:
   - Através do terminal, acessar o diretório do projeto e executar o comando: `make config`;
    <br/> Basicamente será executado um `chmod +x bin/*.sh` permitndo que os arquivos .sh
    <br/> sejam executáveis.

## Configuração Windows
Basicamente no Windows o server do Kafka foi executado em um container docker, e homologado na seguinte versão:
- Windows 10 <br/>

Para realizar o processo de configuração no Windows, precisamos basicamente:
- Instalar o [WSL/WSL2](#https://docs.microsoft.com/pt-br/windows/wsl/install-win10) depende do build da versão do Windows
  <br/> e instalando um bash de acordo com às versões homologadas para Linux;
- Ter o [docker](#Instalando-Docker) instalado;
- Ter instalado o [**_build essential_**](#Instalando-Build-Essential);
- Ter instalado o [**_jq_**](#Instalando-jq);   
- Dar permissão e tornar os scripts executáveis:
    - Através do terminal, acessar o diretório do projeto e executar o comando: `make config`;
      <br/> Basicamente será executado um `chmod +x bin/*.sh` permitndo que os arquivos .sh
      <br/> sejam executáveis.
