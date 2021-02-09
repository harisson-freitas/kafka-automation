#######################################################################
# Author: Harisson Freitas∴
# E-mail: "harisson.freitas@zallpy.com"
# Criado em: 22/01/2021
#######################################################################

#######################################################################
# Váriáveis para definir o tipo de operação.
# C -> Criar um tópico;
# D -> Excluir um tópico;
# PT -> Produzir/enviar mensagem para um tópico;
# CT -> Consumir mensagem(ns) de um tópico.
#######################################################################
create = C
delete = D
producer = PT
consumer = CT

#######################################################################
# Váriáveis para definir o tipo de teste.
# ST -> Envio de mensagens dentro de um período configurado em segundos;
# SQ -> Envio de mensagens com um valor de incremento definido;
# SS -> Envio de mensagens com um valor de incremento definido por "seq";
# SJ -> Envio de mensagem através de um arquivo json.
#######################################################################
send_time = ST
send_quantity = SQ
send_seq = SS
send_json = SJ   

#######################################################################
# Altera às permissões dos arquivos tornando-os executáveis
#######################################################################
config:
	chmod +x bin/*.sh
	
#######################################################################
# Executa todos os testes, utilizando um menu de opções.
#######################################################################
start:
	./bin/main.sh

#######################################################################
# Executa a criação de um tópico.
#######################################################################
create:
	./bin/main.sh $(create)

#######################################################################
# Executa a exclusão de um tópico.
#######################################################################
delete: 
	./bin/main.sh $(delete)

#######################################################################
# Executa o envio de mensagens por tempo.
#######################################################################
produce-time:
	./bin/main.sh $(producer) $(send_time) $(time) $(value)

#######################################################################
# Executa o envio de mensagens por quantidade de interações.
#######################################################################
produce-quantity:
	./bin/main.sh $(producer) $(send_quantity) $(quantity) $(value)

#######################################################################
# Executa o envio de mensagens por quantidade de interações - "seq"
#######################################################################
produce-seq:
	./bin/main.sh $(producer) $(send_seq) $(quantity)

#######################################################################
# Executa o envio de mensagens através de um arquivo json.
#######################################################################
produce-json:
	./bin/main.sh $(producer) $(send_json) $(value)

#######################################################################
# Executa o consumo de mensagens.
#######################################################################
consume: 
	./bin/main.sh $(consumer)