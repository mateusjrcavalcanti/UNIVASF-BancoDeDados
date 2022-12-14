------> APAGANDO TABELA
DROP TABLE IF EXISTS Cidade;
DROP TABLE IF EXISTS Categoria;

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
    REFERENCES "Transportadora" (codtransportadora) ON DELETE CASCADE,
    CONSTRAINT "Entrada_codloja_fkey" FOREIGN KEY ("codloja")
    REFERENCES "Loja" (codloja) ON DELETE CASCADE,
	CHECK (dataped <= CURRENT_DATE),
	CHECK (dataentr <= CURRENT_DATE)
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
    REFERENCES "Entrada" (codentrada) ON DELETE CASCADE,
	CONSTRAINT "ItemEntrada_codproduto_fkey" FOREIGN KEY ("codproduto")
    REFERENCES "Produto" (codproduto) ON DELETE CASCADE
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
    REFERENCES "Transportadora" (codtransportadora) ON DELETE CASCADE,
	CONSTRAINT "Saida_codloja_fkey" FOREIGN KEY ("codloja")
    REFERENCES "Loja" (codloja) ON DELETE CASCADE
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
    REFERENCES "Saida" (codsaida) ON DELETE CASCADE,
	CONSTRAINT "ItemSaida_codproduto_fkey" FOREIGN KEY ("codproduto")
    REFERENCES "Produto" (codproduto) ON DELETE CASCADE
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
    REFERENCES "Departamento" (coddepartamento) ON DELETE CASCADE,	
	CHECK (data <= CURRENT_DATE)
);


----> EDITANDO TABELAS

--* Coluna de Contato *--
ALTER TABLE "Transportadora" ADD COLUMN IF NOT EXISTS contato character varying;
ALTER TABLE "Fornecedor" ADD COLUMN IF NOT EXISTS contato character varying;

----> TRIGGER
CREATE OR REPLACE FUNCTION calcular_total_entrada() 
RETURNS trigger AS $calcular_total_entrada$
BEGIN
    UPDATE "Entrada" 
        SET total = (SELECT SUM(valor)
                         FROM "ItemEntrada"
                         WHERE codentrada = NEW.codentrada)
         WHERE codentrada = NEW.codentrada;
    RETURN NEW;
END;
$calcular_total_entrada$ LANGUAGE plpgsql;

CREATE TRIGGER ItemEntrada_added
  AFTER INSERT
  ON "ItemEntrada"
  FOR EACH ROW
  EXECUTE PROCEDURE calcular_total_entrada();

CREATE TRIGGER ItemEntrada_updated
  AFTER UPDATE
  ON "ItemEntrada"
  FOR EACH ROW
  EXECUTE PROCEDURE calcular_total_entrada();


CREATE TRIGGER ItemEntrada_deleted
  AFTER DELETE
  ON "ItemEntrada"
  FOR EACH ROW
  EXECUTE PROCEDURE calcular_total_entrada();

----> INSERINDO DADOS

--* Categorias *--
INSERT INTO "Categoria" (categoria) VALUES ('Bolsa (geral)');
INSERT INTO "Categoria" (categoria) VALUES ('Bolsa de couro');
INSERT INTO "Categoria" (categoria) VALUES ('Bon??');
INSERT INTO "Categoria" (categoria) VALUES ('Capacete para motociclista');
INSERT INTO "Categoria" (categoria) VALUES ('Chap??u de couro');
INSERT INTO "Categoria" (categoria) VALUES ('Chap??u de palha');
INSERT INTO "Categoria" (categoria) VALUES ('Cinto de couro');
INSERT INTO "Categoria" (categoria) VALUES ('Gravata');
INSERT INTO "Categoria" (categoria) VALUES ('Guarda-chuva/Sombrinha');

--* Cidades *--
INSERT INTO "Cidade" (cidade) VALUES ('Petrolina');
INSERT INTO "Cidade" (cidade) VALUES ('Juazeiro');

