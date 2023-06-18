
/**
Dato il seguente schema 

DISCO(NoSerie, TitoloAlbum, Anno, Prezzo)
CONTIENE(NroSerieDisco, CodiceReg, NroProg)
ESECUZIONE(CodiceReg, TitoloCanz, Anno)
AUTORE(Nome, TitoloCanzone)
CANTANTE(NomeCantante, CodiceReg)

**/

-- definizione tabelle --
CREATE DATABASE EsercitazioneD5;

CREATE TABLE Disco (
NroSerieDisco INT,
TitoloAlbum VARCHAR(100),
Anno INT,
Prezzo MONEY,
CONSTRAINT PK_NroSerieDisco PRIMARY KEY (NroSerieDisco));

CREATE TABLE Esecuzione (
CodiceReg INT,
TitoloCanz VARCHAR(25),
Anno INT,
CONSTRAINT PK_CodiceReg PRIMARY KEY (CodiceReg));

CREATE TABLE Contiene (
NroSerieDisco INT,
CodiceReg INT,
NroProg AS CONCAT(NroSerieDisco, '-', CodiceReg),
CONSTRAINT FK_Contiene_Disco_NroSerie FOREIGN KEY (NroSerieDisco)
	REFERENCES Disco (NroSerieDisco),
CONSTRAINT FK_Contiene_Esecuzione_CodiceReg FOREIGN KEY (CodiceReg)
	REFERENCES Esecuzione (CodiceReg));

ALTER TABLE Contiene
ADD CONSTRAINT PK_NroProg PRIMARY KEY (NroProg);

CREATE TABLE Cantante (
IDCantante	INT,
NomeCantante VARCHAR(25),
CodiceReg INT,
CONSTRAINT PK_IDCantante_CodiceReg PRIMARY KEY (IDCantante, CodiceReg));

-- opzionale, non richiesta
CREATE TABLE Anagrafica (
IDCantante INT, 
NomeCantante VARCHAR(25),
DataNascita DATE,
CONSTRAINT PK_IDCantante PRIMARY KEY (IDCantante));

ALTER TABLE Cantante
ADD CONSTRAINT FK_Cantante_Esecuzione FOREIGN KEY (CodiceReg)
	REFERENCES Esecuzione (CodiceReg);

ALTER TABLE Cantante
ADD CONSTRAINT FK_Cantante_Anagrafica_IDCantante FOREIGN KEY (IDCantante)
	REFERENCES Anagrafica (IDCantante);
	
CREATE TABLE Autore (
IDCantante INT NOT NULL,
NomeCantante VARCHAR(25),
TitoloCanz VARCHAR (25) NOT NULL);

ALTER TABLE Autore 
ADD CONSTRAINT PK_IDCantante_TitoloCanzone PRIMARY KEY (IDCantante, TitoloCanz);

ALTER TABLE Autore 
ADD CONSTRAINT FK_Autore_Anagrafica_IDCantante FOREIGN KEY (IDCantante)
	REFERENCES Anagrafica (IDCantante);



-- inserimento sample data --
INSERT INTO Anagrafica 
VALUES (1, 'Depeche Mode', null), (2, 'David Bowie', null), (3, 'Vasco Rossi', null), (4, 'Freddy Mercury', null)

INSERT INTO Disco
VALUES 
(12345678, 'Violator', 1990, '25,00'), (98765432, 'The Rise and Fall of Ziggy Stardust and the Spiders from Mars', 1972, '25,00')

INSERT INTO Esecuzione 
VALUES (1, 'Halo', 1990), (2, 'Clean', null), (3, 'Starman', 1972), (4, 'Albachiara', 1979), (5, 'Under Pressure', 1981)  

INSERT INTO Contiene 
VALUES  (12345678, 1), (12345678, 2), (98765432, 3)

INSERT INTO Cantante 
VALUES (1, 'Depeche Mode', 1), (1, 'Depeche Mode', 2), (2, 'David Bowie', 3), (3, 'Albachiara', 4),  (2, 'David Bowie', 5)  , (4, 'Freddy Mercury', 5) 

