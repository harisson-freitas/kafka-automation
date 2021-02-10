#!/bin/bash

################################################################
# Author: Harisson Freitas∴
# E-mail: "harisson.freitas@zallpy.com"
# Criado em: 22/01/2021
################################################################

################################################################
# Processo de teste para envio de
# eventos/mensagens para um tópico no
# Kafka - Configurações.
################################################################

################################################################
# Definir às configurações.
# Local:
#   None
# Global:
#   COLOR_DEFAULT -> Cor Padrão
#   COLOR_OPTIONS -> Cor Cyan para os menus
#   COLOR_NUMBER  -> Cor Marrom(Laranja) para os números
#   COLOR_INVALID -> Cor Vermelha para opções inválidas/erros
#
#   COUNT -> Contador
#   IS_DOCKER -> S = Kafka e Zookeeper em execução com Docker
#                N = Kafka e Zookeeper em execução local
#
#   SCRIPT_KAFKA -> Script para listar, criar,
#                   excluir e carregar testes no Kakfa
#   SCRIPT_MENU -> Script para carregar o menu
#   SCRIPT_CONSUMER -> Executar os testes de consumo
#                      no Kafka
#   SCRIPT_PRODUCER -> Executar os testes de salvar
#                      no Kafka
#   SCRIPT_SEND -> Executar os testes de envio para o Kafka
#
#   SO -> Define o sistema operacional:
#        L/l -> Linux (Debian, Ubuntu, Mint, Kubuntu e fedora) 
#        W/w -> Windows
#
#   TOPIC -> Tópico do Kafka
#   BROKER -> Endereço do broker-Kafka
#   ZKS -> Endereço do Zookeeper
#   
#   PATH_DOCKER  -> Caminho do volume mapeado do docker 
#                  - externo 
#   PATH_DATA -> Caminho interno para acesso ao arquivo .json 
#                - volume mapeado do Docker interno
#   PATH_JSON -> Caminho onde está o arquivo .json para teste
#   PATH_MAIN -> Caminho onde está o script principal
#   PATH_KAFKA -> Caminho onde está o bin do Kafka
#   PATH_OUT -> Caminho dos arquivos de log gerados após o
#               consumo das mensagens
# Argumentos:
#   None
# Retorno:
#   None
#################################################################
config() {

    export COLOR_DEFAULT=$(echo "\033[m")
    export COLOR_OPTIONS=$(echo "\033[36m")
    export COLOR_NUMBER=$(echo "\033[33m")
    export COLOR_INVALID=$(echo "\033[01;31m")

    export COUNT=0
    export IS_DOCKER='S'

    export SCRIPT_KAFKA='./bin/kafka.sh'
    export SCRIPT_CONSUMER='./bin/consumer.sh'
    export SCRIPT_MENU='./bin/menu.sh'
    export SCRIPT_PRODUCER='./bin/producer.sh'
    export SCRIPT_SEND='./bin/send.sh'

    export TOPIC='arquitetura.local.carga.v1'
    export BROKER='localhost:9092'
    export ZKS='localhost:2181'

    if [[ $IS_DOCKER == 'N' ]]; then
        export PATH_MAIN="${HOME}/Documentos/ops/kafka-automation-us"
        export PATH_KAFKA="${HOME}/kafka"
        export PATH_JSON="${HOME}/Documentos/ops/testes/json"
        export PATH_OUT="${HOME}/Documentos/ops/testes"
   
    elif [[ $IS_DOCKER == 'S' ]]; then
        export PATH_MAIN="/home/harissonfreitas/Documentos/ops/kafka-automation-us"
        export PATH_DOCKER="/home/harissonfreitas/Documentos/ops/kafka-docker"
        export PATH_DATA="/ops/json"
        export PATH_JSON="${PATH_DOCKER}/json"
        export SO='L'
    
    else
        echo "Valor inválido..."
    fi
}

