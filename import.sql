-- sudo -u postgres psql -f import.sql 

-- Conectar ao banco de dados
\c intuitive_db;

-- Importar dados das operadoras
COPY operadoras_ativas 
FROM '$PATH_DOWNLOADS/Relatorio_cadop.csv' 
WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'UTF8');

-- Importar demonstrações contábeis
-- Fiz um arquivo.sh para importar os dados das demonstrações contábeis
-- ./insert_demo_contabeis.sh
