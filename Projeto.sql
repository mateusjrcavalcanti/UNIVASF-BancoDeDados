------> LIMPANDO O SCHEMA
DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA IF NOT EXISTS public;

------> CRIANDO TABELAS E SEUS RELACIONAMENTOS
CREATE TABLE IF NOT EXISTS "Categoria"
(
    codcategoria SERIAL,
    categoria character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "Categoria_pkey" PRIMARY KEY (codcategoria)
);

CREATE TABLE IF NOT EXISTS "Cidade"
(
    codcidade SERIAL,
    cidade character varying COLLATE pg_catalog."default",
    CONSTRAINT "Cidade_pkey" PRIMARY KEY (codcidade)
);

CREATE TABLE IF NOT EXISTS "Departamento"
(
    coddepartamento SERIAL,
    departamento character varying COLLATE pg_catalog."default",
    CONSTRAINT "Departamento_pkey" PRIMARY KEY (coddepartamento)
);

CREATE TABLE IF NOT EXISTS "Funcionario"
(
    codfuncionario SERIAL,
    funcionario character varying COLLATE pg_catalog."default",
    CONSTRAINT "Funcionario_pkey" PRIMARY KEY (codfuncionario)
);

CREATE TABLE IF NOT EXISTS "Funcionario_Departamento"
(
    codfuncionario serial,
    coddepartamento serial,
    PRIMARY KEY (codfuncionario, coddepartamento),
    FOREIGN KEY (codfuncionario)
    REFERENCES "Funcionario" (codfuncionario) ON DELETE CASCADE,
    FOREIGN KEY (coddepartamento)
    REFERENCES "Departamento" (coddepartamento) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Loja"
(
    codloja SERIAL,
    nome character varying COLLATE pg_catalog."default",
    endereco character varying COLLATE pg_catalog."default",
    num integer,
    bairro character varying COLLATE pg_catalog."default",
    tel character(14) COLLATE pg_catalog."default",
    insc character varying COLLATE pg_catalog."default",
    cnpj character(18) COLLATE pg_catalog."default",
    "Cidade_codcidade" integer,
    CONSTRAINT "Loja_pkey" PRIMARY KEY (codloja),
	CONSTRAINT "Loja_Cidade_codcidade_fkey" FOREIGN KEY ("Cidade_codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE IF NOT EXISTS "Fornecedor"
(
    codfornecedor SERIAL,
    fornecedor character varying COLLATE pg_catalog."default",
    endereco character varying COLLATE pg_catalog."default",
    num integer,
    bairro character varying COLLATE pg_catalog."default",
    cep character(9) COLLATE pg_catalog."default",
    contato "char",
    cnpj character(18) COLLATE pg_catalog."default",
    insc character varying COLLATE pg_catalog."default",
    tel character(14) COLLATE pg_catalog."default",
    "Cidade_codcidade" integer,
    CONSTRAINT "Fornecedor_pkey" PRIMARY KEY (codfornecedor),
	CONSTRAINT "Fornecedor_Cidade_codcidade_fkey" FOREIGN KEY ("Cidade_codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE IF NOT EXISTS "Transportadora"
(
    codtransportadora SERIAL,
    transportadora character varying COLLATE pg_catalog."default",
    endereco character varying COLLATE pg_catalog."default",
    num integer,
    bairro character varying COLLATE pg_catalog."default",
    cep character(9) COLLATE pg_catalog."default",
    cnpj character(1) COLLATE pg_catalog."default",
    insc character varying COLLATE pg_catalog."default",
    contato character varying COLLATE pg_catalog."default",
    tel character(14) COLLATE pg_catalog."default",
    "Cidade_codcidade" integer,
    CONSTRAINT "Transportadora_pkey" PRIMARY KEY (codtransportadora),
	CONSTRAINT "Transportadora_Cidade_codcidade_fkey" FOREIGN KEY ("Cidade_codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE IF NOT EXISTS "Produto"
(
    codproduto SERIAL,
    descricao character varying COLLATE pg_catalog."default",
    peso double precision,
    qtdemin integer,
    "Categoria_codcategoria" integer,
    "Fornecedor_codfornecedor" integer,
    CONSTRAINT "Produto_pkey" PRIMARY KEY (codproduto),
	CONSTRAINT "Produto_Fornecedor_codfornecedor_fkey" FOREIGN KEY ("Fornecedor_codfornecedor")
    REFERENCES "Fornecedor" (codfornecedor),
	CONSTRAINT "Produto_Categoria_codcategoria_fkey" FOREIGN KEY ("Categoria_codcategoria")
    REFERENCES "Categoria" (codcategoria)
);

CREATE TABLE IF NOT EXISTS "Entrada"
(
    coditementrada SERIAL,
    dataped date,
    dataentr date,
    total double precision,
    frete double precision,
    numnf integer,
    imposto double precision,
    "Transportadora_codtransportadora" integer,
    "Loja_codloja" integer,
    CONSTRAINT "Entrada_pkey" PRIMARY KEY (coditementrada),
	CONSTRAINT "Entrada_Transportadora_codtransportadora_fkey" FOREIGN KEY ("Transportadora_codtransportadora")
    REFERENCES "Transportadora" (codtransportadora)
);

CREATE TABLE IF NOT EXISTS "ItemEntrada"
(
    codentrada SERIAL,
    lote character varying COLLATE pg_catalog."default",
    qtde integer,
    valor double precision,
    "Entrada_codentrada" integer,
    "Produto_codproduto" integer,
    CONSTRAINT "ItemEntrada_pkey" PRIMARY KEY (codentrada),
	CONSTRAINT "ItemEntrada_Entrada_codentrada_fkey" FOREIGN KEY ("Entrada_codentrada")
    REFERENCES "Entrada" (coditementrada),
	CONSTRAINT "ItemEntrada_Produto_codproduto_fkey" FOREIGN KEY ("Produto_codproduto")
    REFERENCES "Produto" (codproduto)
);

CREATE TABLE IF NOT EXISTS "Saida"
(
    codsaida SERIAL,
    total double precision,
    frete double precision,
    imposto double precision,
    "Transportadora_codtransportadora" integer,
    "Loja_codloja" integer,
    CONSTRAINT "Saida_pkey" PRIMARY KEY (codsaida),
	CONSTRAINT "Saida_Transportadora_codtransportadora_fkey" FOREIGN KEY ("Transportadora_codtransportadora")
    REFERENCES "Transportadora" (codtransportadora),
	CONSTRAINT "Saida_Loja_codloja_fkey" FOREIGN KEY ("Loja_codloja")
    REFERENCES "Loja" (codloja)
);

CREATE TABLE IF NOT EXISTS "ItemSaida"
(
    coditemsaida SERIAL,
    lote character varying COLLATE pg_catalog."default",
    qtde integer,
    valor double precision,
    "Produto_codproduto" integer,
    "Saida_codsaida" integer,
    CONSTRAINT "ItemSaida_pkey" PRIMARY KEY (coditemsaida),
	CONSTRAINT "ItemSaida_Saida_codsaida_fkey" FOREIGN KEY ("Saida_codsaida")
    REFERENCES "Saida" (codsaida),
	CONSTRAINT "ItemSaida_Produto_codproduto_fkey" FOREIGN KEY ("Produto_codproduto")
    REFERENCES "Produto" (codproduto)
);

----> INSERINDO DADOS

--* Categorias *--
INSERT INTO "Categoria" (categoria) VALUES ('Bolsa (geral)');
INSERT INTO "Categoria" (categoria) VALUES ('Bolsa de couro');
INSERT INTO "Categoria" (categoria) VALUES ('Boné');
INSERT INTO "Categoria" (categoria) VALUES ('Capacete para motociclista');
INSERT INTO "Categoria" (categoria) VALUES ('Chapéu de couro');
INSERT INTO "Categoria" (categoria) VALUES ('Chapéu de palha');
INSERT INTO "Categoria" (categoria) VALUES ('Cinto de couro');
INSERT INTO "Categoria" (categoria) VALUES ('Gravata');
INSERT INTO "Categoria" (categoria) VALUES ('Guarda-chuva/Sombrinha');
INSERT INTO "Categoria" (categoria) VALUES ('Joelheira');
INSERT INTO "Categoria" (categoria) VALUES ('Joias');
INSERT INTO "Categoria" (categoria) VALUES ('Lenço');
INSERT INTO "Categoria" (categoria) VALUES ('Luva');
INSERT INTO "Categoria" (categoria) VALUES ('Malas');
INSERT INTO "Categoria" (categoria) VALUES ('Máscara de plástico');
INSERT INTO "Categoria" (categoria) VALUES ('Óculos (lentes de vidro)');
INSERT INTO "Categoria" (categoria) VALUES ('Óculos de sol');
INSERT INTO "Categoria" (categoria) VALUES ('Relógio');

--* Cidades *--
INSERT INTO "Cidade" (cidade) VALUES ('Petrolina');
INSERT INTO "Cidade" (cidade) VALUES ('Juazeiro');

----> REALIZANDO CONSULTAS
SELECT * FROM "Cidade"