--* Departamentos *--
INSERT INTO "Departamento" (departamento) VALUES ('Recursos Humanos');
INSERT INTO "Departamento" (departamento) VALUES ('Vendas');
INSERT INTO "Departamento" (departamento) VALUES ('Contabilidade');
INSERT INTO "Departamento" (departamento) VALUES ('Seguran??a');
INSERT INTO "Departamento" (departamento) VALUES ('Diretoria');
INSERT INTO "Departamento" (departamento) VALUES ('TI');

--* Lojas *--
INSERT INTO "Loja" VALUES (DEFAULT, 'Mexicanas', 'Rua Ana Julia', 20, 'centro', '56302300', '+5581988526312', '6564656655', '65465465465465', 1);
INSERT INTO "Loja" VALUES (DEFAULT, 'Magazine Leticia', 'Rua Jo??o Paulo', 31, 'centro', '56302300', '87988926512', '977465465', '646464646565', 2);
INSERT INTO "Loja" VALUES (DEFAULT, 'Rezende', 'Rua Paulo Plinio', 310, 'cohab', '56302300', '21988929562', '654654654654', '854155155', 2);
INSERT INTO "Loja" VALUES (DEFAULT, 'Casas Amazonas', 'Rua Godoy', 418, 'areia branca', '56302300', '1234567891234', '987654321', '876.87678678687', 1);

--* Transportadoras *--
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Azul', 'Rua Rio Negro', 206, 'centro',  '56302300', '1234567891234', '+5587987654321', '78678687687676', 2, 'gasparzinho');
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Amarelo', 'Rua Rio Negro', 386, 'henrique caf??',  '56302300', '1234567891234', '+5587987654321', '000111000222333555', 2, 'luizinho');
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Preto', 'Rua Rio Negro', 96, 'castelo branco',  '56302300', '6546546546', '+5587654656546', '64565654354345', 1, 'pedrindo');
INSERT INTO "Transportadora" VALUES (DEFAULT, 'Branco', 'Rua Rio Negro', 206, 'vila eduarda',  '56302300', '54654646', '+5587654654654', '5876783873783', 1, 'joaozinho');
 
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
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Brasilian Imports', 'Rua Dona Celma', 26, 'centro', '56509300', '6564656655', '65465465465465', '+5581855526312', 1, 'Sr. Jo??o');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Distribuidora de Acess??rios', 'Rua Bar??o do Mar Azul', 64, 'cohab', '56509300', '6564656655', '65465465465465', '+5581855526312', 2, 'Huan Iang');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Atacad??o', 'Rua Antonio barboza', 124, 'areia amarela', '56429300', '6564656655', '65465465465465', '+5581855526312', 1, 'Sr. e Sra. Smith');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'Leve Tudo', 'Rua 20', 224, 'henrique caf??', '56509450', '6564656655', '65465465465465', '+5581855526312', 2, 'Baba Yaga');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'China Importados', 'Rua 18', 234, 'idalino souza', '56329300', '6564656655', '65465465465465', '+5581855526312', 1, 'Ana Florinda');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'IDistribuidora', 'Rua p??o de a??ucar', 241, 'centro', '56339300', '6564656655', '65465465465465', '+5581855526312', 2, 'Isa newton');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'John LTDA', 'Av. das na????es desunidas', 248, 'ana auxiliadora', '56509110', '6564656655', '65465465465465', '+5581855526312', 1, 'john wick');
INSERT INTO "Fornecedor" VALUES (DEFAULT, 'BH Imports', 'Rua Dona Celma', 240, 'centro', '56509990', '6564656655', '65465465465465', '+5572996526312', 2, 'johnny');

