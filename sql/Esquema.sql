
--Tabela de Pais, não tem dependencia de outras tabelas
create table pais(
    nome varchar(60),
    continente varchar(10) not null,
    capital varchar(100) not null,
    lingua varchar(60),
    CONSTRAINT PK_PAIS PRIMARY KEY (NOME), --    <--- PRIMARY KEY
    CONSTRAINT CHECK_PAIS_CONTINENTE CHECK (UPPER(CONTINENTE) IN ('AMERICA','EUROPA','ASIA','AFRICA','OCEANIA','ANTARTIDA')) --     <-- CHECK PARA VERIFICAR SE O CONTINENTE E UM CONTINENTE VALIDO
);

-- Table de Prestador de Servico, só usa FK de pais
create table prestadorservico(
    email varchar(256),
    nome varchar(100) not null,
    senha varchar(100) not null,
    pais varchar(60) not null,
    CONSTRAINT PK_PRESTADOR PRIMARY KEY (EMAIL), --    <--- PRIMARY KEY
    CONSTRAINT FK_PRESTADOR_PAIS FOREIGN KEY (PAIS) REFERENCES PAIS (NOME), --    <--- FOREIGN KEY
    CONSTRAINT CHECK_PRESTADOR_EMAIL CHECK(EMAIL LIKE '%_@__%.__%')  --     <-- CHECA SE O EMAIL TEM UM FORMATO VÁLIDO
);

--Table de Area de Atuacao, só usa FK de PrestadorServico
create table areaatuacao(
    prestador varchar(256),
    area varchar(256),
    CONSTRAINT PK_AREA PRIMARY KEY (PRESTADOR,AREA), --    <--- PRIMARY KEY
    CONSTRAINT FK_AREA_PRESTADOR FOREIGN KEY (PRESTADOR) REFERENCES PRESTADORSERVICO (EMAIL) --    <--- FOREIGN KEY
);

--Table de Servico, usa FK de PrestadorServico e de Pais
create table servico(
    prestador varchar(256),
    nome varchar(100),
    pais varchar(60) not null,
    descricao varchar(256),
    cidade varchar(100) not null,
    estado varchar(100) not null,
    rua varchar(100),
    numero varchar(10), --    <-- Foi deixado como varchar para atender números do tipo 320A ou algo assim
    complemento varchar(256),
    CONSTRAINT PK_SERVICO PRIMARY KEY (PRESTADOR,NOME), --    <--- PRIMARY KEY
    CONSTRAINT FK_SERVICO_PRESTADOR FOREIGN KEY (PRESTADOR) REFERENCES PRESTADORSERVICO (EMAIL), --    <--- FOREIGN KEY
    CONSTRAINT FK_SERVICO_PAIS FOREIGN KEY (PAIS) REFERENCES PAIS (NOME) --    <--- FOREIGN KEY
);

--Table de Locacao de Equipamento, usa FK de Servico
create table locacaoequip(
    prestador varchar(256),
    nomeservico varchar(100),
    nomeequip varchar(100) not null,
    descricao varchar(256),
    valorequip float(3) not null,
    categoria varchar(60),
    quantdisp number not null   ,
    CONSTRAINT PK_LOCACAO PRIMARY KEY (PRESTADOR,NOMESERVICO), --    <--- PRIMARY KEY
    CONSTRAINT FK_LOCACAO_SERVICO FOREIGN KEY (PRESTADOR,NOMESERVICO) REFERENCES SERVICO (PRESTADOR,NOME), --    <--- FOREIGN KEY
    CONSTRAINT UN_LOCACAO UNIQUE (NOMEEQUIP), --    <--- UNIQUE
    CONSTRAINT CHECK_LOCACAO_NEG CHECK(VALOREQUIP >= 0 AND QUANTDISP >= 0) --   <-- Preço e quantidade não pode ser negativo
);

--Table de Tipo de Serviço, usa FK de Servico
create table tiposervico(
    prestador varchar(256),
    nomeservico varchar(100),
    tipo varchar(100),
    CONSTRAINT PK_TIPO PRIMARY KEY (PRESTADOR,NOMESERVICO,TIPO), --    <--- PRIMARY KEY
    CONSTRAINT FK_TIPO_SERVICO FOREIGN KEY (PRESTADOR,NOMESERVICO) REFERENCES SERVICO (PRESTADOR,NOME), --    <--- FOREIGN KEY
    CONSTRAINT CHECK_TIPOSERV_TIPO CHECK(UPPER(TIPO) IN ('ATIVIDADE', 'LOCACAO')) --  <-- CHECA SE O TIPO É LOCAÇÃO OU ATIVIDADE
);

