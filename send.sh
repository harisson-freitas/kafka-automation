#!/bin/bash

#############################################################
# Processo de teste para envio de 
# eventos/mensagens para um tópico no 
# Kafka - Produzir/enviar mensagem.
############################################################

###########################################################
# Válida se o arquivo é .json.
# Local:
#   _file -> Arquivo ou mensagem
#   _count_json -> Quantidade de elementos do arquivo .json
# Global:
#   None
# Argumentos:
#   $1 -> Arquivo ou mensagem
# Retorno:
#   Retorna a quantidade de elementos existente no array de
#   objetos.
###########################################################
validate_type() {
    cd $PATH_JSON
    _file=$1
    
    if [[ $_file == *.json ]]; then        
        _count_json=$(jq '.messages | length' $_file)
        echo ${_count_json} 
    fi 
}

###########################################################
# Realiza o envio de mensagens no formato json + contador
# Local:
#   _file_name -> Nome do arquivo .json 
#   _incremental -> Controle de incremento
#   _count_json -> Quantidades de elementos no arquivo .json
#   _type -> Tipo producer
# Global:
#   None
# Argumentos:
#   $1 -> Arquivo ou mensagem
#   $2 -> Controle de incremento
#   $3 -> Quantidade de elementos no arquivo .json
#   $4 -> Tipo producer
# Retorno:
#   Exibe às mensagens enviadas no console. 
###########################################################
producer_message_json() {
    cd $PATH_JSON
    _file_name=$1
    _incremental=$2
    _count_json=$3
    _type=$4

    if [[ $_incremental -lt $_count_json ]]; then
        _message=$(jq ".messages[$_incremental]" $_file_name \
        | tr '\r' ' ' | tr '\n' ' ' | sed 's/ \{3,\}//g' | sed 's/ //g')

        ${SCRIPT_PRODUCER} $_type $_message       
    fi    
}

###########################################################
# Enviar a mensagem dentro de um período de tempo.
# Local:
#   _time_begin -> Período inicial
#   _time_end -> Período final  
#   _count_json -> Quantidades de elementos no arquivo .json
#   _incremental -> Controle de incremento
# Global:
#   COUNT -> Contador
# Argumentos:
#   $1 -> Tempo em minutos
#   $2 -> Arquivo ou mensagem
# Retorno:
#   None
###########################################################
send_by_time() {
    _time_begin=$(date +%H:%M:%S)
    _time_end=$(date -d "+$1 min" "+%H:%M:%S")
    _count_json=$(validate_type $2)
    _incremental=0

    echo "Enviar por tempo:${1}" 
    echo "INICIO: ${_time_begin}"
    echo "FIM: ${_time_end}"

    while [[ $_time_begin < $_time_end ]]; do
        if [[ -z $_count_json ]]; then 
             cd $PATH_MAIN

            ${SCRIPT_PRODUCER} ST $2 
            echo "${2}, Contador: ${COUNT}"
        else 
            _incremental=$([[ $_incremental == $_count_json ]] \
            && echo 0 || echo $_incremental)
            
            producer_message_json $2 $_incremental $_count_json ST
            
            _incremental=$(expr ${_incremental} + 1)    
        fi    
        _time_begin=$(date +%H:%M)
        COUNT=$(expr ${COUNT} + 1)
    done
}

##############################################################
# Enviar a mensagem com uma quantidade de iterações definidas.
# Local:
#   _quantity -> Quantidade de iterações 
#   _count_json -> Quantidades de elementos no arquivo .json
#   _incremental -> Controle de incremento
# Global:
#   COUNT -> Contador
# Argumentos:
#   $1 -> Quantidade de execuções
#   $2 -> Arquivo ou mensagem
# Retorno:
#   None
###############################################################
send_by_quantity() {
    _quantity=$1
    _count_json=$(validate_type $2)
    _incremental=0
        
    echo "Enviar por quantidade:${_quantity}"
 
    while [[ $COUNT -lt $_quantity ]]; do
        if [[ -z $_count_json ]]; then 
            cd $PATH_MAIN

            ${SCRIPT_PRODUCER} SQ $2 
            echo "${2}, Contador: ${COUNT}"
        else
            _incremental=$([[ $_incremental == $_count_json ]] \
            && echo 0 || echo $_incremental)
            
            producer_message_json $2 $_incremental $_count_json SQ
            
            _incremental=$(expr ${_incremental} + 1)    
        fi    
        COUNT=$(expr $COUNT + 1)
    done
}

##############################################################
# Enviar a mensagem através de um arquivo .json
# Local:
#   _count_json -> Quantidades de elementos no arquivo .json
# Global:
#   None
# Argumentos:
#   $1 -> Nome do arquivo .json
# Retorno:
#   Se o arquivo não for .json ou estiver vázio irá retornar uma 
#   mensagem criticando a ação.
###############################################################
send_by_json() {
    _count_json=$(validate_type $1)
    echo "Enviar por arquivo.json:${1}"
    
    if [[ -z $_count_json ]]; then 
        echo "Arquivo não é .json ou está vázio!"
        echo "Operação inválida..."
        echo ""
    else 
        for (( i=0; i < $_count_json; i++))
        do  
            cd $PATH_JSON 

            jq ".messages[$i]" $1 | tr '\r' ' ' | tr '\n' ' ' | \
            sed 's/ \{3,\}//g' | sed 's/ //g' > data.json



            _message=$(jq . data.json)
            mv data.json $PATH_KAFKA

            ${SCRIPT_PRODUCER} SJ  
        done
    fi
}

################################################################
# Enviar a mensagem com uma quantidade de iterações definidas.
# Local:
#   None 
# Global:
#   None
# Argumentos:
#   $1 -> Quantidade de iterações
# Retorno:
#   None
################################################################
send_by_seq() {
    echo "Enviar com incremento:${1}"
    cd $PATH_MAIN
    ${SCRIPT_PRODUCER} SS $1
}

################################################################
# Carregar o tipo de teste a ser executado.
# Local:
#   _type_test -> Tipo de teste 
# Global:
#   None
# Argumentos:
#   $1 -> Tipo de teste: 
#         [SJ - send_by_json];
#         [SQ - send_by_quantity]; 
#         [SS - send_by_seq].
#         [ST - send_by_time];
#   $2 -> Dependendo do teste, pode ser:
#         [SJ - arquivi .json];
#         [SQ - quantidade];
#         [SS - iterações];
#         [ST - tempo];
#   $3 -> Conteúdo da mensagem para os 
#         testes por tempo e quantidade;  
# Retorno:
#   None
##################################################################
data_load() {
    if [[ $IS_DOCKER == 'N' ]]; then 
        cd ${PATH_KAFKA}
    fi 
    
    _type_test=$1
    
    case $_type_test in
        ST) send_by_time $2 $3
        ;;
        SQ) send_by_quantity $2 $3
        ;;
        SS) send_by_seq $2
        ;;
        SJ) send_by_json $2
        ;; 
        *)  echo "Opção inválida..."  
    esac
}

###################################################################
# Carregar à função data_load().
# Argumento: 3
###################################################################
data_load $1 $2 $3
