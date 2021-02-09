#!/bin/bash

#####################################################
# Processo de teste para envio de
# eventos/mensagens para um tópico no
# Kafka - Menu de opções.
#####################################################

#####################################################
# Configurações do Menu.
# Local:
#   None
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   Lista de Menus:
#      *********************************************
#      ********Selecione o tipo de teste************
#      ** 1) Período de tempo
#      ** 2) Quantidade de iterações
#      ** 3) Quantidade de iterações - SEQ
#      ** 4) Arquivo JSON
#      **ou pressione 0 para sair.
#      *********************************************
#      Selecione a opção:
#####################################################
menu() {
    printf "\n${COLOR_DEFAULT}*********************************************\n${COLOR_DEFAULT}"
    printf "${COLOR_OPTIONS}********Selecione o tipo de teste************\n"
    printf "${COLOR_OPTIONS}**${COLOR_NUMBER} 1)${COLOR_OPTIONS} Período de tempo ${COLOR_DEFAULT}\n"
    printf "${COLOR_OPTIONS}**${COLOR_NUMBER} 2)${COLOR_OPTIONS} Quantidade de iterações ${COLOR_DEFAULT}\n"
    printf "${COLOR_OPTIONS}**${COLOR_NUMBER} 3)${COLOR_OPTIONS} Quantidade de iterações - SEQ ${COLOR_DEFAULT}\n"
    printf "${COLOR_OPTIONS}**${COLOR_NUMBER} 4)${COLOR_OPTIONS} Arquivo JSON ${COLOR_DEFAULT}\n"
    printf "${COLOR_OPTIONS}**ou pressione ${COLOR_NUMBER}0 ${COLOR_OPTIONS}para sair. ${COLOR_OPTIONS}\n"
    printf "${COLOR_DEFAULT}*********************************************\n"
    printf "${COLOR_OPTIONS}Selecione a opção: ${COLOR_NUMBER}"

    read opt
}

#####################################################
# Mensagem para seleção de menu.
# Local:
#    _message -> mensagem informativa após a seleção
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   Mensagem com o valor da opção escolhida, ou
#   opção inválida.
#####################################################
option_select() {
    _message=${@:-"${COLOR_INVALID}Error: Nenhuma mensagem informada"}
    [[ $_message =~ 'inválida' ]] &&
        printf "${COLOR_INVALID}${_message}\n" ||
        printf "${COLOR_DEFAULT}${_message}${COLOR_OPTIONS}\n"
}

#####################################################
# Validar se o valor informado é um número
# Local:
#    _regex -> Expressão regular para numerais
# Global:
#   None
# Argumentos:
#   $1 -> Valor númerico(Quantidade/Tempo)
# Retorno:
#   Se na composição do valor informado não houverem
#   apenas valores númericos, será retornado uma
#   mensagem criticando a ação.
#####################################################
validate_number() {
    _regex='^[0-9]+$'
    if ! [[ $1 =~ $_regex ]]; then
        echo "Informar um valor válido!"
    fi
}

#####################################################
# Controle e execução do menu, e chamada do script
# ./load_kafka através da variável $SCRIPT_KAFKA.
# Local:
#    _type_test -> Tipo de teste a ser executado
# Global:
#   None
# Argumentos:
#   None
# Retorno:
#   None
#####################################################
start_menu() {
    clear
    menu

    while [[ $opt != 0 ]]; do
        case $opt in
        1)
            clear
            option_select "Opção 1 selecionada - [Período de tempo]\n"
            _type_test='ST'

            read -p "Informe o tempo(minutos): " n1
            read -p "Informe o nome do arquivo .json ou a mensagem: " n2
            echo ""

            _validate=$(validate_number $n1)
            [[ -z $_validate ]] && ${SCRIPT_KAFKA} $_type_test $n1 $n2 ||
                echo ${_validate}
            ;;
        2)
            clear
            option_select "Opção 2 selecionada - [Quantidade de iterações]\n"
            _type_test='SQ'

            read -p "Informe a quantidade de iterações: " n1
            read -p "Informe o nome do arquivo .json ou a mensagem: " n2
            echo ""

            _validate=$(validate_number $n1)
            [[ -z $_validate ]] && ${SCRIPT_KAFKA} $_type_test $n1 $n2 ||
                echo ${_validate}
            ;;
        3)
            clear
            option_select "Opção 3 selecionada - [Quantidade de iterações - SEQ]\n"
            _type_test='SS'

            read -p "Informe a quantidade de iterações: " n1
            echo ""

            _validate=$(validate_number $n1)
            [[ -z $_validate ]] && ${SCRIPT_KAFKA} $_type_test $n1 ||
                echo ${_validate}
            ;;
        4)
            clear
            option_select "Opção 4 selecionada - [Arquivo JSON]\n"
            _type_test='SJ'

            read -p "Informe o nome do arquivo: " n1
            echo ""

            ${SCRIPT_KAFKA} $_type_test $n1
            ;;
        *)
            clear
            option_select "Opção inválida!\n"
            ;;
        esac

        menu
    done
}

#####################################################
# Carregar à função start_menu.
#####################################################
start_menu
