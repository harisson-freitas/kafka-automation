#!/bin/bash

################################################################
# Author: Harisson Freitas∴
# E-mail: "harisson.freitas@zallpy.com"
# Criado em: 22/01/2021
################################################################

#############################################################
# Processo de teste para produzir os
# eventos/mensagens em um tópico no
# Kafka - Produzir/enviar mensagem.
############################################################

###########################################################
# Acessar o diretório padrão do Kafka.
# Local:
#    None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
############################################################
access_kafka() {
    if [[ $IS_DOCKER == 'N' ]]; then
        cd ${PATH_KAFKA}
    fi
}

###########################################################
# Acessar o diretório onde estão os arquivos .json.
# Local:
#    None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
############################################################
access_json() {
    if [[ -z $PATH_JSON ]]; then
        echo "Não há caminho configurado para arquivos .json"
    else
        cd ${PATH_JSON}
    fi
}
###########################################################
# Verificar se o kafka está em execução dentro
# de um container ou não através da variável $IS_DOCKER,
# e executa o comando para produzir/enviar a mensagem.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
kafka_producer() {
    if [[ $IS_DOCKER == 'N' ]]; then
        bash -c "echo '${1}, {\"Contador\": \"${COUNT}\"}' | bin/kafka-console-producer.sh \
        --broker-list ${BROKER} --topic ${TOPIC} $1"
        echo "${1}, Contador: ${COUNT}"
    elif [[ $IS_DOCKER == 'S' ]]; then
        docker exec kafka \
            bash -c "echo '${1}, Contador: ${COUNT}' | kafka-console-producer \
        --broker-list ${BROKER} --topic ${TOPIC} $1"
        echo "${1}, Contador: ${COUNT}"
    else
        echo "Parâmetro ${IS_DOCKER} inválido!"
    fi

    echo ""
}

###############################################################
# Verificar se o kafka está em execução dentro
# de um container ou não através da variável $IS_DOCKER,
# e executa o comando para produzir/enviar mensagem de forma
# iterativa.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
################################################################
kafka_producer_seq() {
    if [[ $IS_DOCKER == 'N' ]]; then
        bash -c "seq $1 | bin/kafka-console-producer.sh \
        --broker-list ${BROKER} --topic ${TOPIC} \
        && echo 'Envio de ${1} mensagem(ns)'"
    elif [[ $IS_DOCKER == 'S' ]]; then
        docker exec kafka \
            bash -c "seq $1 | kafka-console-producer \
        --broker-list ${BROKER} --topic ${TOPIC} \
        && echo 'Envio de ${1} mensagem(ns)'"
    else
        echo "Parâmetro ${IS_DOCKER} inválido!"
    fi

    echo ""
}

###########################################################
# Verificar se o kafka está em execução dentro
# de um container ou não através da variável $IS_DOCKER,
# e executa o comando para produzir/enviar a mensagem usando
# um arquivo .json.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
kafka_producer_json() {
    if [[ $IS_DOCKER == 'N' ]]; then
        bash -c "bin/kafka-console-producer.sh \
        --broker-list ${BROKER} --topic ${TOPIC} < data.json"
        echo $(jq . data.json)
    elif [[ $IS_DOCKER == 'S' ]]; then
        access_json
        
        docker exec kafka \
            bash -c "kafka-console-producer \
        --broker-list ${BROKER} --topic ${TOPIC} < ${PATH_DATA}/data.json"
        echo $(jq . data.json)
    else
        echo "Parâmetro ${IS_DOCKER} inválido!"
    fi

    bash -c "rm -rfv data.json"
    echo ""
}

################################################################
# Carregar o tipo de producer
# Local:
#   _type_test -> Tipo de teste
# Global:
#   None
# Argumentos:
#   $1 -> Tipo de teste:
#         [SJ - kafka_producer_json];
#         [SQ - kafka_producer];
#         [SS - kafka_producer_seq].
#         [ST - kafka_producer];
#   $2 -> Valor da mensagem a ser produzida.
# Retorno:
#   None
##################################################################
producer_load() {
    access_kafka

    _type_test=$1

    case $_type_test in
    ST)
        kafka_producer $2
        ;;
    SQ)
        kafka_producer $2
        ;;
    SS)
        kafka_producer_seq $2
        ;;
    SJ)
        kafka_producer_json
        ;;
    *)
        echo "Opção inválida..."
        ;;
    esac
}

###################################################################
# Carregar à função producer_load().
# Argumento: 2
###################################################################
producer_load $1 $2
