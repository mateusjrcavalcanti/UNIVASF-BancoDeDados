------> LIMPANDO O SCHEMA
DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA IF NOT EXISTS public;

------> CRIANDO TABELAS E SEUS RELACIONAMENTOS
CREATE TABLE IF NOT EXISTS "Categoria"
(
    codcategoria SERIAL,
    categoria character varying(255),
    CONSTRAINT "Categoria_pkey" PRIMARY KEY (codcategoria)
);

CREATE TABLE IF NOT EXISTS "Cidade"
(
    codcidade SERIAL,
    cidade character varying,
    CONSTRAINT "Cidade_pkey" PRIMARY KEY (codcidade)
);

CREATE TABLE IF NOT EXISTS "Departamento"
(
    coddepartamento SERIAL,
    departamento character varying,
    CONSTRAINT "Departamento_pkey" PRIMARY KEY (coddepartamento)
);

CREATE TABLE IF NOT EXISTS "Loja"
(
    codloja SERIAL,
    nome character varying,
    endereco character varying,
    num integer,
    bairro character varying,
    cep character(9),
    tel character(14),
    insc character varying,
    cnpj character(18),
    "codcidade" integer,
    CONSTRAINT "Loja_pkey" PRIMARY KEY (codloja),
	CONSTRAINT "Loja_codcidade_fkey" FOREIGN KEY ("codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE IF NOT EXISTS "Fornecedor"
(
    codfornecedor SERIAL,
    fornecedor character varying,
    endereco character varying,
    num integer,
    bairro character varying,
    cep character(9),
    contato "char",
    cnpj character(18),
    insc character varying,
    tel character(14),
    "codcidade" integer,
    CONSTRAINT "Fornecedor_pkey" PRIMARY KEY (codfornecedor),
	CONSTRAINT "Fornecedor_codcidade_fkey" FOREIGN KEY ("codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE IF NOT EXISTS "Transportadora"
(
    codtransportadora SERIAL,
    transportadora character varying,
    endereco character varying,
    num integer,
    bairro character varying,
    cep character(9),
    cnpj character(16),
    tel character(14),
    insc character varying,
    contato character varying,
    "codcidade" integer,
    CONSTRAINT "Transportadora_pkey" PRIMARY KEY (codtransportadora),
	CONSTRAINT "Transportadora_codcidade_fkey" FOREIGN KEY ("codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE IF NOT EXISTS "Produto"
(
    codproduto SERIAL,
    descricao character varying,
    peso double precision,
    qtdemin integer,
    "codcategoria" integer,
    "codfornecedor" integer,
    CONSTRAINT "Produto_pkey" PRIMARY KEY (codproduto),
	CONSTRAINT "Produto_codfornecedor_fkey" FOREIGN KEY ("codfornecedor")
    REFERENCES "Fornecedor" (codfornecedor),
	CONSTRAINT "Produto_codcategoria_fkey" FOREIGN KEY ("codcategoria")
    REFERENCES "Categoria" (codcategoria)
);

CREATE TABLE IF NOT EXISTS "Entrada"
(
    codentrada SERIAL,
    dataped date,
    dataentr date,
    total double precision,
    frete double precision,
    numnf integer,
    imposto double precision,
    "codtransportadora" integer,
    "codloja" integer,
    CONSTRAINT "Entrada_pkey" PRIMARY KEY (codentrada),
	CONSTRAINT "Entrada_codtransportadora_fkey" FOREIGN KEY ("codtransportadora")
    REFERENCES "Transportadora" (codtransportadora),
    CONSTRAINT "Entrada_codloja_fkey" FOREIGN KEY ("codloja")
    REFERENCES "Loja" (codloja)
);

CREATE TABLE IF NOT EXISTS "ItemEntrada"
(
    coditementrada SERIAL,
    lote character varying,
    qtde integer,
    valor double precision,
    "codentrada" integer,
    "codproduto" integer,
    CONSTRAINT "ItemEntrada_pkey" PRIMARY KEY (coditementrada),
	CONSTRAINT "ItemEntrada_codentrada_fkey" FOREIGN KEY ("codentrada")
    REFERENCES "Entrada" (codentrada),
	CONSTRAINT "ItemEntrada_codproduto_fkey" FOREIGN KEY ("codproduto")
    REFERENCES "Produto" (codproduto)
);

CREATE TABLE IF NOT EXISTS "Saida"
(
    codsaida SERIAL,
    total double precision,
    frete double precision,
    imposto double precision,
    "codtransportadora" integer,
    "codloja" integer,
    CONSTRAINT "Saida_pkey" PRIMARY KEY (codsaida),
	CONSTRAINT "Saida_codtransportadora_fkey" FOREIGN KEY ("codtransportadora")
    REFERENCES "Transportadora" (codtransportadora),
	CONSTRAINT "Saida_codloja_fkey" FOREIGN KEY ("codloja")
    REFERENCES "Loja" (codloja)
);

CREATE TABLE IF NOT EXISTS "ItemSaida"
(
    coditemsaida SERIAL,
    lote character varying,
    qtde integer,
    valor double precision,
    "codproduto" integer,
    "codsaida" integer,
    CONSTRAINT "ItemSaida_pkey" PRIMARY KEY (coditemsaida),
	CONSTRAINT "ItemSaida_codsaida_fkey" FOREIGN KEY ("codsaida")
    REFERENCES "Saida" (codsaida),
	CONSTRAINT "ItemSaida_codproduto_fkey" FOREIGN KEY ("codproduto")
    REFERENCES "Produto" (codproduto)
);

CREATE TABLE IF NOT EXISTS "Funcionario"
(
    codfuncionario SERIAL,
    funcionario character varying,
    CONSTRAINT "Funcionario_pkey" PRIMARY KEY (codfuncionario),
	
	codloja integer,
	CONSTRAINT "Funcionario_codloja_fkey" FOREIGN KEY ("codloja")
    REFERENCES "Loja" (codloja)
);

CREATE TABLE IF NOT EXISTS "Funcionario_Departamento"
(
    codfuncionario serial,
    coddepartamento serial,
    data date,
    PRIMARY KEY (codfuncionario, coddepartamento),
    FOREIGN KEY (codfuncionario)
    REFERENCES "Funcionario" (codfuncionario) ON DELETE CASCADE,
    FOREIGN KEY (coddepartamento)
    REFERENCES "Departamento" (coddepartamento) ON DELETE CASCADE
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

--* Departamentos *--
INSERT INTO "Departamento" (departamento) VALUES ('Recursos Humanos');
INSERT INTO "Departamento" (departamento) VALUES ('Vendas');
INSERT INTO "Departamento" (departamento) VALUES ('Contabilidade');
INSERT INTO "Departamento" (departamento) VALUES ('Segurança');
INSERT INTO "Departamento" (departamento) VALUES ('Diretoria');
INSERT INTO "Departamento" (departamento) VALUES ('TI');


--* Lojas *--
INSERT INTO "Loja" VALUES (DEFAULT, 'Mexicanas', 'Rua Ana Julia', 20, 'centro', '56302300', '+5581988526312', '6564656655', '65465465465465', 1);
INSERT INTO "Loja" VALUES (DEFAULT, 'Magazine Leticia', 'Rua João Paulo', 31, 'centro', '56302300', '87988926512', '977465465', '646464646565', 2);
INSERT INTO "Loja" VALUES (DEFAULT, 'Rezende', 'Rua Paulo Plinio', 310, 'cohab', '56302300', '21988929562', '654654654654', '854155155', 2);
INSERT INTO "Loja" VALUES (DEFAULT, 'Casas Amazonas', 'Rua Godoy', 418, 'areia branca', '56302300', '1234567891234', '987654321', '876.87678678687', 1);

--* Transportadoras *--
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Azul', 'Rua Rio Negro', 206, 'centro',  '56302300', '1234567891234', '987654321', '78678687687676', 'gasparzinho', 2);
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Amarelo', 'Rua Rio Negro', 386, 'henrique café',  '56302300', '1234567891234', '987654321', '000111000222333555', 'luizinho' , 2);
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Preto', 'Rua Rio Negro', 96, 'castelo branco',  '56302300', '6546546546', '654654656546', '64565654354345', 'pedrindo', 1);
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Branco', 'Rua Rio Negro', 206, 'vila eduarda',  '56302300', '54654646', '654654654', '5876783873783', 'joaozinho', 1);
 
--* Funcionarios *--
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Fulano de Paula', 1);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Deltrano', 2);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Cicrano', 3);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Cleiton', 4);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Beltrano', 3);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Osvaldo', 2);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Margarete', 1);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Judite', 4);
 
--* Funcionarios *--
INSERT INTO "Funcionario_Departamento"  VALUES (1, 1, '2017-05-12');
INSERT INTO "Funcionario_Departamento"  VALUES (3, 2, '2018-02-12');
INSERT INTO "Funcionario_Departamento"  VALUES (2, 3, '2019-05-13');
INSERT INTO "Funcionario_Departamento"  VALUES (4, 4, '2020-05-14');
INSERT INTO "Funcionario_Departamento"  VALUES (5, 5, '2021-05-15');
INSERT INTO "Funcionario_Departamento"  VALUES (6, 6, '2022-05-18');
INSERT INTO "Funcionario_Departamento"  VALUES (7, 5, '2016-06-17');
INSERT INTO "Funcionario_Departamento"  VALUES (8, 4, '2016-07-18');
INSERT INTO "Funcionario_Departamento"  VALUES (7, 3, '2016-08-19');
INSERT INTO "Funcionario_Departamento"  VALUES (6, 2, '2016-09-10');
INSERT INTO "Funcionario_Departamento"  VALUES (5, 1, '2016-10-11');
INSERT INTO "Funcionario_Departamento"  VALUES (4, 3, '2016-11-12');

----> REALIZANDO CONSULTAS
SELECT * FROM "Cidade"


