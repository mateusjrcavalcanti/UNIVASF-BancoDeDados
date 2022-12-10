------> LIMPANDO O SCHEMA
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA IF NOT EXISTS public;


------> CRIANDO TABELAS E COLUNAS
CREATE TABLE "Categoria"
(
    codcategoria SERIAL,
    categoria character varying(255),
    CONSTRAINT "Categoria_pkey" PRIMARY KEY (codcategoria)
);

CREATE TABLE "Cidade"
(
    codcidade SERIAL,
    cidade character varying,
    CONSTRAINT "Cidade_pkey" PRIMARY KEY (codcidade)
);

CREATE TABLE "Departamento"
(
    coddepartamento SERIAL,
    departamento character varying,
    CONSTRAINT "Departamento_pkey" PRIMARY KEY (coddepartamento)
);

CREATE TABLE "Loja"
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

CREATE TABLE "Fornecedor"
(
    codfornecedor SERIAL,
    fornecedor character varying,
    endereco character varying,
    num integer,
    bairro character varying,
    cep character(9),
    cnpj character(18),
    insc character varying,
    tel character(14),
    "codcidade" integer,
    CONSTRAINT "Fornecedor_pkey" PRIMARY KEY (codfornecedor),
	CONSTRAINT "Fornecedor_codcidade_fkey" FOREIGN KEY ("codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE "Transportadora"
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
    "codcidade" integer,
    CONSTRAINT "Transportadora_pkey" PRIMARY KEY (codtransportadora),
	CONSTRAINT "Transportadora_codcidade_fkey" FOREIGN KEY ("codcidade")
    REFERENCES "Cidade" (codcidade)
);

CREATE TABLE "Produto"
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

CREATE TABLE "Entrada"
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

CREATE TABLE "ItemEntrada"
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

CREATE TABLE "Saida"
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

CREATE TABLE "ItemSaida"
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

CREATE TABLE "Funcionario"
(
    codfuncionario SERIAL,
    funcionario character varying,
    CONSTRAINT "Funcionario_pkey" PRIMARY KEY (codfuncionario),
	
	codloja integer,
	CONSTRAINT "Funcionario_codloja_fkey" FOREIGN KEY ("codloja")
    REFERENCES "Loja" (codloja)
);

CREATE TABLE "Funcionario_Departamento"
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


----> EDITANDO TABELAS

--* Coluna de Contato *--
ALTER TABLE "Transportadora" ADD COLUMN IF NOT EXISTS contato character varying;
ALTER TABLE "Fornecedor" ADD COLUMN IF NOT EXISTS contato character varying;


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
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Azul', 'Rua Rio Negro', 206, 'centro',  '56302300', '1234567891234', '987654321', '78678687687676', 2, 'gasparzinho');
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Amarelo', 'Rua Rio Negro', 386, 'henrique café',  '56302300', '1234567891234', '987654321', '000111000222333555', 2, 'luizinho');
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Preto', 'Rua Rio Negro', 96, 'castelo branco',  '56302300', '6546546546', '654654656546', '64565654354345', 1, 'pedrindo');
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Branco', 'Rua Rio Negro', 206, 'vila eduarda',  '56302300', '54654646', '654654654', '5876783873783', 1, 'joaozinho');
 
--* Funcionarios *--
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Fulano de Paula', 1);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Deltrano', 2);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Cicrano', 3);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Cleiton', 4);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Beltrano', 3);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Osvaldo', 2);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Margarete', 1);
INSERT INTO "Funcionario"  VALUES (DEFAULT, 'Judite', 4);
 
--* Relacionamento entre Funcionarios e Departamentos *--
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

