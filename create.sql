-- sudo -u postgres psql -f create.sql 
-- Criar banco de dados
SELECT 'CREATE DATABASE intuitive_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'intuitive_db')\gexec

-- Conectar ao banco de dados
\c intuitive_db;

-- Tabela de Operadoras Ativas
CREATE TABLE operadoras_ativas (
    registro_ans VARCHAR(6) PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social VARCHAR(255),
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    logradouro VARCHAR(255),
    numero VARCHAR(50),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    cep VARCHAR(8),
    ddd VARCHAR(5),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(100),
    representante VARCHAR(255),
    cargo_representante VARCHAR(100),
    regiao_de_comercializacao INT,
    data_registro_ans DATE,

    -- Adicionando constraints para validação
    CONSTRAINT ck_cnpj_length CHECK (LENGTH(cnpj) = 14),
    CONSTRAINT ck_uf_valid CHECK (uf IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
                                    'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN',
                                       'RS','RO','RR','SC','SP','SE','TO'))
);

-- Tabela de Demonstrações Contábeis
CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    data DATE,
    reg_ans VARCHAR(6),
    cd_conta_contabil VARCHAR(20),
    descricao TEXT, -- Algumas descrições podem ser muito longas para VARCHAR
    vl_saldo_inicial DECIMAL(15,2),
    vl_saldo_final DECIMAL(15,2)
);

-- Índices para melhorar performance das consultas
CREATE INDEX idx_dc_reg_ans ON demonstracoes_contabeis(reg_ans);
CREATE INDEX idx_dc_data ON demonstracoes_contabeis(data);
CREATE INDEX idx_dc_conta ON demonstracoes_contabeis(cd_conta_contabil);