INSERT INTO Autore 
VALUES (2, 'David Bowie', 'Starman'), (3, 'Vasco Rossi', 'Albachiara'), (4, 'Freddy Mercury', 'Under Pressur')


-- determinare i cantautori (persone che hanno cantato e scritto la stessa canzone) il cui nome inizia per D
-- intersezione degli insiemi Cantante e Autore: i valori in comune soddisfano la richiesta
	-- eseguite insieme, per comodità vostra nell'epslorare i risultati, le tre SELECT 
SELECT * FROM Cantante
SELECT * FROM Autore

SELECT c.*, a.*
FROM Cantante c
INNER JOIN Autore a
ON c.IDCantante = a.IDCantante
WHERE c.NomeCantante LIKE 'D%'

-- determinare i titoli dei dischi che contengono canzoni di cui non si conosce l'anno di registrazione
	-- eseguite insieme, per comodità vostra nell'epslorare i risultati, le quattro SELECT 
SELECT * FROM Disco
SELECT * FROM Contiene
SELECT * FROM ESECUZIONE

SELECT 
	d.TitoloAlbum		TitoloDisco
	, d.Anno			AnnoDisco
	, c.CodiceReg		CodiceRegistrazioneBrano
	, e.CodiceReg		CodiceRegistrazioneBrano
	, e.TitoloCanz		TitoloBrano
	, e.Anno			AnnoBrano
FROM DISCO d
INNER JOIN CONTIENE c
ON d.NroSerieDisco = c.NroSerieDisco
INNER JOIN ESECUZIONE e
ON c. CodiceReg = e.CodiceReg
WHERE e.Anno is null

-- determinare i cantanti che hanno sempre registrato canzoni come solisti

SELECT * FROM Cantante

SELECT CodiceReg, COUNT(NomeCantante)
FROM Cantante AS c1
GROUP BY CodiceReg

select NomeCantante
from CANTANTE
where NomeCantante not in ( select S1.NomeCantante
       from CANTANTE as S1 join ESECUZIONE E on E.CodiceReg=S1.CodiceReg
            join CANTANTE as S2 on E.CodiceReg=S2.CodiceReg  
       where S1.NomeCantante<> S2.NomeCantante)

-- solo per visualizzare la stessa tabella "affiancata"  
SELECT c1.NomeCantante AS c1NomeCantante, c1.CodiceReg AS c1CodiceReg, c2.NomeCantante AS c2NomeCantante, c1.CodiceReg AS c2CodiceReg
FROM Cantante c1
INNER JOIN Cantante c2
ON c1.CodiceReg = c2.CodiceReg
and c1.IDCantante = c2.IDCantante
and c1.NomeCantante = c2.NomeCantante

-- 1 STEP: Otteniamo le combinazioni, come sono abbinati i cantanti, le associazioni..
SELECT c1.NomeCantante, c1.CodiceReg, c2.NomeCantante, c2.CodiceReg
FROM Cantante AS c1
INNER JOIN Cantante as c2 ON  c1.CodiceReg = c2.CodiceReg
	-- di questi risultato, sono utili le combinazioni di cantanti diversi (sono abbinati, hanno realizzato una stessa registrazione)

-- 2 STEP: filtriamo le combinazioni di valori (cantanti) diversi
SELECT c1.NomeCantante, c1.CodiceReg, c2.NomeCantante, c2.CodiceReg
FROM Cantante AS c1
INNER JOIN Cantante as c2 ON  c1.CodiceReg = c2.CodiceReg
WHERE c1.NomeCantante <> c2.NomeCantante

-- 3 STEP: passiamo questi valori alla query esterna in modo tale da escluderli
SELECT DISTINCT IDCantante, NomeCantante, CodiceReg
FROM Cantante 
WHERE IDCantante NOT IN (
SELECT c1.IDCantante
FROM Cantante AS c1
INNER JOIN Cantante as c2 ON  c1.CodiceReg = c2.CodiceReg
WHERE c1.NomeCantante <> c2.NomeCantante)