--Table de Atividade, usa FK de Servico
create table atividade(
    prestador varchar(256),
    nomeservico varchar(100),
    valoratividade float(3) not null,
    CONSTRAINT PK_ATIVIDADE PRIMARY KEY (PRESTADOR,NOMESERVICO), --    <--- PRIMARY KEY
    CONSTRAINT FK_ATIVIDADE_SERVICO FOREIGN KEY (PRESTADOR,NOMESERVICO) REFERENCES SERVICO (PRESTADOR,NOME), --    <--- FOREIGN KEY
    CONSTRAINT CHECK_ATIVIDADE_NEG CHECK(VALORATIVIDADE >= 0) --   <-- Preço não pode ser negativo
);

--Table de Restrições, usa FK de Servico
create table restricoes(
    prestador varchar(256),
    nomeservico varchar(100),
    restricao varchar(100),
    CONSTRAINT PK_RESTRICAO PRIMARY KEY (PRESTADOR,NOMESERVICO,RESTRICAO), --    <--- PRIMARY KEY
    CONSTRAINT FK_RESTRICAO_SERVICO FOREIGN KEY (PRESTADOR,NOMESERVICO) REFERENCES SERVICO (PRESTADOR,NOME) --    <--- FOREIGN KEY
);

--Table de Turista, só usa FK de pais
create table turista(
    email varchar(256),
    nome varchar(100) not null,
    senha varchar(100) not null,
    pais varchar(60) not null,
    CONSTRAINT PK_TURISTA PRIMARY KEY (EMAIL), --    <--- PRIMARY KEY
    CONSTRAINT FK_TURISTA_PAIS FOREIGN KEY (PAIS) REFERENCES PAIS (NOME), --    <--- FOREIGN KEY
    CONSTRAINT CHECK_TURISTA_EMAIL CHECK(EMAIL LIKE '%_@__%.__%')  --     <-- CHECA SE O EMAIL TEM UM FORMATO VÁLIDO
);

--Table de Grupo, só usa FK de Turista
create table grupo(
    administrador varchar(256),
    nome varchar(100),
    descricao varchar(256),
    CONSTRAINT PK_GRUPO PRIMARY KEY (ADMINISTRADOR,NOME),  --    <--- PRIMARY KEY
    CONSTRAINT FK_GRUPO_TURISTA FOREIGN KEY (ADMINISTRADOR) REFERENCES TURISTA (EMAIL) --    <--- FOREIGN KEY
);

--Table de Membro de um Grupo, usa FK de Grupo e de Turista
create table membrogrupo(
    admingrupo varchar(256),
    nomegrupo varchar(100),
    membro varchar(256),
    CONSTRAINT PK_MEMBRO PRIMARY KEY (ADMINGRUPO,NOMEGRUPO,MEMBRO),  --    <--- PRIMARY KEY
    CONSTRAINT FK_MEMBRO_GRUPO FOREIGN KEY (ADMINGRUPO,NOMEGRUPO) REFERENCES GRUPO (ADMINISTRADOR,NOME), --    <--- FOREIGN KEY
    CONSTRAINT FK_MEMBRO_TURISTA FOREIGN KEY (MEMBRO) REFERENCES TURISTA (EMAIL) --    <--- FOREIGN KEY
);

--Table de Viagem, não tem dependencias de outras tabelas
create table viagem(
    id NUMBER,
    admingrupo varchar(256) not null,
    nomegrupo varchar(100) not null,
    dataida date not null,
    duracao number not null,
    CONSTRAINT PK_VIAGEM PRIMARY KEY (id),  --    <--- PRIMARY KEY
    CONSTRAINT UN_VIAGEM UNIQUE (ADMINGRUPO,NOMEGRUPO,DATAIDA), --    <--- UNIQUE
    CONSTRAINT CHECK_VIAGEM_NEG CHECK(DURACAO >= 0 AND ID >= 0) --   <-- Duração e Id não pode ser negativo
);