--* Produtos [ codproduto | descricao | peso | qtdemin | codcategoria | codfornecedor] *--
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa com detalhe de costura', 1.256, 1, 2, 1);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa com al??a superior Carta Gr??fica Bloco de cores', 1.105, 1, 2, 2);
INSERT INTO "Produto"  VALUES (DEFAULT, 'EMERY ROSE Mochila Funcional Minimalista Grande capacidade', 1.659, 1, 2, 3);
INSERT INTO "Produto"  VALUES (DEFAULT, 'DORA.C S J Mochila bolsa Feminina Couro', 1.563, 1, 2, 4);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Saco quadrado de grande capacidade minimalista', 0.959, 1, 2, 4);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa Adidas Organizer', 0.989, 1, 1, 5);
INSERT INTO "Produto"  VALUES (DEFAULT, 'bolsa de lona moda fold', 1.235, 1, 1, 6);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bolsa De Ombro Feminina Com Todos Os Jogos Mini Bolsa De Lon', 1.356, 1, 1, 7);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Bon?? de beisebol bordado com letras', 0.152, 1, 3, 8);
INSERT INTO "Produto"  VALUES (DEFAULT, '3 pe??as bon?? de beisebol s??lido', 0.325, 1, 3, 1);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Capacete Moto R8 Pro Tork Fechado 60 Preto/Prata Viseira Fum??', 1.800, 1, 4, 2);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Capacete Fechado Stealth Solid 58 Viseira Fum?? Preto Metalico', 1.880, 1, 4, 3);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Chap??u Americano Country Em Couro Legitimo Cowboy', 0.546, 1, 5, 4);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Chap??u Couro Cabana Nordestino Vaqueiro Cowboy', 0.465, 1, 5, 5);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Chap??u de dois tons', 0.326, 1, 6, 6);
INSERT INTO "Produto"  VALUES (DEFAULT, '4 pe??as de cinto de fivela geom??trica', 0.411, 1, 7, 7);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Cinto Masculino William Polo Original Em Couro Leg??timo Modelo Elegant', 0.201, 1, 7, 8);
INSERT INTO "Produto"  VALUES (DEFAULT, 'GRAVATA BUSINESS PREMIUM REGULAR', 0.222, 1, 8, 1);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Gravata Tradicional Luxo Homens Slim Fit.', 0.159, 1, 8, 3);
INSERT INTO "Produto"  VALUES (DEFAULT, 'Sombrinha Guarda-Chuva Dobr??vel Semi Autom??tico Masculina Neg??cios Preto', 0.475, 1, 9, 2);
INSERT INTO "Produto"  VALUES (DEFAULT, 'guarda-chuva dobr??vel autom??tico com luz led ?? prova de vento port??til', 1.123, 1, 9, 5);

--* ENTRADA [ codentrada | dataped | dataentr | total | frete | numnf | imposto | codtransportadora | codloja] *--
INSERT INTO "Entrada"  VALUES (DEFAULT, '2021-12-21', '2021-12-28', 0.0, 120.0, 546455467, 250.9, 1, 1);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2022-11-22', '2022-12-02', 0.0, 111.11, 565446547, 320.7, 1, 2);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2021-11-23', '2021-12-01', 0.0, 325.25, 545454547, 140.5, 1, 3);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2022-11-05', '2022-11-22', 0.0, 105.01, 454545457, 256.6, 1, 4);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2021-11-25', '2021-12-18', 0.0, 92.58, 745454455, 152.8, 3, 1);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2022-12-01', '2022-12-11', 0.0, 203.50, 454545145, 235.4,2, 2);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2021-12-27', '2022-01-17', 0.0, 156.89, 415845454, 655.1, 2, 3);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2022-12-02', '2022-12-11', 0.0, 65.99, 876537898, 325.2, 3, 4);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2021-11-09', '2021-12-11', 0.0, 165.89, 454545427, 136.85, 3, 1);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2022-11-30', '2022-12-11', 0.0, 201.81, 875858757, 236.85, 4, 2);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2021-11-01', '2021-11-18', 0.0, 235.93, 587587585, 136.87, 3, 3);
INSERT INTO "Entrada"  VALUES (DEFAULT, '2022-11-19', '2022-10-01', 0.0, 246.52, 785875875, 251.22, 1, 4);

