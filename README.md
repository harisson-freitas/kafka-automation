# Kafka Automation Test

<p>Ferramenta para criar, produzir, consumir e excluir eventos e tópicos do Kafka.
</p>

## Configurações
- [Pré-requisitos](#Pré-requisitos)
- Ambiente 
- Linux
- Windows

## Pré-requisitos
 - [**_build-essential(Make)_**](#Instalando Build Essential)
 - [**_jq_**](#Instalando jq)
 - [**_docker_**(Obrigatório para Windows)](#Instalando Docker)

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
<br/> Processo de instalação: https://docs.docker.com/engine/install/

## Configuração Ambiente
Antes de executar os testes, é necessário realizar às seguintes configurações:
   - Executar o comando `make config` para dar às permissões para tornar os scripts executáveis;
   - Abrir o arquivo bin/main.sh para configurar às varáveis abaixo:
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
    
Os ambientes(SO) linux que forma homologados:
- Ubuntu 16.+
- Kubuntu 16.+
- Mint 16.+
- Fedora 28.+
## Utilização
- Local(Linux)
- Docker(Linux/Windows)
- Ambiente de TST
