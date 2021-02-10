# Kafka Automation Test

<p>Ferramenta para criar, produzir, consumir e excluir eventos e tópicos do Kafka.
</p>

## Configurações
- Pré-requisitos
- Linux
- Windows

## Pré-requisitos
 - **_build-essential(Make)_**
 - **_jq_**
 - **_docker_**(Obrigatório para Windows)

## Instalando Build Essential
 O build-essential é necessário para que tenhamos como executar o comando **_make_**(GNU Make) referente ao arquivo **_Makefile_**;
 Abra seu **_terminal(Linux Bash Shell no Windows)_**, e execute o seguinte comando:`sudo apt-get install build-essential`;
 Para verificar se instalou com sucesso, basta executar: `make --version` e deverá ter uma saída igual à:<br/> 
GNU Make 4.2.1
Compilado para x86_64-pc-linux-gnu
Copyright (C) 1988-2016 Free Software Foundation, Inc.
Licença GPLv3+: GNU GPL versão 3 ou posterior <http://gnu.org/licenses/gpl.html>
Isto é um aplicativo livre: você pode alterá-lo e redistribui-lo livremente.
NÃO HÁ GARANTIAS, exceto o que for permitido por lei.

 
## Utilização
 - Local(Linux)
 - Docker(Linux/Windows)
 - Ambiente de TST

## Configuração Ambiente Linux
Os ambientes(SO) linux que forma homologados:
 - Ubuntu 16.+
 - Kubuntu 16.+ 
 - Mint 16.+ 
 - Fedora 28.+
