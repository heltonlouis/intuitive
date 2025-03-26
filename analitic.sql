-- sudo -u postgres psql -f analitic.sql 

-- Conectar ao banco de dados
\c intuitive_db;

-- 10 operadoras com maiores despesas no último trimestre
SELECT 
    o.razao_social,
    o.nome_fantasia,
    d.data,
    SUM(d.vl_saldo_inicial - d.vl_saldo_final) AS total_despesas
FROM 
    demonstracoes_contabeis d
JOIN 
    operadoras_ativas o ON d.reg_ans = o.registro_ans
WHERE 
    d.descricao LIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND d.data >= (CURRENT_DATE - INTERVAL '3 months') -- Últimos 3 meses não tem nada, veja a partir de 6 meses
GROUP BY 
    o.razao_social, o.nome_fantasia, d.data
ORDER BY 
    total_despesas DESC
LIMIT 10;

-- 10 operadoras com maiores despesas no último ano
SELECT 
    o.razao_social,
    o.nome_fantasia,
    d.data,
    SUM(d.vl_saldo_inicial - d.vl_saldo_final) AS total_despesas_anual
FROM 
    demonstracoes_contabeis d
JOIN 
    operadoras_ativas o ON d.reg_ans = o.registro_ans
WHERE 
    d.descricao LIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND d.data >= (CURRENT_DATE - INTERVAL '1 year') -- Último ano
GROUP BY 
    o.razao_social, o.nome_fantasia, d.data
ORDER BY 
    total_despesas_anual DESC
LIMIT 10;