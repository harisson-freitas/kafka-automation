#!/bin/bash

################################################################
# Author: Harisson Freitas∴
# E-mail: "harisson.freitas@zallpy.com"
# Criado em: 06/02/2021
################################################################

###########################################################
# Buscar o(s) processo(s) do kafka_consumer dentro do container
# em execução no Windows
# Local:
#   TOPIC -> Nome do tópico
# Global:
#   None
# Argumentos:
#   $1 -> Nome do tópico
# Retorno:
#   O(s) processo(s) em execução
###########################################################
get_pid() {
    TOPIC=$1
    ps -ef | grep ${TOPIC} | awk '{print $2 $8 $10}' | grep java | sed 's/[^0-9]*//g' 
}

#################################################################
# Carregar à função get_pid().
# Argumento: 1
#################################################################
get_pid $1