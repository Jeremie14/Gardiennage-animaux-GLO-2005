CREATE DATABASE gardiennage_animaux_GLO2005_2026;


SHOW DATABASES;

USE gardiennage_animaux_GLO2005_2026;
SHOW TABLES;

CREATE TABLE Utilisateur (
    idUtilisateur int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(100),
    prenom varchar(100),
    email varchar(100) UNIQUE,
    numTelephone varchar(10) UNIQUE,
    adresse varchar(100),
    dateInscription DATE,
    motDePasse varchar(20)
);

CREATE TABLE Animal (
    idAnimal int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(50),
    espece varchar(50),
    race varchar(50),
    age int(2),
    poids int(3),
    idProprietaire int,
    FOREIGN KEY(idProprietaire) REFERENCES Utilisateur(idUtilisateur) ON DELETE CASCADE
);

CREATE TABLE GardienAnimaux (
    idGardien int PRIMARY KEY AUTO_INCREMENT,
    idUtilisateur int,
    experience int(2),
    tarifHoraire int(3),
    description varchar(1000),
    evaluationMoyenne int(3), -- A modifier --> Fonction calcul moyenne
    FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur) ON DELETE CASCADE
);

CREATE TABLE Reservation(
    idReservation int PRIMARY KEY AUTO_INCREMENT,
    dateDebut DATE,
    dateFin DATE,
    statut ENUM('TERMINE', 'EN_COURS'),
    prixTotal int(5),
    idClient int,
    idGardien int,
    idAnimal int,
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY (idAnimal) REFERENCES Animal(idAnimal),
    FOREIGN KEY(idClient) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE Paiement(
    idPaiement int PRIMARY KEY AUTO_INCREMENT,
    montant int(5),
    datePaiement DATE,
    methodePaiement ENUM('Crédit', 'Débit', 'Espèce'),
    idReservation int,
    FOREIGN KEY(idReservation) REFERENCES Reservation(idReservation)
);

CREATE TABLE Avis(
    idAvis int PRIMARY KEY AUTO_INCREMENT,
    note int(3),
    commentaire varchar(1000),
    dateAvis DATE,
    idProprietaire int,
    idGardien int,
    FOREIGN KEY(idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY(idProprietaire) REFERENCES Utilisateur(idUtilisateur)
);

INSERT INTO Utilisateur (nom, prenom, email, numTelephone, adresse, dateInscription, motDePasse)
VALUES
('Tremblay','Jeremie','jeremie.tremblay@gmail.com','5814432001','123 rue de la Fontaine','2020-03-15','PwdU0001A'),
('Gagnon','Alice','alice.gagnon@gmail.com','5814432002','45 rue Principale','2021-06-18','PwdU0002B'),
('Roy','Marc','marc.roy@gmail.com','5814432003','78 rue du Parc','2022-01-10','PwdU0003C'),
('Cote','Sophie','sophie.cote@gmail.com','5814432004','12 rue des Pins','2023-09-05','PwdU0004D'),
('Bouchard','David','david.bouchard@gmail.com','5814432005','90 avenue Royale','2024-11-18','PwdU0005E'),
('Pelletier','Julie','julie.pelletier@gmail.com','5814432006','33 rue Saint-Jean','2020-07-22','PwdU0006F'),
('Lavoie','Thomas','thomas.lavoie@gmail.com','5814432007','88 rue Commerciale','2021-12-01','PwdU0007G'),
('Fortin','Emma','emma.fortin@gmail.com','5814432008','17 rue Centrale','2022-04-14','PwdU0008H'),
('Leclerc','Alex','alex.leclerc@gmail.com','5814432009','56 rue du Lac','2023-02-28','PwdU0009I'),
('Bergeron','Nicolas','nicolas.bergeron@gmail.com','5814432010','101 rue Maple','2025-08-19','PwdU0010J'),

('Simard','Chloe','chloe.simard@gmail.com','5814432011','22 rue des Saules','2020-10-10','PwdU0011K'),
('Morin','Antoine','antoine.morin@gmail.com','5814432012','64 rue de la Gare','2021-03-03','PwdU0012L'),
('Gauthier','Laura','laura.gauthier@gmail.com','5814432013','77 rue Bellevue','2022-06-17','PwdU0013M'),
('Paquette','Kevin','kevin.paquette@gmail.com','5814432014','9 rue du Moulin','2023-01-25','PwdU0014N'),
('Rousseau','Mia','mia.rousseau@gmail.com','5814432015','18 rue du Centre','2024-05-09','PwdU0015O'),
('Caron','Louis','louis.caron@gmail.com','5814432016','39 rue des Erables','2025-09-30','PwdU0016P'),
('Beaulieu','Sarah','sarah.beaulieu@gmail.com','5814432017','120 rue St-Paul','2026-02-14','PwdU0017Q'),
('Blais','Ethan','ethan.blais@gmail.com','5814432018','55 rue des Champs','2020-11-11','PwdU0018R'),
('Martel','Zoé','zoe.martel@gmail.com','5814432019','41 rue du Nord','2021-08-08','PwdU0019S'),
('Lapointe','William','william.lapointe@gmail.com','5814432020','73 rue des Fleurs','2022-12-12','PwdU0020T'),

('Girard','Olivier','olivier.girard@gmail.com','5814432021','14 rue du Port','2023-03-15','PwdU0021U'),
('Fournier','Camille','camille.fournier@gmail.com','5814432022','66 rue des Champs','2024-07-20','PwdU0022V'),
('Dupont','Raphael','raphael.dupont@gmail.com','5814432023','88 rue du Marché','2020-05-01','PwdU0023W'),
('Gosselin','Lea','lea.gosselin@gmail.com','5814432024','32 rue des Bois','2021-09-09','PwdU0024X'),
('Poulin','Mathis','mathis.poulin@gmail.com','5814432025','10 rue St-Michel','2022-10-10','PwdU0025Y'),
('Desjardins','Clara','clara.desjardins@gmail.com','5814432026','99 rue des Lilas','2023-06-06','PwdU0026Z'),
('Nguyen','Hugo','hugo.nguyen@gmail.com','5814432027','21 rue du Soleil','2024-04-04','PwdU0027A1'),
('Tran','Jade','jade.tran@gmail.com','5814432028','13 rue des Érables','2025-01-15','PwdU0028B1'),
('Lefebvre','Maxime','maxime.lefebvre@gmail.com','5814432029','77 rue du Centre','2026-03-03','PwdU0029C1'),
('Pelletier','Anna','anna.pelletier@gmail.com','5814432030','45 rue Bellevue','2020-08-18','PwdU0030D1'),

('Cloutier','Gabriel','gabriel.cloutier@gmail.com','5814432031','56 rue des Cèdres','2021-02-02','PwdU0031E1'),
('Boucher','Noemie','noemie.boucher@gmail.com','5814432032','12 rue des Pins','2022-03-11','PwdU0032F1'),
('Couture','Simon','simon.couture@gmail.com','5814432033','34 rue St-Louis','2023-04-22','PwdU0033G1'),
('Leduc','Victoria','victoria.leduc@gmail.com','5814432034','90 rue des Fleurs','2024-05-05','PwdU0034H1'),
('Marchand','Benjamin','benjamin.marchand@gmail.com','5814432035','18 rue du Parc','2025-06-16','PwdU0035I1'),
('Legault','Lisa','lisa.legault@gmail.com','5814432036','44 rue Royale','2026-07-07','PwdU0036J1'),
('Gervais','Paul','paul.gervais@gmail.com','5814432037','27 rue du Lac','2020-09-09','PwdU0037K1'),
('Vigneault','Florence','florence.vigneault@gmail.com','5814432038','61 rue Centrale','2021-10-10','PwdU0038L1'),
('Proulx','Yann','yann.proulx@gmail.com','5814432039','70 rue du Nord','2022-11-11','PwdU0039M1'),
('Blanchet','Maude','maude.blanchet@gmail.com','5814432040','15 rue Maple','2023-12-12','PwdU0040N1'),

('Chevalier','Samuel','samuel.chevalier@gmail.com','5814432041','22 rue des Pins','2024-01-20','PwdU0041O1'),
('Arsenault','Eva','eva.arsenault@gmail.com','5814432042','88 rue St-Paul','2025-02-21','PwdU0042P1'),
('Bégin','Adam','adam.begin@gmail.com','5814432043','33 rue des Champs','2026-03-22','PwdU0043Q1'),
('Lacroix','Amelie','amelie.lacroix@gmail.com','5814432044','54 rue du Port','2020-04-23','PwdU0044R1'),
('Michaud','Theo','theo.michaud@gmail.com','5814432045','11 rue des Cèdres','2021-05-24','PwdU0045S1'),
('Ouellet','Iris','iris.ouellet@gmail.com','5814432046','98 rue Centrale','2022-06-25','PwdU0046T1'),
('Nadeau','Laurent','laurent.nadeau@gmail.com','5814432047','76 rue du Soleil','2023-07-26','PwdU0047U1'),
('Dubois','Isabelle','isabelle.dubois@gmail.com','5814432048','39 rue des Fleurs','2024-08-27','PwdU0048V1'),
('Hamel','Patrick','patrick.hamel@gmail.com','5814432049','20 rue du Parc','2025-09-28','PwdU0049W1'),
('Tessier','Marie','marie.tessier@gmail.com','5814432050','5 rue Royale','2026-10-29','PwdU0050X1'),

('Tremblay','Daniel','daniel.tremblay@gmail.com','5814432051','10 rue des Lilas','2020-01-05','PwdU0051A2'),
('Gagnon','Jeremie','jeremie.gagnon@gmail.com','5814432052','11 rue des Érables','2021-02-06','PwdU0052B2'),
('Roy','Alice','alice.roy@gmail.com','5814432053','12 rue du Lac','2022-03-07','PwdU0053C2'),
('Cote','Marc','marc.cote@gmail.com','5814432054','13 rue Centrale','2023-04-08','PwdU0054D2'),
('Bouchard','Sophie','sophie.bouchard@gmail.com','5814432055','14 rue du Nord','2024-05-09','PwdU0055E2'),
('Pelletier','David','david.pelletier@gmail.com','5814432056','15 rue St-Jean','2025-06-10','PwdU0056F2'),
('Lavoie','Julie','julie.lavoie@gmail.com','5814432057','16 rue du Port','2026-07-11','PwdU0057G2'),
('Fortin','Thomas','thomas.fortin@gmail.com','5814432058','17 rue des Champs','2020-08-12','PwdU0058H2'),
('Leclerc','Emma','emma.leclerc@gmail.com','5814432059','18 rue Maple','2021-09-13','PwdU0059I2'),
('Bergeron','Alex','alex.bergeron@gmail.com','5814432060','19 rue Royale','2022-10-14','PwdU0060J2'),

('Simard','Nicolas','nicolas.simard@gmail.com','5814432061','20 rue du Soleil','2023-11-15','PwdU0061K2'),
('Morin','Chloe','chloe.morin@gmail.com','5814432062','21 rue Bellevue','2024-12-16','PwdU0062L2'),
('Gauthier','Antoine','antoine.gauthier@gmail.com','5814432063','22 rue du Parc','2025-01-17','PwdU0063M2'),
('Paquette','Laura','laura.paquette@gmail.com','5814432064','23 rue des Pins','2026-02-18','PwdU0064N2'),
('Rousseau','Kevin','kevin.rousseau@gmail.com','5814432065','24 rue du Lac','2020-03-19','PwdU0065O2'),
('Caron','Mia','mia.caron@gmail.com','5814432066','25 rue Centrale','2021-04-20','PwdU0066P2'),
('Beaulieu','Louis','louis.beaulieu@gmail.com','5814432067','26 rue des Fleurs','2022-05-21','PwdU0067Q2'),
('Blais','Sarah','sarah.blais@gmail.com','5814432068','27 rue St-Paul','2023-06-22','PwdU0068R2'),
('Martel','Ethan','ethan.martel@gmail.com','5814432069','28 rue des Cèdres','2024-07-23','PwdU0069S2'),
('Lapointe','Zoé','zoe.lapointe@gmail.com','5814432070','29 rue du Nord','2025-08-24','PwdU0070T2'),

('Girard','William','william.girard@gmail.com','5814432071','30 rue du Port','2026-09-25','PwdU0071U2'),
('Fournier','Olivier','olivier.fournier@gmail.com','5814432072','31 rue des Champs','2020-10-26','PwdU0072V2'),
('Dupont','Camille','camille.dupont@gmail.com','5814432073','32 rue du Soleil','2021-11-27','PwdU0073W2'),
('Gosselin','Raphael','raphael.gosselin@gmail.com','5814432074','33 rue Maple','2022-12-28','PwdU0074X2'),
('Poulin','Lea','lea.poulin@gmail.com','5814432075','34 rue Royale','2023-01-29','PwdU0075Y2'),
('Desjardins','Mathis','mathis.desjardins@gmail.com','5814432076','35 rue Centrale','2024-02-01','PwdU0076Z2'),
('Nguyen','Clara','clara.nguyen@gmail.com','5814432077','36 rue du Lac','2025-03-02','PwdU0077A3'),
('Tran','Hugo','hugo.tran@gmail.com','5814432078','37 rue des Pins','2026-04-03','PwdU0078B3'),
('Lefebvre','Jade','jade.lefebvre@gmail.com','5814432079','38 rue St-Jean','2020-05-04','PwdU0079C3'),
('Pelletier','Maxime','maxime.pelletier@gmail.com','5814432080','39 rue du Nord','2021-06-05','PwdU0080D3'),

('Cloutier','Anna','anna.cloutier@gmail.com','5814432081','40 rue du Parc','2022-07-06','PwdU0081E3'),
('Boucher','Gabriel','gabriel.boucher@gmail.com','5814432082','41 rue Centrale','2023-08-07','PwdU0082F3'),
('Couture','Noemie','noemie.couture@gmail.com','5814432083','42 rue des Fleurs','2024-09-08','PwdU0083G3'),
('Leduc','Simon','simon.leduc@gmail.com','5814432084','43 rue du Soleil','2025-10-09','PwdU0084H3'),
('Marchand','Victoria','victoria.marchand@gmail.com','5814432085','44 rue Maple','2026-11-10','PwdU0085I3'),
('Legault','Benjamin','benjamin.legault@gmail.com','5814432086','45 rue Royale','2020-12-11','PwdU0086J3'),
('Gervais','Lisa','lisa.gervais@gmail.com','5814432087','46 rue du Lac','2021-01-12','PwdU0087K3'),
('Vigneault','Paul','paul.vigneault@gmail.com','5814432088','47 rue Centrale','2022-02-13','PwdU0088L3'),
('Proulx','Florence','florence.proulx@gmail.com','5814432089','48 rue des Pins','2023-03-14','PwdU0089M3'),
('Blanchet','Yann','yann.blanchet@gmail.com','5814432090','49 rue du Nord','2024-04-15','PwdU0090N3'),

('Chevalier','Maude','maude.chevalier@gmail.com','5814432091','50 rue du Port','2025-05-16','PwdU0091O3'),
('Arsenault','Samuel','samuel.arsenault@gmail.com','5814432092','51 rue des Champs','2026-06-17','PwdU0092P3'),
('Bégin','Eva','eva.begin@gmail.com','5814432093','52 rue Centrale','2020-07-18','PwdU0093Q3'),
('Lacroix','Adam','adam.lacroix@gmail.com','5814432094','53 rue Maple','2021-08-19','PwdU0094R3'),
('Michaud','Amelie','amelie.michaud@gmail.com','5814432095','54 rue Royale','2022-09-20','PwdU0095S3'),
('Ouellet','Theo','theo.ouellet@gmail.com','5814432096','55 rue du Lac','2023-10-21','PwdU0096T3'),
('Nadeau','Iris','iris.nadeau@gmail.com','5814432097','56 rue du Nord','2024-11-22','PwdU0097U3'),
('Dubois','Laurent','laurent.dubois@gmail.com','5814432098','57 rue des Pins','2025-12-23','PwdU0098V3'),
('Hamel','Isabelle','isabelle.hamel@gmail.com','5814432099','58 rue St-Paul','2026-01-24','PwdU0099W3'),
('Tessier','Patrick','patrick.tessier@gmail.com','5814432100','59 rue du Soleil','2020-02-25','PwdU0100X3');


INSERT INTO Animal (nom, espece, race, age, poids, idProprietaire) VALUES
-- CHIENS (20)
('Rex','chien','Labrador',5,28,1),
('Bella','chien','Beagle',3,12,2),
('Max','chien','Husky',6,24,3),
('Luna','chien','Golden Retriever',4,30,4),
('Rocky','chien','Bulldog',7,22,5),
('Maya','chien','Caniche',2,7,6),
('Tango','chien','Berger allemand',5,34,7),
('Nala','chien','Chihuahua',1,3,8),
('Oscar','chien','Border Collie',4,20,9),
('Simba','chien','Doberman',6,32,10),
('Ruby','chien','Labrador',3,27,11),
('Zeus','chien','Husky',5,26,12),
('Loki','chien','Beagle',2,11,13),
('Milo','chien','Golden Retriever',4,29,14),
('Nova','chien','Caniche',3,6,15),
('Kira','chien','Bulldog',6,23,16),
('Baxter','chien','Berger allemand',5,35,17),
('Coco','chien','Chihuahua',2,4,18),
('Thor','chien','Doberman',7,33,19),
('Sunny','chien','Border Collie',4,21,20),

-- CHATS (20)
('Minou','chat','Siamois',3,4,21),
('Chanel','chat','Maine Coon',5,7,22),
('Felix','chat','Bengal',2,5,23),
('Lili','chat','Persan',4,6,24),
('Moka','chat','Sphynx',3,4,25),
('Neko','chat','Siamois',1,3,26),
('Shadow','chat','Maine Coon',6,8,27),
('BellaCat','chat','Bengal',2,5,28),
('Cleo','chat','Persan',5,6,29),
('Zara','chat','Sphynx',4,4,30),
('Oreo','chat','Siamois',3,4,31),
('LunaCat','chat','Maine Coon',2,7,32),
('Misty','chat','Bengal',4,5,33),
('Snow','chat','Persan',6,6,34),
('Pixel','chat','Sphynx',1,3,35),
('Jazz','chat','Siamois',5,4,36),
('Tigrou','chat','Bengal',3,5,37),
('Mia','chat','Maine Coon',4,7,38),
('Fiona','chat','Persan',2,6,39),
('Neo','chat','Sphynx',3,4,40),

-- LAPINS (15)
('Biscuit','lapin','Nain',2,2,41),
('Fluffy','lapin','Bélier',3,3,42),
('Caramel','lapin','Nain',1,2,43),
('Pompom','lapin','Bélier',4,4,44),
('Snowy','lapin','Nain',2,1,45),
('Coco','lapin','Nain',3,2,46),
('Moka','lapin','Bélier',5,4,47),
('Litchi','lapin','Nain',1,2,48),
('Noisette','lapin','Bélier',2,3,49),
('Plume','lapin','Nain',3,2,50),
('Bunny','lapin','Nain',2,2,51),
('Roux','lapin','Bélier',4,4,52),
('Velours','lapin','Nain',1,1,53),
('Câlin','lapin','Bélier',3,3,54),
('Chouchou','lapin','Nain',2,2,55),

-- OISEAUX (15)
('Kiwi','oiseau','Perroquet',3,1,56),
('Rio','oiseau','Cacatoès',4,1,57),
('Sky','oiseau','Perruche',2,0,58),
('Zazu','oiseau','Ara',5,2,59),
('CocoBird','oiseau','Cacatoès',6,1,60),
('Blue','oiseau','Perruche',3,0,1),
('Sunny','oiseau','Ara',4,2,2),
('Mango','oiseau','Cacatoès',5,1,3),
('Pepper','oiseau','Perruche',2,0,4),
('Flappy','oiseau','Ara',3,2,5),
('Chico','oiseau','Cacatoès',4,1,6),
('Loco','oiseau','Perruche',3,0,7),
('RioBird','oiseau','Ara',5,2,8),
('Jazz','oiseau','Cacatoès',6,1,9),
('Tico','oiseau','Perruche',2,0,10),

-- FURETS (10)
('Fury','furet','Angora',2,2,11),
('Nox','furet','Standard',3,1,12),
('LokiF','furet','Angora',4,2,13),
('ShadowF','furet','Standard',2,1,14),
('MistyF','furet','Angora',3,2,15),
('Bolt','furet','Standard',1,1,16),
('Ziggy','furet','Angora',2,2,17),
('NovaF','furet','Standard',3,1,18),
('Flash','furet','Angora',4,2,19),
('Pix','furet','Standard',2,1,20),

-- HAMSTERS (10)
('Chips','hamster','Syrien',1,0,21),
('BiscuitH','hamster','Russe',1,0,22),
('CocoH','hamster','Syrien',2,0,23),
('Nugget','hamster','Russe',1,0,24),
('MimiH','hamster','Syrien',1,0,25),
('FluffyH','hamster','Russe',2,0,26),
('Pip','hamster','Syrien',1,0,27),
('SnowH','hamster','Russe',1,0,28),
('Tiny','hamster','Syrien',2,0,29),
('Dot','hamster','Russe',1,0,30),

-- CAMÉLÉONS (5)
('Kameleon','caméléon','Panthère',3,1,31),
('Chroma','caméléon','Voilé',4,1,32),
('Iris','caméléon','Panthère',2,1,33),
('NeoCam','caméléon','Voilé',3,1,34),
('Color','caméléon','Panthère',5,1,35),

-- LÉZARDS (5)
('Spike','lézard','Gecko',2,1,36),
('Draco','lézard','Iguane',4,5,37),
('Slink','lézard','Anolis',3,1,38),
('Scales','lézard','Gecko',2,1,39),
('Viper','lézard','Iguane',5,6,40);

INSERT INTO GardienAnimaux (idUtilisateur, experience, tarifHoraire, description, evaluationMoyenne)VALUES
(61,2,15,'Je garde les chats et petits animaux',75),
(62,5,18,'Je garde les chiens et chats',82),
(63,1,12,'Je garde les hamsters et lapins',70),
(64,8,22,'Je garde tous les animaux',88),
(65,3,16,'Je garde les oiseaux et lapins',74),
(66,10,25,'Je garde les chiens',90),
(67,6,20,'Je garde les chats et furets',85),
(68,4,17,'Je garde les petits animaux',72),
(69,7,23,'Je garde les chiens et chats',87),
(70,12,30,'Je garde tous les animaux',92),

(71,0,10,'Je garde les hamsters',65),
(72,15,35,'Je garde les chiens et animaux exotiques',95),
(73,9,24,'Je garde les chats',80),
(74,11,28,'Je garde les chiens et lapins',89),
(75,2,14,'Je garde les oiseaux',73),
(76,14,32,'Je garde tous les animaux',94),
(77,6,19,'Je garde les furets et hamsters',78),
(78,3,15,'Je garde les chats et lapins',76),
(79,8,21,'Je garde les chiens',83),
(80,13,29,'Je garde les chiens et chats',91),

(81,5,18,'Je garde les petits animaux',77),
(82,16,34,'Je garde tous les animaux',96),
(83,7,22,'Je garde les reptiles',84),
(84,4,17,'Je garde les chats',75),
(85,10,26,'Je garde les chiens et oiseaux',88),
(86,12,31,'Je garde tous les animaux',93),
(87,1,11,'Je garde les hamsters et lapins',69),
(88,9,23,'Je garde les chats et chiens',86),
(89,6,20,'Je garde les furets',79),
(90,18,36,'Je garde tous les animaux',97),

(91,2,13,'Je garde les oiseaux et reptiles',72),
(92,20,38,'Je garde tous les animaux',98),
(93,11,27,'Je garde les chiens et chats',89),
(94,3,15,'Je garde les petits animaux',74),
(95,14,33,'Je garde tous les animaux',95),
(96,8,21,'Je garde les chats',82),
(97,17,35,'Je garde les chiens et animaux exotiques',96),
(98,5,18,'Je garde les lapins et hamsters',77),
(99,19,37,'Je garde tous les animaux',97),
(100,7,22,'Je garde les chiens et chats',85);

-- Requête :
SELECT * FROM Animal;
SELECT * FROM Utilisateur;
SELECT * FROM GardienAnimaux;

-- Génère l'id des gardiens ainsi que leur prénom et nom
SELECT G.idGardien, U.prenom, U.nom FROM GardienAnimaux G, Utilisateur U WHERE G.idUtilisateur = U.idUtilisateur;

-- Requête qui renvoie le nom des clients et le nombre d'animaux qu'il possède

-- Requête qui renvoie les gardiens qui ont un taux horaire en bas de la moyenne (À MODIFIER)
SELECT idGardien, tarifHoraire
FROM GardienAnimaux
WHERE tarifHoraire < (SELECT AVG(tarifHoraire) FROM GardienAnimaux);