--Table de Hotel, só usa FK de Pais
create table hotel(
    pais varchar(60),
    registro varchar(50),
    nome varchar(100) not null,
    cidade varchar(100) not null,
    estado varchar(100) not null,
    rua varchar(100) not null,
    numero varchar(10) not null, --    <-- Foi deixado como varchar para atender números do tipo 320A ou algo assim
    complemento varchar(256),
    CONSTRAINT PK_HOTEL PRIMARY KEY (PAIS,REGISTRO), --    <--- PRIMARY KEY
    CONSTRAINT FK_HOTEL_PAIS FOREIGN KEY (PAIS) REFERENCES PAIS (NOME) --    <--- FOREIGN KEY
);

--Table de quarto, só usa FK de Hotel
create table quarto(
    id number,
    paishotel varchar(60) not null,
    registrohotel varchar(50) not null,
    numero varchar(10) not null, -- Coloquei varchar(10) para quartos tipo 10B ou algo assim
    categoria varchar(32),
    preco float(3) not null,
    CONSTRAINT PK_QUARTO PRIMARY KEY (ID), --    <--- PRIMARY KEY
    CONSTRAINT UN_QUARTO UNIQUE (PAISHOTEL,REGISTROHOTEL,NUMERO), --    <--- UNIQUE
    CONSTRAINT FK_QUARTO_HOTEL FOREIGN KEY (PAISHOTEL,REGISTROHOTEL) REFERENCES HOTEL (PAIS,REGISTRO), --    <--- FOREIGN KEY
    CONSTRAINT CHECK_QUARTO_NEG CHECK(PRECO >= 0 and id >= 0) --   <-- Preço e Id não pode ser negativo
);

--Table de Hospedagem, usa FK de Quarto e de Viagem
create table hospedagem(
    idviagem number,
    idQuarto number,
    datareserva date,
    duracao number,
    comentario varchar(200),
    nota number,
    valortotal float(3) not null,
    CONSTRAINT PK_HOSPEDAGEM PRIMARY KEY (IDVIAGEM,IDQUARTO,DATARESERVA,DURACAO), --    <--- PRIMARY KEY
    CONSTRAINT FK_HOSPEDAGEM_QUARTO FOREIGN KEY (IDQUARTO) REFERENCES QUARTO (ID), --    <--- FOREIGN KEY
    CONSTRAINT FK_HOSPEDAGEM_VIAGEM FOREIGN KEY (IDVIAGEM) REFERENCES VIAGEM (ID), --    <--- FOREIGN KEY
    CONSTRAINT CHECK_HOSPEDAGEM_NEG CHECK(DURACAO >= 0 AND VALORTOTAL >= 0 AND IDVIAGEM >= 0 AND IDQUARTO >= 0), --   <-- Duração, Preço e Id não pode ser negativo
    CONSTRAINT CHECK_HOSPEDAGEM_NOTA CHECK(NOTA >= 0 AND NOTA <= 5) --   <-- Nota é de 0 a 5 estrelas
);

--Table de Restaurante, usa FK de Pais
create table restaurante(
    pais varchar(60),
    registro varchar(50),
    nome varchar(100) not null,
    cidade varchar(100) not null,
    estado varchar(100) not null,
    rua varchar(100) not null,
    numero varchar(10) not null, -- Coloquei varchar(10) para quartos tipo 10B ou algo assim
    complemento varchar(256),
    CONSTRAINT PK_RESTAURANTE PRIMARY KEY (PAIS,REGISTRO), --    <--- PRIMARY KEY
    CONSTRAINT FK_RESTAURANTE_PAIS FOREIGN KEY (PAIS) REFERENCES PAIS (NOME) --    <--- FOREIGN KEY
);

--Table de Alimentação, usa FK de Viagem e de Restaurante
create table alimentacao(
    idviagem number,
    pais varchar(60),
    restaurante varchar(50),
    datavisita date,
    comentario varchar(200),
    nota number,
    CONSTRAINT PK_ALIMENTACAO PRIMARY KEY (IDVIAGEM,PAIS,RESTAURANTE,DATAVISITA), --    <--- PRIMARY KEY
    CONSTRAINT FK_ALIMENTACAO_RESTAURANTE FOREIGN KEY (PAIS,RESTAURANTE) REFERENCES RESTAURANTE (PAIS,REGISTRO), --    <--- FOREIGN KEY
    CONSTRAINT FK_ALIMENTACAO_VIAGEM FOREIGN KEY (IDVIAGEM) REFERENCES VIAGEM (ID),  --    <--- FOREIGN KEY
    CONSTRAINT CHECK_ALIMENTACAO_NEG CHECK(IDVIAGEM >= 0), --   <-- Id não pode ser negativo
    CONSTRAINT CHECK_ALIMENTACAO_NOTA CHECK(NOTA >= 0 AND NOTA <= 5) --   <-- Nota é de 0 a 5 estrelas
);

