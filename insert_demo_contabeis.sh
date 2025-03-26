#!/bin/bash

# Trocar o PATH_DOWNLOADS pelo caminho absoluto da pasta downloads

for file in $PATH_DOWNLOADS/demo_contabeis/*.csv; do
    sudo -u postgres psql -d intuitive_db -c "
    -- Criar tabela temporária com colunas como texto
    CREATE TEMP TABLE temp_import (
        data TEXT,
        reg_ans TEXT,
        cd_conta_contabil TEXT,
        descricao TEXT,
        vl_saldo_inicial TEXT,
        vl_saldo_final TEXT
    );

    -- Importar para tabela temporária
    COPY temp_import FROM '$file' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');

    -- Inserir na tabela real com transformação
    INSERT INTO demonstracoes_contabeis (
        data,
        reg_ans,
        cd_conta_contabil,
        descricao,
        vl_saldo_inicial,
        vl_saldo_final
    )
    SELECT 
        data::DATE,
        reg_ans,
        cd_conta_contabil,
        descricao,
        REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC(15,2),
        REPLACE(vl_saldo_final, ',', '.')::NUMERIC(15,2)
    FROM temp_import;

    -- Limpar tabela temporária
    DROP TABLE temp_import;"
done