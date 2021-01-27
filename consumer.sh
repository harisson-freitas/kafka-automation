#!/bin/bash

#############################################################
# Processo de teste para envio de 
# eventos/mensagens para um tópico no 
# Kafka - Consumir mensagem.
############################################################

###########################################################
# Criar o diretório "out" e o arquivo contendo às mensagens 
# consumidas do tópico, executando o kafka e o zookeeper 
# localmente.
# Local:
#   _path_log -> Caminho do diretório
#   _name_file -> Nome do arquivo
# Global:
#   None
# Argumentos:
#   $1 -> Caminho do diretório
#   $2 -> Nome do arquivo
# Retorno:
#   None
###########################################################
create_file_local() {
    _path_log=$1
    _name_file=$2
    
    if [[ ! -d "$_path_log" ]]; then     
        mkdir -p ${_path_log}     
    fi 

    echo "******Arquivo de mensagens******" > ${_name_file}
    echo ${_name_file}
}

###########################################################
# Criar o diretório "out" e o arquivo contendo às mensagens 
# consumidas do tópico, executando o kafka e o zookeeper 
# em um container Docker.
# Local:
#   _path_log -> Caminho do diretório
#   _name_file -> Nome do arquivo
# Global:
#   None
# Argumentos:
#   $1 -> Caminho do diretório
#   $2 -> Nome do arquivo
# Retorno:
#   None
###########################################################
create_file_docker() {
    _path_log=$1
    _name_file=$2
    
    docker exec kafka bash -c "if [[ ! -d  out ]]; then mkdir ${_path_log}; fi"
    docker exec kafka bash -c "echo '******Arquivo de mensagens******' > ${_name_file}"
    echo ${_name_file}
}

###########################################################
# Criar a estrutura de diretótio e arquivo(s ) para 
# armazenar às mensagens consumidos do tópico.
# Local:
#   _date_time -> Data e hora atual
#   _path_log -> Caminho do diretório
#   _name_file -> Nome do arquivo
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   Retorna o nome do arquivo criado.
###########################################################
create_file() {
    _date_time=$(date +%Y%m%d_%H%M%S)
    _path_log=$([[ $IS_DOCKER == 'N' ]] && echo "${PATH_MAIN}/out" || echo "out")
    _name_file="${_path_log}/consumer_${_date_time}.log"
    
    if [[ $IS_DOCKER == 'N' ]]; then 
        create_file_local $_path_log $_name_file
    else 
        create_file_docker $_path_log $_name_file
    fi
}

###########################################################
# Verificar se o kafka está em execução dentro
# de um container ou não através da variável $IS_DOCKER, 
# e executa a função para consumir à(s) mensagem(ns).
# Local:
#   None 
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
kafka_consumer() {
    if [[ $IS_DOCKER == 'N' ]]; then
        consumer_local
    elif [[ $IS_DOCKER == 'S' ]]; then    
        consumer_in_docker
    else 
        echo "Parâmetro ${IS_DOCKER} inválido!"
    fi
}

###########################################################
# Executar o comando para consumir mensagens e gravar no 
# arquivo;
# Finalizar o PID referento ao consumo de mensagens.
# Local:
#   _name -> Nome do arquivo
#   _pid_kafka -> Id do processo de consumo de mensagens 
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
consumer_local() {
    _name=$(create_file)
    echo "Arquivo: $_name"

    bin/kafka-console-consumer.sh --bootstrap-server ${BROKER} \
    --from-beginning --topic ${TOPIC} >> ${_name} &
    sleep 3

    _pid_kafka=$!
    echo "PID KAFKA:$_pid_kafka"
    echo ""
    
    echo "Finalizando PID kafka: $_pid_kafka"
    sleep 3
    kill -9 $_pid_kafka    
}

###########################################################
# Executar o comando para consumir mensagens e gravar no 
# arquivo dentro do Docker;
# Finalizar o PID referento a execução do bash -c para o Docker;
# Finalizar o PID referente ao consumo das mensagens.
# Local:
#   _name -> Nome do arquivo
#   _pid_docker -> Id do processo do bash -c para o Docker
#   _pid_kafka -> Id do processo de consumo de mensagens  
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
###########################################################
consumer_in_docker() {
    _name=$(create_file)
    echo "Arquivo: $_name"
    
    docker exec kafka bash -c "kafka-console-consumer --bootstrap-server ${BROKER} --from-beginning --topic ${TOPIC} >> ${_name}" &
    sleep 2

    _pid_docker=$!
    _pid_kafka=$(ps -ef | grep ${TOPIC} | awk '{print $2 $8 $10} ' | grep java | sed 's/[^0-9]*//g' \
    && ps -ef | grep ${TOPIC} | awk '{print $2 $8 $10} ' | grep kafka-console-consumer | sed 's/[^0-9]*//g') 

    echo "PID_DOCKER:$_pid_docker"
    echo "PID KAFKA:$_pid_kafka" 
        
    echo ""
    echo "Finalizando PID docker: $_pid_docker"
    sleep 5
    kill -9 $_pid_docker
        
    echo "Finalizando PID kafka: $_pid_kafka"
    sleep 5
    kill -9 $_pid_kafka
}

###########################################################
# Carregar a lista de mensagens e gravar no arquivo de log.
# Local:
#   _list_messages -> Lista(valor) das mensagens
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   Salvar às mensagens no arquivo de log.
###########################################################
data_load() {
    if [[ $IS_DOCKER == 'N' ]]; then 
        cd ${PATH_KAFKA}
    fi 

    echo "Buscar mensagens"
    kafka_consumer
}

###################################################################
# Carregar à função data_load().
###################################################################
data_load