--Table de Transporte, usa FK de Viagem e de Pais
create table transporte(
    paisorigem varchar(60),
    paisdestino varchar(60),
    empresa varchar(60),
    datatransporte date,
    hora char(8),
    duracao number,
    valor float(3) not null,
    modalidade varchar(32),
    idviagem number not null,
    CONSTRAINT PK_TRANSPORTE PRIMARY KEY (PAISORIGEM,PAISDESTINO,EMPRESA,DATATRANSPORTE,HORA,DURACAO), --    <--- PRIMARY KEY
    CONSTRAINT FK_TRANSPORTE_PAISORIGEM FOREIGN KEY (PAISORIGEM) REFERENCES PAIS (NOME), --    <--- FOREIGN KEY
    CONSTRAINT FK_TRANSPORTE_PAISDESTINO FOREIGN KEY (PAISDESTINO) REFERENCES PAIS (NOME), --    <--- FOREIGN KEY
    CONSTRAINT FK_TRANSPORTE_VIAGEM FOREIGN KEY (IDVIAGEM) REFERENCES VIAGEM (ID),  --    <--- FOREIGN KEY
    CONSTRAINT CHECK_TRANSPORTE_PAISES CHECK(UPPER(PAISORIGEM)!= UPPER(PAISDESTINO)), --   <-- Checa se o Pais de Origem é diferente do de Destino
    CONSTRAINT CHECK_TRANSPORTE_NEG CHECK(DURACAO >= 0 AND VALOR >= 0 AND IDVIAGEM >= 0) --   <-- Duração, Preço e Id não pode ser negativo
);

--Table de Contrato de Servico, usa FK de Grupo, Servico e Viagem
create table contratoservico(
    admingrupo varchar(256),
    nomegrupo varchar(100),
    prestador varchar(256),
    nomeservico varchar(100),
    datainicio date,
    horainicio char(8),
    datafim date not null,
    horafim char(8) not null,
    comentario varchar(200),
    nota number,
    numparticipantes number not null,
    numequipamentos number not null,
    valortotal float(3) not null,
    idviagem number not null,
    CONSTRAINT PK_CONTRATO PRIMARY KEY (ADMINGRUPO,NOMEGRUPO,PRESTADOR,NOMESERVICO,DATAINICIO,HORAINICIO), --    <--- PRIMARY KEY
    CONSTRAINT FK_CONTRATO_GRUPO FOREIGN KEY (ADMINGRUPO,NOMEGRUPO) REFERENCES GRUPO (ADMINISTRADOR,NOME), --    <--- FOREIGN KEY
    CONSTRAINT FK_CONTRATO_SERVICO FOREIGN KEY (PRESTADOR,NOMESERVICO) REFERENCES SERVICO (PRESTADOR,NOME), --    <--- FOREIGN KEY
    CONSTRAINT FK_CONTRATO_VIAGEM FOREIGN KEY (IDVIAGEM) REFERENCES VIAGEM (ID),  --    <--- FOREIGN KEY
    CONSTRAINT CHECK_CONRATO_DATA CHECK(DATAINICIO <= DATAFIM),--   <-- Checa se a a data de inicio é anterior a data de fim
    CONSTRAINT CHECK_CONTRATO_NEG CHECK(NUMPARTICIPANTES >= 0 AND NUMEQUIPAMENTOS >= 0 AND IDVIAGEM >= 0 AND VALORTOTAL >= 0), --   <-- Numero de Participantes, Numero de Equipamentos, Preço e Id não pode ser negativo
    CONSTRAINT CHECK_CONTRATO_NOTA CHECK(NOTA >= 0 AND NOTA <= 5) --   <-- Nota é de 0 a 5 estrelas
);

-- Trigger para o id funcionar automaticamente
CREATE SEQUENCE viagem_seq START WITH 1;
CREATE OR REPLACE TRIGGER viagem_trig 
BEFORE INSERT ON viagem
FOR EACH ROW
BEGIN
  SELECT viagem_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

-- Trigger para o id funcionar automaticamente
CREATE SEQUENCE quarto_seq START WITH 1;
CREATE OR REPLACE TRIGGER quarto_trig 
BEFORE INSERT ON quarto
FOR EACH ROW
BEGIN
  SELECT quarto_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;