--* ITEM ENTRADA [ coditementrada | lote | qtde | valor | codentrada| codproduto] *--
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '654554659', 10, 132.9, 1, 1);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '546546546', 9, 189.95, 2, 2);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '678687783', 8, 117.99, 3, 3);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '687687687', 7, 69.99, 4, 4);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '687687876', 6, 66.9, 5, 5);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '687687687', 5, 84.99, 6, 6);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '654654654', 6, 102.79, 7, 7);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '367383683', 7, 76.56, 8, 8);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '387383838', 8, 24.9, 9, 9);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '783873873', 9, 50.95, 10, 10);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '873876873', 10, 146.9, 11, 11);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '873878733', 14, 305.9, 12, 12);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '387387873', 13, 99.9, 1, 13);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '326532653', 12, 69, 2, 14);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '638383289', 11, 38.95, 3, 15);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '285639889', 10, 53.95, 4, 16);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '926986298', 9, 189.9, 5, 17);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '629869826', 8, 199.9, 6, 18);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '629683832', 7, 19.9, 7, 19);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '638632838', 6, 75, 8, 20);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '292829892', 5, 152.51, 9, 21);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '654554659', 4, 132.9, 10, 1);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '546546546', 5, 189.95, 11, 2);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '678687783', 6, 117.99, 12, 3);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '687687687', 7, 69.99, 1, 4);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '687687876', 8, 66.9, 2, 5);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '687687687', 9, 84.99, 3, 6);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '654654654', 10, 102.79, 4, 7);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '367383683', 11, 76.56, 5, 8);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '387383838', 12, 24.9, 6, 9);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '783873873', 13, 50.95, 7, 10);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '873876873', 14, 146.9, 8, 11);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '873878733', 13, 305.9, 9, 12);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '387387873', 12, 99.9, 10, 13);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '326532653', 11, 69, 11, 14);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '638383289', 10, 38.95, 12, 15);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '285639889', 9, 53.95, 1, 16);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '926986298', 8, 189.9, 2, 17);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '629869826', 7, 199.9, 3, 18);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '629683832', 6, 19.9, 4, 19);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '638632838', 5, 75, 5, 20);
INSERT INTO "ItemEntrada"  VALUES (DEFAULT, '292829892', 4, 152.51, 6, 21);

--* SAIDA [ codsaida | total | frete | imposto | codtransportadora | codloja] *--
INSERT INTO "Saida"  VALUES (DEFAULT, 0.0, 111.0, 222.9, 4, 1);
INSERT INTO "Saida"  VALUES (DEFAULT, 0.0, 122.0, 255.8, 2, 2);
INSERT INTO "Saida"  VALUES (DEFAULT, 0.0, 132.0, 244.7, 2, 3);
INSERT INTO "Saida"  VALUES (DEFAULT, 0.0, 142.0, 233.6, 1, 4);

--* ITEM SAIDA [ coditemsaida | lote | qtde | valor | codproduto| codsaida] *--
INSERT INTO "ItemSaida"  VALUES (DEFAULT, '654554659', 10, 132.9, 1, 1);
INSERT INTO "ItemSaida"  VALUES (DEFAULT, '546546546', 9, 189.95, 2, 2);
INSERT INTO "ItemSaida"  VALUES (DEFAULT, '678687783', 8, 117.99, 3, 3);
INSERT INTO "ItemSaida"  VALUES (DEFAULT, '687687687', 7, 69.99, 4, 4);

----> Fun????es de Convers??o (LOWER, UPPER e INITCAP)
SELECT LOWER(cidade) AS "Lower", UPPER(cidade) AS "Upper", INITCAP(cidade) AS "Initcap"  FROM "Cidade";
SELECT * FROM "Loja" where lower(nome)=lower('mExIcAnAs');

