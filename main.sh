#!/bin/bash

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
#   COUNT -> Contador 
#   IS_DOCKER -> S = Kafka e Zookeeper em execução com Docker
#                N = Kafka e Zookeeper em execução local 
#   PATH_MAIN -> Caminho onde está o script principal
#   PATH_KAFKA -> Caminho onde está o bin do Kafka
#   SCRIPT -> Script para listar, criar,
#             excluir e carregar testes no Kakfa
#   SCRIPT_MENU -> Script para carregar o menu 
#   SCRIPT_PRODUCER -> Executar os testes de envio 
#                      no Kafka
#   SCRIPT_CONSUMER -> Executar os testes de consumo 
#                      no Kafka
#   TOPIC -> Tópico do Kafka
#   BROKER -> Endereço do broker-Kafka
#   ZKS -> Endereço do Zookeeper 
# Argumentos:
#   None
# Retorno:
#   None
#################################################################
config() {
    echo "******CONFIGURAÇÃO LOCAL******"

    export COLOR_DEFAULT=`echo "\033[m"`
    export COLOR_OPTIONS=`echo "\033[36m"`
    export COLOR_NUMBER=`echo "\033[33m"`
    export COLOR_INVALID=`echo "\033[01;31m"` 

    export COUNT=0
    export IS_DOCKER='N' 
    
    export SCRIPT_KAFKA='./bin/kafka.sh'
    export SCRIPT_CONSUMER='./bin/consumer.sh'
    export SCRIPT_MENU='./bin/menu.sh' 
    export SCRIPT_PRODUCER='./bin/producer.sh'
    export SCRIPT_SEND='./bin/send.sh'

    export TOPIC='arquitetura.local.carga.v1'
    export BROKER='localhost:9092'
    export ZKS='localhost:2181'
    export PATH_MAIN=`pwd`
    export PATH_KAFKA=${HOME}/kafka
    export PATH_JSON=$(echo `pwd` | sed 's/\/bin//')
}

create() {
    export CREATE='S'
    export DELETE='N'
    export PRODUCER='N'
    export CONSUMER='N'
    ${SCRIPT_KAFKA}
}

delete() {
    export CREATE='N'
    export DELETE='S'
    export PRODUCER='N'
    export CONSUMER='N'
    ${SCRIPT_KAFKA}
}

producer_topic() {
    export CREATE='N'
    export DELETE='N'
    export PRODUCER='S'
    export CONSUMER='N'
    ${SCRIPT_KAFKA}
}

consumer_topic() {
    export CREATE='N'
    export DELETE='N'
    export PRODUCER='N'
    export CONSUMER='S'
    ${SCRIPT_KAFKA}
}

all() {
    export CREATE='S'
    export DELETE='S'
    export PRODUCER='S'
    export CONSUMER='S'
    ${SCRIPT_MENU}
}

select_operation() {
    if [[ -z $1 ]]; then
        all
    else 
        case $1 in 
            C) create 
            ;;
            D) delete 
            ;;
            PT) producer_topic $2 $3 $4 
            ;;
            CT) consumer_topic 
            ;;
            *) echo "Valor informado inválido!"
        esac
    fi
}

##################################################################
# Carregar à função config() e executar
# o script './load_kafka.sh' que está na 
# variável $SCRIPT.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None 
##################################################################
main() {
    config
    select_operation $1 $2 $3 $4
}

#################################################################
# Carregar à função main().
#################################################################
main $1 $2 $3 $4