#!/bin/bash

################################################################
# Author: Harisson Freitas∴
# E-mail: "harisson.freitas@zallpy.com"
# Criado em: 22/01/2021
################################################################

############################################################
# Processo de teste para envio de
# eventos/mensagens para um tópico no
# Kafka - Listar, criar e excluir tópico,
# e carregar script para postar mensagens
# no tópico.
############################################################

###########################################################
# Acessar o diretório principal do projeto.
# Local:
#    None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
############################################################
access_main() {
    cd ${PATH_MAIN}
}

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
# Listar tópicos.
# Local:
#    None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   Lista de tópicos se existirem, ou nulo
#   se não houver nenhum tópico criado.
############################################################
list_topic() {
    [[ $IS_DOCKER == 'N' ]] &&
        bash -c "bin/kafka-topics.sh --zookeeper ${ZKS} --list" ||
        docker exec zookeeper bash -c "kafka-topics --zookeeper ${ZKS} --list"
}

############################################################
# Verificar se o tópico já existe, se existir realiza a
# exclusão.
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
has_topic() {
    echo "*******VERIFICAÇÃO DE TÓPICO******"
    delete_topic
    echo "*******FIM VERIFICAÇÃO*******"
    echo ""
}

###########################################################
# Criar tópico.
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
create_topic() {
    echo "*******CRIAÇÃO DE TÓPICO******"
    echo "Data criação:$(date)"

    if [[ $IS_DOCKER == 'N' ]]; then
        bash -c "bin/kafka-topics.sh --create --zookeeper ${ZKS} \
        --replication-factor 1 --partitions 1 --topic ${TOPIC}"
    elif [[ $IS_DOCKER == 'S' ]]; then
        docker exec zookeeper bash -c "kafka-topics --create --zookeeper ${ZKS} \
        --replication-factor 1 --partitions 1 --topic ${TOPIC}"
    fi

    echo "*******FIM CRIAÇÃO*******"
    echo ""
}

##############################################################
# Excluir tópico.
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
##############################################################
delete() {
    if [[ $IS_DOCKER == 'N' ]]; then
        bash -c "bin/kafka-topics.sh \
        --zookeeper ${ZKS} --delete --topic ${TOPIC}"
    elif [[ $IS_DOCKER == 'S' ]]; then
        docker exec zookeeper \
            bash -c "kafka-topics --zookeeper ${ZKS} \
        --delete --topic ${TOPIC}"
    fi
}

##############################################################
# Validar exclusão de tópico através.
# Local:
#   _list -> Lista de tópicos
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
##############################################################
delete_topic() {
    _list=$(list_topic)

    for i in $_list; do
        if [[ $i == $TOPIC ]]; then
            echo ""
            echo "*******EXCLUSÃO DE TÓPICO******"
            echo "Data exclusão:$(date)"
            echo "Excluir: ${i}"
            delete
            echo "*******FIM EXCLUSÃO*******"
            echo ""
        fi
    done
}

################################################################
# Enviar mensagem para o tópico através da variável
# $SCRIPT_PRODUCER;
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   $1 -> Tipo de teste:
#         [ST - send_by_time];
#         [SQ - send_by_quantity];
#         [SS - send_by_seq];
#         [SJ - send_by_json].
#   $2 -> Dependendo do teste, pode ser:
#         [ST - tempo];
#         [SQ - quantidade];
#         [SS - iterações].
#   $3 -> Conteúdo do arquivo .json ou mensagem para os
#         testes por tempo e quantidade;
# Retorno:
#   None
##################################################################
send() {
    access_main

    echo "*******CARGA/ENVIO DE MENSAGENS: TOPICOS KAFKA********"

    ${SCRIPT_SEND} $1 $2 $3
    echo "*******FIM CARGA*******"
    echo ""

    access_kafka
}

################################################################
# Consumir mensagem(ns) fo tópico através da variável
# $SCRIPT_CONSUMER;
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   None
# Retorno:
#   None
##################################################################
consume() {
    access_main

    echo "*******CONSUMO DE MENSAGENS: TOPICOS KAFKA********"
    ${SCRIPT_CONSUMER}
    echo "*******FIM CONSUMO*******"

    access_kafka
}

###################################################################
# Carregar às funções create_topic(), consume(), send() e
# delete_topic().
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   $1 -> Tipo de teste
#   $2 -> Unidade(tempo e quantidade)
#   $3 -> Arquivo .json ou mensagem
# Retorno:
#   None
###################################################################
load() {
    if [[ $VALIDATE_TOPIC == 'S' ]]; then
        has_topic
    fi

    [[ $CREATE == 'S' ]] && create_topic || echo "Criar tópico desabilitado!"
    [[ $PRODUCER == 'S' ]] && send $1 $2 $3 || echo "Produzir mensagem desabilitado!"
    [[ $CONSUMER == 'S' ]] && consume || echo "Consumir mensagem desabilitado!"
    [[ $DELETE == 'S' ]] && delete_topic || echo "Excluir tópico desabilitado!"
}

###################################################################
# Carregar às funções access_kafka(), has_topic() e load().
# Local:
#   None
# Globais:
#   None
# Argumentos:
#   $1 -> Tipo de teste
#   $2 -> Unidade(tempo e quantidade)
#   $3 -> Arquivo .json ou mensagem
# Retorno:
#   None
####################################################################
main() {
    clear
    access_kafka
    load $1 $2 $3
}

####################################################################
# Carregar à função main().
# Argumento: 3
####################################################################
main $1 $2 $3