----> Fun????es de Manipula????o (CONCAT, SUBSTR, LENGTH, LPAD)
SELECT CONCAT(' Fornecedor: ', fornecedor, ' , Contato: ', contato, ', Telefone: ', tel) as Fornecedor FROM "Fornecedor";
SELECT CONCAT(' Fornecedor: ', transportadora, ' , Contato: ', contato, ', Telefone: ', tel) as Transportadora FROM "Transportadora";
SELECT SUBSTR(tel,0,4) as "c??digo do pa??s", SUBSTR(tel,4,2) as "DDD sem o zero", SUBSTR(tel,6,9) as "Numero" FROM "Fornecedor";
SELECT SUBSTR(tel,0,4) as "c??digo do pa??s", SUBSTR(tel,4,2) as "DDD sem o zero", SUBSTR(tel,6,9) as "Numero" FROM "Transportadora";
/*
SELECT 	tel as "Telefone",
		CASE WHEN LENGTH(tel)<>14 THEN 'Iv??lido'
			ELSE 'V??lido'
		END AS "V??lido | Inv??lido"
FROM "Fornecedor";
SELECT 	tel as "Telefone",
		CASE WHEN LENGTH(tel)<>14 THEN 'Iv??lido'
			ELSE 'V??lido'
		END AS "V??lido | Inv??lido"
FROM "Transportadora";
SELECT lpad(LOWER(transportadora), 20, '=') AS "Fun????o LPAD" FROM "Transportadora";
SELECT lpad(LOWER(funcionario), 20, '=') AS "Fun????o LPAD" FROM "Funcionario";

----> Fun????es de Conjuntos (MAX, MIN, SUM, AVG e COUNT)
SELECT MAX(imposto) AS "Maior Imposto" FROM "Entrada";
SELECT MAX(frete) AS "Maior Frete" FROM "Entrada";
SELECT MIN(imposto) AS "Maior Imposto" FROM "Entrada";
SELECT MIN(frete) AS "Maior Frete" FROM "Entrada";
SELECT AVG(frete) from "Entrada" WHERE codtransportadora = 2;
SELECT AVG(frete) from "Entrada" WHERE codtransportadora = 1;
SELECT COUNT(*) from "Entrada" WHERE codtransportadora = 2;
SELECT COUNT(*) from "Entrada" WHERE codtransportadora = 1;

----> DELETE
DELETE FROM "Saida" WHERE codloja = 1;
DELETE FROM "Saida" WHERE codloja = 2;

--> UPDATE
UPDATE "Funcionario" SET funcionario = 'O Tal Fulano' WHERE codfuncionario = 1;

--> ORDER BY & SELECT DISTINCT
SELECT DISTINCT codloja as loja FROM "Funcionario" ORDER BY loja ASC;
SELECT DISTINCT codtransportadora as transportadora FROM "Entrada" ORDER BY transportadora ASC;

--> SELECT WHERE (BETWEEN, IN, LIKE, IS NULL)
SELECT * FROM "Entrada" WHERE frete BETWEEN 100.0 AND 200.0;
SELECT * FROM "Entrada" WHERE imposto BETWEEN 100.0 AND 200.0;
SELECT * FROM "Funcionario" WHERE codloja IN (2, 4);
SELECT * FROM "Funcionario" WHERE codloja IN (1, 3);
SELECT * FROM "Produto" WHERE LOWER(descricao) LIKE LOWER('%bOl%');
SELECT * FROM "Fornecedor" WHERE LOWER(fornecedor) LIKE LOWER('%iMp%');
SELECT * FROM "Fornecedor" WHERE contato IS NOT NULL;
SELECT * FROM "Funcionario" WHERE codloja IS NULL;

--> JOIN
SELECT
    entrada.dataped as "Pedido",
	entrada.dataentr as "Entrega",
	produto.codproduto as "C??digo",
	produto.descricao as "Descri????o",
	produto.peso as "Peso",
    item.valor as "Valor"
FROM
    "Entrada" entrada
INNER JOIN
  "ItemEntrada" item
ON entrada.codentrada = item.codentrada
INNER JOIN
  "Produto" produto
ON produto.codproduto = item.codproduto
	WHERE entrada.codentrada = 1;
	
SELECT
    funcionario.funcionario as "Funcion??rio",
    departamento.departamento as "Departamento",
    rel.data as "Data",
    loja.nome as "Loja"
FROM
	"Funcionario_Departamento" rel
INNER JOIN  
    "Funcionario" funcionario
ON funcionario.codfuncionario = rel.codfuncionario
INNER JOIN
  "Loja" loja
ON funcionario.codloja = loja.codloja
INNER JOIN
  "Departamento" departamento
ON departamento.coddepartamento = rel.coddepartamento
	WHERE LOWER(funcionario.funcionario) LIKE LOWER('%marg%')
	ORDER BY rel.data DESC;
	
--> GROUP BY
SELECT categoria.categoria, COUNT(*) FROM "Produto" AS produto 
INNER JOIN "Categoria" AS categoria ON produto.codcategoria = categoria.codcategoria    
GROUP BY produto.codcategoria, categoria.categoria
ORDER BY categoria.categoria ASC;

SELECT transportadora.transportadora, COUNT(*) FROM "Entrada" AS entrada 
INNER JOIN "Transportadora" AS transportadora ON entrada.codtransportadora = transportadora.codtransportadora  
GROUP BY entrada.codtransportadora, transportadora.transportadora
ORDER BY transportadora.transportadora ASC;

--> HAVING
SELECT categoria.categoria, COUNT(*) FROM "Produto" AS produto 
INNER JOIN "Categoria" AS categoria ON produto.codcategoria = categoria.codcategoria    
GROUP BY produto.codcategoria, categoria.categoria
HAVING COUNT(*) > 2
ORDER BY categoria.categoria ASC;

SELECT transportadora.transportadora, COUNT(*) FROM "Entrada" AS entrada 
INNER JOIN "Transportadora" AS transportadora ON entrada.codtransportadora = transportadora.codtransportadora  
GROUP BY entrada.codtransportadora, transportadora.transportadora
HAVING COUNT(*) > 3
ORDER BY transportadora.transportadora ASC;

--> UNION, UNION ALL, INTERSECT, EXCEPT
SELECT dataped FROM "Entrada" WHERE dataped < '2022-11-20' UNION SELECT dataped FROM "Entrada" WHERE dataped < '2022-12-20';
SELECT dataped FROM "Entrada" WHERE dataped > '2022-11-10' UNION SELECT dataped FROM "Entrada" WHERE dataped > '2022-08-20';
SELECT dataped FROM "Entrada" WHERE dataped > '2022-11-10' UNION ALL SELECT dataped FROM "Entrada" WHERE dataped > '2022-08-20';
SELECT dataped FROM "Entrada" WHERE dataped < '2022-11-20' UNION ALL SELECT dataped FROM "Entrada" WHERE dataped < '2022-12-20';
SELECT dataped FROM "Entrada" WHERE dataped > '2022-11-10' INTERSECT SELECT dataped FROM "Entrada" WHERE dataped > '2022-08-20';
SELECT dataped FROM "Entrada" WHERE dataped < '2022-11-20' INTERSECT SELECT dataped FROM "Entrada" WHERE dataped < '2022-12-20';
SELECT dataped FROM "Entrada" WHERE dataped > '2022-08-20' EXCEPT SELECT dataped FROM "Entrada" WHERE dataped > '2022-11-10';
SELECT dataped FROM "Entrada" WHERE dataped < '2022-12-20' EXCEPT SELECT dataped FROM "Entrada" WHERE dataped < '2022-11-20';
*/