# Desafio de Engenheiro de Dados SQL

Este repositório contém a solução para o Desafio de Engenheiro de Dados, incluindo scripts SQL e configuração Docker para um banco de dados de comércio eletrônico.

## Overview

O desafio envolve a criação de scripts SQL para configurar um banco de dados de comércio eletrônico e resolver consultas específicas relacionadas aos negócios. Além disso, uma imagem Docker é fornecida para facilitar a implantação e teste.

## Instruções

### Construir a Imagem Docker

Para construir a imagem Docker, execute os seguintes comandos:

```bash
docker build -t challenge-sql .
```

### Execute Docker Container
Após construir a imagem, inicie um contêiner Docker com o seguinte comando:

```bash
docker run -it challenge-sql
```

Finalmente, saia do console com o comando `.exit`

## Diagrama
O desafio contém uma proposta de modelagem de dados de acordo com as necessidades e requisitos sugeridos.

![Descrição da Imagem](./diagrama/der.png)

`diagram/der.png`: Image of the diagram suggested for solving the challenge.
`diagram/diagram.txt`: Content generated through `create_tables.sql` at https://dbdiagram.io/


## Scripts SQL
`sql/create_table.sql`: Schema de tabelas para criação de um ambiente voltado para uma empresa de ecommerca.
`sql/respuestas_negocio.sql`: Instruções SQL fornecendo soluções para perguntas do desafio.
`sql/create_triggers`: Este script contém as triggers necessários para armazenar os eventos da tabela `Item`, para uma tabela `HistoryUpdateItems`.
`sql/create_trigger_events.sql`: Este é um script para testar se os eventos estão ocorrendo conforme o esperado.

## Contribuições
Sinta-se à vontade para contribuir abrindo problemas ou enviando solicitações pull.