--* Fornecedores *--
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Brasilian Imports', 'Rua Dona Celma', 26, 'centro', '56509300', '6564656655', '65465465465465', '+5581855526312', 1, 'Sr. João');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Distribuidora de Acessórios', 'Rua Barão do Mar Azul', 64, 'cohab', '56509300', '6564656655', '65465465465465', '+5581855526312', 2, 'Huan Iang');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Atacadão', 'Rua Antonio barboza', 124, 'areia amarela', '56429300', '6564656655', '65465465465465', '+5581855526312', 1, 'Sr. e Sra. Smith');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Leve Tudo', 'Rua 20', 224, 'henrique café', '56509450', '6564656655', '65465465465465', '+5581855526312', 2, 'Baba Yaga');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'China Importados', 'Rua 18', 234, 'idalino souza', '56329300', '6564656655', '65465465465465', '+5581855526312', 1, 'Ana Florinda');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'IDistribuidora', 'Rua pão de açucar', 241, 'centro', '56339300', '6564656655', '65465465465465', '+5581855526312', 2, 'Isa newton');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'John LTDA', 'Av. das nações desunidas', 248, 'ana auxiliadora', '56509110', '6564656655', '65465465465465', '+5581855526312', 1, 'john wick');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'BH Imports', 'Rua Dona Celma', 240, 'centro', '56509990', '6564656655', '65465465465465', '+5581855526312', 2, 'johnny');

--* Produtos [ codproduto | descricao | peso | qtdemin | codcategoria | codfornecedor] *--

/*
	CATEGORIAS SEM PRODUTOS:
		Joelheira
		Joias
		Lenço
		Luva
		Malas
		Máscara de plástico
		Óculos (lentes de vidro)
		Óculos de sol
		Relógio
*/

INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa com detalhe de costura', 1.256, 1, 2, 1);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa com alça superior Carta Gráfica Bloco de cores', 1.105, 1, 2, 2);
INSERT INTO "Produto"  VALUES (DEFAULT, 'EMERY ROSE Mochila Funcional Minimalista Grande capacidade', 1.659, 1, 2, 3);
INSERT INTO "Produto"  VALUES (DEFAULT, 'DORA.C S J Mochila bolsa Feminina Couro', 1.563, 1, 2, 4);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Saco quadrado de grande capacidade minimalista', 0.959, 1, 2, 4);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa Adidas Organizer', 0.989, 1, 1, 5);
INSERT INTO "Produto"  VALUES (DEFAULT, 'bolsa de lona moda fold', 1.235, 1, 1, 6);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa De Ombro Feminina Com Todos Os Jogos Mini Bolsa De Lon', 1.356, 1, 1, 7);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Boné de beisebol bordado com letras', 0.152, 1, 3, 8);
INSERT INTO "Produto"  VALUES (DEFAULT, '3 peças boné de beisebol sólido', 0.325, 1, 3, 1);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Capacete Moto R8 Pro Tork Fechado 60 Preto/Prata Viseira Fumê', 1.800, 1, 4, 2);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Capacete Fechado Stealth Solid 58 Viseira Fumê Preto Metalico', 1.880, 1, 4, 3);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Chapéu Americano Country Em Couro Legitimo Cowboy', 0.546, 1, 5, 4);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Chapéu Couro Cabana Nordestino Vaqueiro Cowboy', 0.465, 1, 5, 5);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Chapéu de dois tons', 0.326, 1, 6, 6);
INSERT INTO "Produto"  VALUES (DEFAULT, '4 peças de cinto de fivela geométrica', 0.411, 1, 7, 7);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Cinto Masculino William Polo Original Em Couro Legítimo Modelo Elegant', 0.201, 1, 7, 8);
INSERT INTO "Produto"  VALUES (DEFAULT, 'GRAVATA BUSINESS PREMIUM REGULAR', 0.222, 1, 8, 1);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Gravata Tradicional Luxo Homens Slim Fit.', 0.159, 1, 8, 3);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Sombrinha Guarda-Chuva Dobrável Semi Automático Masculina Negócios Preto', 0.475, 1, 9, 2);
INSERT INTO "Produto"  VALUES (DEFAULT, 'guarda-chuva dobrável automático com luz led à prova de vento portátil', 1.123, 1, 9, 5);

--* ENTRADA [ codentrada | dataped | dataentr | total | frete | numnf | imposto | codtransportadora | codloja] *--
INSERT INTO "Entrada"  VALUES (DEFAULT, 'dataped', 'dataentr', 0);

--* ITEM ENTRADA
--* SAIDA
--* ITEM SAIDA

----> REALIZANDO CONSULTAS
SELECT * FROM "Cidade"