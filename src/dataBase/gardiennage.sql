CREATE DATABASE gardiennage_animaux_GLO2005_2026;


SHOW DATABASES;

USE gardiennage_animaux_GLO2005_2026;
SHOW TABLES;

CREATE TABLE Utilisateur (
    idUtilisateur char(5) PRIMARY KEY,
    nom varchar(100),
    prenom varchar(100),
    email varchar(100) UNIQUE,
    numTelephone varchar(10) UNIQUE,
    adresse varchar(100),
    dateInscription DATE
);

CREATE TABLE Animal (
    idAnimal char(5) PRIMARY KEY,
    nom varchar(50),
    espece varchar(50),
    race varchar(50),
    age int(2),
    poids int(3),
    idProprietaire char(5),
    FOREIGN KEY(idProprietaire) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE GardienAnimaux (
    idGardien char(5) PRIMARY KEY,
    idUtilisateur char(5),
    experience int(2),
    tarifHoraire int(3),
    description varchar(1000),
    evaluationMoyenne int(3), -- A modifier --> Fonction calcul moyenne
    FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE Reservation(
    idReservation char(5) PRIMARY KEY,
    dateDebut DATE,
    dateFin DATE,
    statut ENUM('TERMINE', 'EN_COURS'),
    prixTotal int(5),
    idClient char(5),
    idGardien char(5),
    idAnimal char(5),
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY (idAnimal) REFERENCES Animal(idAnimal),
    FOREIGN KEY(idClient) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE Paiement(
    idPaiement char(5) PRIMARY KEY,
    montant int(5),
    datePaiement DATE,
    methodePaiement ENUM('Crédit', 'Débit', 'Espèce'),
    idReservation char(5),
    FOREIGN KEY(idReservation) REFERENCES Reservation(idReservation)
);

CREATE TABLE Avis(
    idAvis char(5) PRIMARY KEY,
    note int(3),
    commentaire varchar(1000),
    dateAvis DATE,
    idProprietaire char(5),
    idGardien char(5),
    FOREIGN KEY(idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY(idProprietaire) REFERENCES Utilisateur(idUtilisateur)
);

ALTER TABLE Utilisateur
ADD motDePasse varchar(20);

INSERT INTO Utilisateur (idUtilisateur, nom, prenom, email, numTelephone, adresse, dateInscription, motDePasse)
VALUES
('U0001','Tremblay','Jeremie','jeremie.tremblay@gmail.com','5814432001','123 rue de la Fontaine','2020-03-15','PwdU0001A'),
('U0002','Gagnon','Alice','alice.gagnon@gmail.com','5814432002','45 rue Principale','2021-06-18','PwdU0002B'),
('U0003','Roy','Marc','marc.roy@gmail.com','5814432003','78 rue du Parc','2022-01-10','PwdU0003C'),
('U0004','Cote','Sophie','sophie.cote@gmail.com','5814432004','12 rue des Pins','2023-09-05','PwdU0004D'),
('U0005','Bouchard','David','david.bouchard@gmail.com','5814432005','90 avenue Royale','2024-11-18','PwdU0005E'),
('U0006','Pelletier','Julie','julie.pelletier@gmail.com','5814432006','33 rue Saint-Jean','2020-07-22','PwdU0006F'),
('U0007','Lavoie','Thomas','thomas.lavoie@gmail.com','5814432007','88 rue Commerciale','2021-12-01','PwdU0007G'),
('U0008','Fortin','Emma','emma.fortin@gmail.com','5814432008','17 rue Centrale','2022-04-14','PwdU0008H'),
('U0009','Leclerc','Alex','alex.leclerc@gmail.com','5814432009','56 rue du Lac','2023-02-28','PwdU0009I'),
('U0010','Bergeron','Nicolas','nicolas.bergeron@gmail.com','5814432010','101 rue Maple','2025-08-19','PwdU0010J'),

('U0011','Simard','Chloe','chloe.simard@gmail.com','5814432011','22 rue des Saules','2020-10-10','PwdU0011K'),
('U0012','Morin','Antoine','antoine.morin@gmail.com','5814432012','64 rue de la Gare','2021-03-03','PwdU0012L'),
('U0013','Gauthier','Laura','laura.gauthier@gmail.com','5814432013','77 rue Bellevue','2022-06-17','PwdU0013M'),
('U0014','Paquette','Kevin','kevin.paquette@gmail.com','5814432014','9 rue du Moulin','2023-01-25','PwdU0014N'),
('U0015','Rousseau','Mia','mia.rousseau@gmail.com','5814432015','18 rue du Centre','2024-05-09','PwdU0015O'),
('U0016','Caron','Louis','louis.caron@gmail.com','5814432016','39 rue des Erables','2025-09-30','PwdU0016P'),
('U0017','Beaulieu','Sarah','sarah.beaulieu@gmail.com','5814432017','120 rue St-Paul','2026-02-14','PwdU0017Q'),
('U0018','Blais','Ethan','ethan.blais@gmail.com','5814432018','55 rue des Champs','2020-11-11','PwdU0018R'),
('U0019','Martel','Zoé','zoe.martel@gmail.com','5814432019','41 rue du Nord','2021-08-08','PwdU0019S'),
('U0020','Lapointe','William','william.lapointe@gmail.com','5814432020','73 rue des Fleurs','2022-12-12','PwdU0020T'),

('U0021','Girard','Olivier','olivier.girard@gmail.com','5814432021','14 rue du Port','2023-03-15','PwdU0021U'),
('U0022','Fournier','Camille','camille.fournier@gmail.com','5814432022','66 rue des Champs','2024-07-20','PwdU0022V'),
('U0023','Dupont','Raphael','raphael.dupont@gmail.com','5814432023','88 rue du Marché','2020-05-01','PwdU0023W'),
('U0024','Gosselin','Lea','lea.gosselin@gmail.com','5814432024','32 rue des Bois','2021-09-09','PwdU0024X'),
('U0025','Poulin','Mathis','mathis.poulin@gmail.com','5814432025','10 rue St-Michel','2022-10-10','PwdU0025Y'),
('U0026','Desjardins','Clara','clara.desjardins@gmail.com','5814432026','99 rue des Lilas','2023-06-06','PwdU0026Z'),
('U0027','Nguyen','Hugo','hugo.nguyen@gmail.com','5814432027','21 rue du Soleil','2024-04-04','PwdU0027A1'),
('U0028','Tran','Jade','jade.tran@gmail.com','5814432028','13 rue des Érables','2025-01-15','PwdU0028B1'),
('U0029','Lefebvre','Maxime','maxime.lefebvre@gmail.com','5814432029','77 rue du Centre','2026-03-03','PwdU0029C1'),
('U0030','Pelletier','Anna','anna.pelletier@gmail.com','5814432030','45 rue Bellevue','2020-08-18','PwdU0030D1'),

('U0031','Cloutier','Gabriel','gabriel.cloutier@gmail.com','5814432031','56 rue des Cèdres','2021-02-02','PwdU0031E1'),
('U0032','Boucher','Noemie','noemie.boucher@gmail.com','5814432032','12 rue des Pins','2022-03-11','PwdU0032F1'),
('U0033','Couture','Simon','simon.couture@gmail.com','5814432033','34 rue St-Louis','2023-04-22','PwdU0033G1'),
('U0034','Leduc','Victoria','victoria.leduc@gmail.com','5814432034','90 rue des Fleurs','2024-05-05','PwdU0034H1'),
('U0035','Marchand','Benjamin','benjamin.marchand@gmail.com','5814432035','18 rue du Parc','2025-06-16','PwdU0035I1'),
('U0036','Legault','Lisa','lisa.legault@gmail.com','5814432036','44 rue Royale','2026-07-07','PwdU0036J1'),
('U0037','Gervais','Paul','paul.gervais@gmail.com','5814432037','27 rue du Lac','2020-09-09','PwdU0037K1'),
('U0038','Vigneault','Florence','florence.vigneault@gmail.com','5814432038','61 rue Centrale','2021-10-10','PwdU0038L1'),
('U0039','Proulx','Yann','yann.proulx@gmail.com','5814432039','70 rue du Nord','2022-11-11','PwdU0039M1'),
('U0040','Blanchet','Maude','maude.blanchet@gmail.com','5814432040','15 rue Maple','2023-12-12','PwdU0040N1'),

('U0041','Chevalier','Samuel','samuel.chevalier@gmail.com','5814432041','22 rue des Pins','2024-01-20','PwdU0041O1'),
('U0042','Arsenault','Eva','eva.arsenault@gmail.com','5814432042','88 rue St-Paul','2025-02-21','PwdU0042P1'),
('U0043','Bégin','Adam','adam.begin@gmail.com','5814432043','33 rue des Champs','2026-03-22','PwdU0043Q1'),
('U0044','Lacroix','Amelie','amelie.lacroix@gmail.com','5814432044','54 rue du Port','2020-04-23','PwdU0044R1'),
('U0045','Michaud','Theo','theo.michaud@gmail.com','5814432045','11 rue des Cèdres','2021-05-24','PwdU0045S1'),
('U0046','Ouellet','Iris','iris.ouellet@gmail.com','5814432046','98 rue Centrale','2022-06-25','PwdU0046T1'),
('U0047','Nadeau','Laurent','laurent.nadeau@gmail.com','5814432047','76 rue du Soleil','2023-07-26','PwdU0047U1'),
('U0048','Dubois','Isabelle','isabelle.dubois@gmail.com','5814432048','39 rue des Fleurs','2024-08-27','PwdU0048V1'),
('U0049','Hamel','Patrick','patrick.hamel@gmail.com','5814432049','20 rue du Parc','2025-09-28','PwdU0049W1'),
('U0050','Tessier','Marie','marie.tessier@gmail.com','5814432050','5 rue Royale','2026-10-29','PwdU0050X1'),

('U0051','Tremblay','Daniel','daniel.tremblay@gmail.com','5814432051','10 rue des Lilas','2020-01-05','PwdU0051A2'),
('U0052','Gagnon','Jeremie','jeremie.gagnon@gmail.com','5814432052','11 rue des Érables','2021-02-06','PwdU0052B2'),
('U0053','Roy','Alice','alice.roy@gmail.com','5814432053','12 rue du Lac','2022-03-07','PwdU0053C2'),
('U0054','Cote','Marc','marc.cote@gmail.com','5814432054','13 rue Centrale','2023-04-08','PwdU0054D2'),
('U0055','Bouchard','Sophie','sophie.bouchard@gmail.com','5814432055','14 rue du Nord','2024-05-09','PwdU0055E2'),
('U0056','Pelletier','David','david.pelletier@gmail.com','5814432056','15 rue St-Jean','2025-06-10','PwdU0056F2'),
('U0057','Lavoie','Julie','julie.lavoie@gmail.com','5814432057','16 rue du Port','2026-07-11','PwdU0057G2'),
('U0058','Fortin','Thomas','thomas.fortin@gmail.com','5814432058','17 rue des Champs','2020-08-12','PwdU0058H2'),
('U0059','Leclerc','Emma','emma.leclerc@gmail.com','5814432059','18 rue Maple','2021-09-13','PwdU0059I2'),
('U0060','Bergeron','Alex','alex.bergeron@gmail.com','5814432060','19 rue Royale','2022-10-14','PwdU0060J2'),

('U0061','Simard','Nicolas','nicolas.simard@gmail.com','5814432061','20 rue du Soleil','2023-11-15','PwdU0061K2'),
('U0062','Morin','Chloe','chloe.morin@gmail.com','5814432062','21 rue Bellevue','2024-12-16','PwdU0062L2'),
('U0063','Gauthier','Antoine','antoine.gauthier@gmail.com','5814432063','22 rue du Parc','2025-01-17','PwdU0063M2'),
('U0064','Paquette','Laura','laura.paquette@gmail.com','5814432064','23 rue des Pins','2026-02-18','PwdU0064N2'),
('U0065','Rousseau','Kevin','kevin.rousseau@gmail.com','5814432065','24 rue du Lac','2020-03-19','PwdU0065O2'),
('U0066','Caron','Mia','mia.caron@gmail.com','5814432066','25 rue Centrale','2021-04-20','PwdU0066P2'),
('U0067','Beaulieu','Louis','louis.beaulieu@gmail.com','5814432067','26 rue des Fleurs','2022-05-21','PwdU0067Q2'),
('U0068','Blais','Sarah','sarah.blais@gmail.com','5814432068','27 rue St-Paul','2023-06-22','PwdU0068R2'),
('U0069','Martel','Ethan','ethan.martel@gmail.com','5814432069','28 rue des Cèdres','2024-07-23','PwdU0069S2'),
('U0070','Lapointe','Zoé','zoe.lapointe@gmail.com','5814432070','29 rue du Nord','2025-08-24','PwdU0070T2'),

('U0071','Girard','William','william.girard@gmail.com','5814432071','30 rue du Port','2026-09-25','PwdU0071U2'),
('U0072','Fournier','Olivier','olivier.fournier@gmail.com','5814432072','31 rue des Champs','2020-10-26','PwdU0072V2'),
('U0073','Dupont','Camille','camille.dupont@gmail.com','5814432073','32 rue du Soleil','2021-11-27','PwdU0073W2'),
('U0074','Gosselin','Raphael','raphael.gosselin@gmail.com','5814432074','33 rue Maple','2022-12-28','PwdU0074X2'),
('U0075','Poulin','Lea','lea.poulin@gmail.com','5814432075','34 rue Royale','2023-01-29','PwdU0075Y2'),
('U0076','Desjardins','Mathis','mathis.desjardins@gmail.com','5814432076','35 rue Centrale','2024-02-01','PwdU0076Z2'),
('U0077','Nguyen','Clara','clara.nguyen@gmail.com','5814432077','36 rue du Lac','2025-03-02','PwdU0077A3'),
('U0078','Tran','Hugo','hugo.tran@gmail.com','5814432078','37 rue des Pins','2026-04-03','PwdU0078B3'),
('U0079','Lefebvre','Jade','jade.lefebvre@gmail.com','5814432079','38 rue St-Jean','2020-05-04','PwdU0079C3'),
('U0080','Pelletier','Maxime','maxime.pelletier@gmail.com','5814432080','39 rue du Nord','2021-06-05','PwdU0080D3'),

('U0081','Cloutier','Anna','anna.cloutier@gmail.com','5814432081','40 rue du Parc','2022-07-06','PwdU0081E3'),
('U0082','Boucher','Gabriel','gabriel.boucher@gmail.com','5814432082','41 rue Centrale','2023-08-07','PwdU0082F3'),
('U0083','Couture','Noemie','noemie.couture@gmail.com','5814432083','42 rue des Fleurs','2024-09-08','PwdU0083G3'),
('U0084','Leduc','Simon','simon.leduc@gmail.com','5814432084','43 rue du Soleil','2025-10-09','PwdU0084H3'),
('U0085','Marchand','Victoria','victoria.marchand@gmail.com','5814432085','44 rue Maple','2026-11-10','PwdU0085I3'),
('U0086','Legault','Benjamin','benjamin.legault@gmail.com','5814432086','45 rue Royale','2020-12-11','PwdU0086J3'),
('U0087','Gervais','Lisa','lisa.gervais@gmail.com','5814432087','46 rue du Lac','2021-01-12','PwdU0087K3'),
('U0088','Vigneault','Paul','paul.vigneault@gmail.com','5814432088','47 rue Centrale','2022-02-13','PwdU0088L3'),
('U0089','Proulx','Florence','florence.proulx@gmail.com','5814432089','48 rue des Pins','2023-03-14','PwdU0089M3'),
('U0090','Blanchet','Yann','yann.blanchet@gmail.com','5814432090','49 rue du Nord','2024-04-15','PwdU0090N3'),

('U0091','Chevalier','Maude','maude.chevalier@gmail.com','5814432091','50 rue du Port','2025-05-16','PwdU0091O3'),
('U0092','Arsenault','Samuel','samuel.arsenault@gmail.com','5814432092','51 rue des Champs','2026-06-17','PwdU0092P3'),
('U0093','Bégin','Eva','eva.begin@gmail.com','5814432093','52 rue Centrale','2020-07-18','PwdU0093Q3'),
('U0094','Lacroix','Adam','adam.lacroix@gmail.com','5814432094','53 rue Maple','2021-08-19','PwdU0094R3'),
('U0095','Michaud','Amelie','amelie.michaud@gmail.com','5814432095','54 rue Royale','2022-09-20','PwdU0095S3'),
('U0096','Ouellet','Theo','theo.ouellet@gmail.com','5814432096','55 rue du Lac','2023-10-21','PwdU0096T3'),
('U0097','Nadeau','Iris','iris.nadeau@gmail.com','5814432097','56 rue du Nord','2024-11-22','PwdU0097U3'),
('U0098','Dubois','Laurent','laurent.dubois@gmail.com','5814432098','57 rue des Pins','2025-12-23','PwdU0098V3'),
('U0099','Hamel','Isabelle','isabelle.hamel@gmail.com','5814432099','58 rue St-Paul','2026-01-24','PwdU0099W3'),
('U0100','Tessier','Patrick','patrick.tessier@gmail.com','5814432100','59 rue du Soleil','2020-02-25','PwdU0100X3');

SELECT * FROM Utilisateur;

INSERT INTO Animal (idAnimal, nom, espece, race, age, poids, idProprietaire) VALUES
-- CHIENS (20)
('A0001','Rex','chien','Labrador',5,28,'U0001'),
('A0002','Bella','chien','Beagle',3,12,'U0002'),
('A0003','Max','chien','Husky',6,24,'U0003'),
('A0004','Luna','chien','Golden Retriever',4,30,'U0004'),
('A0005','Rocky','chien','Bulldog',7,22,'U0005'),
('A0006','Maya','chien','Caniche',2,7,'U0006'),
('A0007','Tango','chien','Berger allemand',5,34,'U0007'),
('A0008','Nala','chien','Chihuahua',1,3,'U0008'),
('A0009','Oscar','chien','Border Collie',4,20,'U0009'),
('A0010','Simba','chien','Doberman',6,32,'U0010'),
('A0011','Ruby','chien','Labrador',3,27,'U0011'),
('A0012','Zeus','chien','Husky',5,26,'U0012'),
('A0013','Loki','chien','Beagle',2,11,'U0013'),
('A0014','Milo','chien','Golden Retriever',4,29,'U0014'),
('A0015','Nova','chien','Caniche',3,6,'U0015'),
('A0016','Kira','chien','Bulldog',6,23,'U0016'),
('A0017','Baxter','chien','Berger allemand',5,35,'U0017'),
('A0018','Coco','chien','Chihuahua',2,4,'U0018'),
('A0019','Thor','chien','Doberman',7,33,'U0019'),
('A0020','Sunny','chien','Border Collie',4,21,'U0020'),

-- CHATS (20)
('A0021','Minou','chat','Siamois',3,4,'U0021'),
('A0022','Chanel','chat','Maine Coon',5,7,'U0022'),
('A0023','Felix','chat','Bengal',2,5,'U0023'),
('A0024','Lili','chat','Persan',4,6,'U0024'),
('A0025','Moka','chat','Sphynx',3,4,'U0025'),
('A0026','Neko','chat','Siamois',1,3,'U0026'),
('A0027','Shadow','chat','Maine Coon',6,8,'U0027'),
('A0028','BellaCat','chat','Bengal',2,5,'U0028'),
('A0029','Cleo','chat','Persan',5,6,'U0029'),
('A0030','Zara','chat','Sphynx',4,4,'U0030'),
('A0031','Oreo','chat','Siamois',3,4,'U0031'),
('A0032','LunaCat','chat','Maine Coon',2,7,'U0032'),
('A0033','Misty','chat','Bengal',4,5,'U0033'),
('A0034','Snow','chat','Persan',6,6,'U0034'),
('A0035','Pixel','chat','Sphynx',1,3,'U0035'),
('A0036','Jazz','chat','Siamois',5,4,'U0036'),
('A0037','Tigrou','chat','Bengal',3,5,'U0037'),
('A0038','Mia','chat','Maine Coon',4,7,'U0038'),
('A0039','Fiona','chat','Persan',2,6,'U0039'),
('A0040','Neo','chat','Sphynx',3,4,'U0040'),

-- LAPINS (15)
('A0041','Biscuit','lapin','Nain',2,2,'U0041'),
('A0042','Fluffy','lapin','Bélier',3,3,'U0042'),
('A0043','Caramel','lapin','Nain',1,2,'U0043'),
('A0044','Pompom','lapin','Bélier',4,4,'U0044'),
('A0045','Snowy','lapin','Nain',2,1,'U0045'),
('A0046','Coco','lapin','Nain',3,2,'U0046'),
('A0047','Moka','lapin','Bélier',5,4,'U0047'),
('A0048','Litchi','lapin','Nain',1,2,'U0048'),
('A0049','Noisette','lapin','Bélier',2,3,'U0049'),
('A0050','Plume','lapin','Nain',3,2,'U0050'),
('A0051','Bunny','lapin','Nain',2,2,'U0051'),
('A0052','Roux','lapin','Bélier',4,4,'U0052'),
('A0053','Velours','lapin','Nain',1,1,'U0053'),
('A0054','Câlin','lapin','Bélier',3,3,'U0054'),
('A0055','Chouchou','lapin','Nain',2,2,'U0055'),

-- OISEAUX (15)
('A0056','Kiwi','oiseau','Perroquet',3,1,'U0056'),
('A0057','Rio','oiseau','Cacatoès',4,1,'U0057'),
('A0058','Sky','oiseau','Perruche',2,0,'U0058'),
('A0059','Zazu','oiseau','Ara',5,2,'U0059'),
('A0060','CocoBird','oiseau','Cacatoès',6,1,'U0060'),
('A0061','Blue','oiseau','Perruche',3,0,'U0001'),
('A0062','Sunny','oiseau','Ara',4,2,'U0002'),
('A0063','Mango','oiseau','Cacatoès',5,1,'U0003'),
('A0064','Pepper','oiseau','Perruche',2,0,'U0004'),
('A0065','Flappy','oiseau','Ara',3,2,'U0005'),
('A0066','Chico','oiseau','Cacatoès',4,1,'U0006'),
('A0067','Loco','oiseau','Perruche',3,0,'U0007'),
('A0068','RioBird','oiseau','Ara',5,2,'U0008'),
('A0069','Jazz','oiseau','Cacatoès',6,1,'U0009'),
('A0070','Tico','oiseau','Perruche',2,0,'U0010'),

-- FURETS (10)
('A0071','Fury','furet','Angora',2,2,'U0011'),
('A0072','Nox','furet','Standard',3,1,'U0012'),
('A0073','LokiF','furet','Angora',4,2,'U0013'),
('A0074','ShadowF','furet','Standard',2,1,'U0014'),
('A0075','MistyF','furet','Angora',3,2,'U0015'),
('A0076','Bolt','furet','Standard',1,1,'U0016'),
('A0077','Ziggy','furet','Angora',2,2,'U0017'),
('A0078','NovaF','furet','Standard',3,1,'U0018'),
('A0079','Flash','furet','Angora',4,2,'U0019'),
('A0080','Pix','furet','Standard',2,1,'U0020'),

-- HAMSTERS (10)
('A0081','Chips','hamster','Syrien',1,0,'U0021'),
('A0082','BiscuitH','hamster','Russe',1,0,'U0022'),
('A0083','CocoH','hamster','Syrien',2,0,'U0023'),
('A0084','Nugget','hamster','Russe',1,0,'U0024'),
('A0085','MimiH','hamster','Syrien',1,0,'U0025'),
('A0086','FluffyH','hamster','Russe',2,0,'U0026'),
('A0087','Pip','hamster','Syrien',1,0,'U0027'),
('A0088','SnowH','hamster','Russe',1,0,'U0028'),
('A0089','Tiny','hamster','Syrien',2,0,'U0029'),
('A0090','Dot','hamster','Russe',1,0,'U0030'),

-- CAMÉLÉONS (5)
('A0091','Kameleon','caméléon','Panthère',3,1,'U0031'),
('A0092','Chroma','caméléon','Voilé',4,1,'U0032'),
('A0093','Iris','caméléon','Panthère',2,1,'U0033'),
('A0094','NeoCam','caméléon','Voilé',3,1,'U0034'),
('A0095','Color','caméléon','Panthère',5,1,'U0035'),

-- LÉZARDS (5)
('A0096','Spike','lézard','Gecko',2,1,'U0036'),
('A0097','Draco','lézard','Iguane',4,5,'U0037'),
('A0098','Slink','lézard','Anolis',3,1,'U0038'),
('A0099','Scales','lézard','Gecko',2,1,'U0039'),
('A0100','Viper','lézard','Iguane',5,6,'U0040');

SELECT * FROM Animal;

SELECT * FROM GardienAnimaux;