##################################################################
# Carregar à função para criar um tópico através do script
# './bin/kafka.sh' que está na variável $SCRIPT_KAFKA.
# Local:
#   None
# Global:
#   CONSUMER
#   CREATE
#   DELETE
#   PRODUCER
# Argumentos:
#   None
# Retorno:
#   None
##################################################################
create() {
    export CONSUMER='N'
    export CREATE='S'
    export DELETE='N'
    export PRODUCER='N'
    ${SCRIPT_KAFKA}
}

##################################################################
# Carregar à função para excluir um tópico através do script
# './bin/kafka.sh' que está na variável $SCRIPT_KAFKA.
# Local:
#   None
# Global:
#   CONSUMER
#   CREATE
#   DELETE
#   PRODUCER
# Argumentos:
#   None
# Retorno:
#   None
##################################################################
delete() {
    export CONSUMER='N'
    export CREATE='N'
    export DELETE='S'
    export PRODUCER='N'
    ${SCRIPT_KAFKA}
}

##################################################################
# Carregar à função para produzir e enviar uma mensagem para um
# tópico através do script './bin/kafka.sh' que está na variável
# $SCRIPT_KAFKA.
# Local:
#   None
# Global:
#   CONSUMER
#   CREATE
#   DELETE
#   PRODUCER
# Argumentos:
#   None
# Retorno:
#   None
##################################################################
producer_topic() {
    export CONSUMER='N'
    export CREATE='N'
    export DELETE='N'
    export PRODUCER='S'
    ${SCRIPT_KAFKA} $1 $2 $3
}

##################################################################
# Carregar à função para consumir uma mensagem de um tópico através
# do script './bin/kafka.sh' que está na variável $SCRIPT_KAFKA.
# Local:
#   None
# Global:
#   CONSUMER
#   CREATE
#   DELETE
#   PRODUCER
# Argumentos:
#   None
# Retorno:
#   None
##################################################################
consumer_topic() {
    export CREATE='N'
    export DELETE='N'
    export PRODUCER='N'
    export CONSUMER='S'
    ${SCRIPT_KAFKA}
}

##################################################################
# Carregar à função para criar e excluir tópicos, além de enviar e
# consumir mensagem para de um tópico através do script
# './bin/kafka.sh' que está na variável
# $SCRIPT_KAFKA.
# Local:
#   None
# Global:
#   CONSUMER
#   CREATE
#   DELETE
#   PRODUCER
#   VALIDATE_TOPIC
# Argumentos:
#   None
# Retorno:
#   None
##################################################################
all() {
    export CONSUMER='S'
    export CREATE='S'
    export DELETE='S'
    export PRODUCER='S'
    export VALIDATE_TOPIC='S'
    ${SCRIPT_MENU}
}

##################################################################
# Selecionar o tipo de função a ser carregada.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   $1 -> Tipo de operação
#   $2 -> Tipo de teste
#   $3 -> Unidade(tempo e quantidade)
#   $4 -> Arquivo .json ou mensagem
# Retorno:
#   None
##################################################################
select_operation() {
    if [[ -z $1 ]]; then
        all
    else
        case $1 in
        C)
            create
            ;;
        D)
            delete
            ;;
        PT)
            producer_topic $2 $3 $4
            ;;
        CT)
            consumer_topic
            ;;
        *) echo "Valor informado inválido!" ;;
        esac
    fi
}

##################################################################
# Carregar à função config() e executar o script './bin/kafka.sh'
# que está na variável $SCRIPT_KAFKA.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   $1 -> Tipo de operação
#   $2 -> Tipo de teste
#   $3 -> Unidade(tempo e quantidade)
#   $4 -> Arquivo .json ou mensagem
# Retorno:
#   None
##################################################################
main() {
    config
    select_operation $1 $2 $3 $4
}

#################################################################
# Carregar à função main().
# Argumento: 4
#################################################################
main $1 $2 $3 $4
