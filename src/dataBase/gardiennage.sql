CREATE DATABASE gardiennage_animaux_GLO2005_2026;


SHOW DATABASES;

USE gardiennage_animaux_GLO2005_2026;
SHOW TABLES;

CREATE TABLE Utilisateur (
    idUtilisateur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    numTelephone VARCHAR(10) UNIQUE,
    adresse VARCHAR(100),
    dateInscription DATE,
    motDePasse VARCHAR(20),
    statutCompte ENUM('Actif', 'Inactif') DEFAULT 'Actif',
    role ENUM('Proprietaire', 'Gardien', 'Administrateur') DEFAULT 'Proprietaire'
);

CREATE TABLE Animal (
    idAnimal INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50),
    espece VARCHAR(50),
    race VARCHAR(50),
    age INT(2),
    poids INT(3),
    idProprietaire INT,
    sexe ENUM('Mâle', 'Femelle') DEFAULT 'Mâle',
    temperament VARCHAR(100) DEFAULT 'Calme',
    besoinsSpeciaux VARCHAR(1000) DEFAULT 'Aucun',
    FOREIGN KEY (idProprietaire) REFERENCES Utilisateur(idUtilisateur) ON DELETE CASCADE
);

CREATE TABLE GardienAnimaux (
    idGardien INT PRIMARY KEY AUTO_INCREMENT,
    idUtilisateur INT,
    experience INT(2),
    tarifHoraire INT(3),
    description VARCHAR(1000),
    tarifJournalier INT(3),
    zoneService VARCHAR(100) DEFAULT 'Québec',
    verificationIdentite BOOLEAN DEFAULT FALSE,
    actif BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur) ON DELETE CASCADE
);

CREATE TABLE Disponibilite (
    idDisponibilite INT PRIMARY KEY AUTO_INCREMENT,
    idGardien INT,
    dateDebut DATE,
    dateFin DATE,
    statutDisponibilite ENUM('DISPONIBLE', 'INDISPONIBLE', 'RESERVE'),
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien)
);

CREATE TABLE Service (
    idService INT PRIMARY KEY AUTO_INCREMENT,
    idGardien INT,
    typeService VARCHAR(100),
    description VARCHAR(100),
    tarif INT(3),
    dureeEstimee INT,
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien)
);

CREATE TABLE DemandeReservation (
    idDemande INT PRIMARY KEY AUTO_INCREMENT,
    idProprietaire INT,
    idGardien INT,
    idAnimal INT,
    idService INT,
    dateDebut DATE,
    dateFin DATE,
    message VARCHAR(1000),
    dateCreation DATE,
    statutDemande ENUM('ACCEPTEE', 'REFUSEE', 'EN_ATTENTE', 'ANNULEE'),
    FOREIGN KEY (idService) REFERENCES Service(idService),
    FOREIGN KEY (idAnimal) REFERENCES Animal(idAnimal),
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY (idProprietaire) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE Reservation (
    idReservation INT PRIMARY KEY AUTO_INCREMENT,
    idDemande INT UNIQUE,
    dateConfirmation DATE,
    statutReservation ENUM('CONFIRMEE', 'EN_COURS', 'TERMINEE', 'ANNULEE'),
    prixTotal INT(5),
    FOREIGN KEY (idDemande) REFERENCES DemandeReservation(idDemande)
);

CREATE TABLE Paiement (
    idPaiement INT PRIMARY KEY AUTO_INCREMENT,
    montant INT(5),
    datePaiement DATE,
    methodePaiement ENUM('Crédit', 'Débit', 'Espèce'),
    idReservation INT,
    statutPaiement ENUM('EN_ATTENTE', 'PAYE', 'REMBOURSE'),
    FOREIGN KEY (idReservation) REFERENCES Reservation(idReservation)
);

CREATE TABLE Avis (
    idAvis INT PRIMARY KEY AUTO_INCREMENT,
    note INT(3),
    commentaire VARCHAR(1000),
    dateAvis DATE,
    idProprietaire INT,
    idGardien INT,
    idReservation INT,
    FOREIGN KEY (idReservation) REFERENCES Reservation(idReservation),
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY (idProprietaire) REFERENCES Utilisateur(idUtilisateur)
);

-- =========================
-- INDEXATION DU SYSTÈME
-- =========================

-- DemandeReservation (très utilisée dans les requêtes)
CREATE INDEX idx_demande_proprietaire ON DemandeReservation(idProprietaire);
CREATE INDEX idx_demande_gardien ON DemandeReservation(idGardien);
CREATE INDEX idx_demande_dates ON DemandeReservation(dateDebut, dateFin);
CREATE INDEX idx_demande_statut ON DemandeReservation(statutDemande);

-- Disponibilite (recherche par période + gardien)
CREATE INDEX idx_dispo_gardien ON Disponibilite(idGardien);
CREATE INDEX idx_dispo_dates ON Disponibilite(dateDebut, dateFin);
CREATE INDEX idx_dispo_statut ON Disponibilite(statutDisponibilite);

-- Service (filtre par type + jointure)
CREATE INDEX idx_service_gardien ON Service(idGardien);
CREATE INDEX idx_service_type ON Service(typeService);

-- Avis (calcul moyenne)
CREATE INDEX idx_avis_gardien ON Avis(idGardien);

-- Paiement (liaison avec réservation)
CREATE INDEX idx_paiement_reservation ON Paiement(idReservation);

-- Animal (liaison avec propriétaire)
CREATE INDEX idx_animal_proprietaire ON Animal(idProprietaire);

-- GardienAnimaux (recherche gardiens actifs)
CREATE INDEX idx_gardien_utilisateur ON GardienAnimaux(idUtilisateur);
CREATE INDEX idx_gardien_actif ON GardienAnimaux(actif);
CREATE INDEX idx_gardien_zone ON GardienAnimaux(zoneService);

-- ===============
-- Données
-- ===============

INSERT INTO Utilisateur (
    nom, prenom, email, numTelephone, adresse, dateInscription, motDePasse, statutCompte, role
)VALUES
('Tremblay','Jeremie','jeremie.tremblay@gmail.com','5814432001','123 rue de la Fontaine','2020-03-15','PwdU0001A','Actif','Proprietaire'),
('Gagnon','Alice','alice.gagnon@gmail.com','5814432002','45 rue Principale','2021-06-18','PwdU0002B','Actif','Proprietaire'),
('Roy','Marc','marc.roy@gmail.com','5814432003','78 rue du Parc','2022-01-10','PwdU0003C','Actif','Proprietaire'),
('Cote','Sophie','sophie.cote@gmail.com','5814432004','12 rue des Pins','2023-09-05','PwdU0004D','Actif','Proprietaire'),
('Bouchard','David','david.bouchard@gmail.com','5814432005','90 avenue Royale','2024-11-18','PwdU0005E','Actif','Proprietaire'),
('Pelletier','Julie','julie.pelletier@gmail.com','5814432006','33 rue Saint-Jean','2020-07-22','PwdU0006F','Actif','Proprietaire'),
('Lavoie','Thomas','thomas.lavoie@gmail.com','5814432007','88 rue Commerciale','2021-12-01','PwdU0007G','Actif','Proprietaire'),
('Fortin','Emma','emma.fortin@gmail.com','5814432008','17 rue Centrale','2022-04-14','PwdU0008H','Actif','Proprietaire'),
('Leclerc','Alex','alex.leclerc@gmail.com','5814432009','56 rue du Lac','2023-02-28','PwdU0009I','Actif','Proprietaire'),
('Bergeron','Nicolas','nicolas.bergeron@gmail.com','5814432010','101 rue Maple','2025-08-19','PwdU0010J','Actif','Proprietaire'),

('Simard','Chloe','chloe.simard@gmail.com','5814432011','22 rue des Saules','2020-10-10','PwdU0011K','Actif','Proprietaire'),
('Morin','Antoine','antoine.morin@gmail.com','5814432012','64 rue de la Gare','2021-03-03','PwdU0012L','Actif','Proprietaire'),
('Gauthier','Laura','laura.gauthier@gmail.com','5814432013','77 rue Bellevue','2022-06-17','PwdU0013M','Actif','Proprietaire'),
('Paquette','Kevin','kevin.paquette@gmail.com','5814432014','9 rue du Moulin','2023-01-25','PwdU0014N','Actif','Proprietaire'),
('Rousseau','Mia','mia.rousseau@gmail.com','5814432015','18 rue du Centre','2024-05-09','PwdU0015O','Actif','Proprietaire'),
('Caron','Louis','louis.caron@gmail.com','5814432016','39 rue des Erables','2025-09-30','PwdU0016P','Actif','Proprietaire'),
('Beaulieu','Sarah','sarah.beaulieu@gmail.com','5814432017','120 rue St-Paul','2026-02-14','PwdU0017Q','Actif','Proprietaire'),
('Blais','Ethan','ethan.blais@gmail.com','5814432018','55 rue des Champs','2020-11-11','PwdU0018R','Actif','Proprietaire'),
('Martel','Zoé','zoe.martel@gmail.com','5814432019','41 rue du Nord','2021-08-08','PwdU0019S','Actif','Proprietaire'),
('Lapointe','William','william.lapointe@gmail.com','5814432020','73 rue des Fleurs','2022-12-12','PwdU0020T','Actif','Proprietaire'),

('Girard','Olivier','olivier.girard@gmail.com','5814432021','14 rue du Port','2023-03-15','PwdU0021U','Actif','Proprietaire'),
('Fournier','Camille','camille.fournier@gmail.com','5814432022','66 rue des Champs','2024-07-20','PwdU0022V','Actif','Proprietaire'),
('Dupont','Raphael','raphael.dupont@gmail.com','5814432023','88 rue du Marché','2020-05-01','PwdU0023W','Actif','Proprietaire'),
('Gosselin','Lea','lea.gosselin@gmail.com','5814432024','32 rue des Bois','2021-09-09','PwdU0024X','Actif','Proprietaire'),
('Poulin','Mathis','mathis.poulin@gmail.com','5814432025','10 rue St-Michel','2022-10-10','PwdU0025Y','Actif','Proprietaire'),
('Desjardins','Clara','clara.desjardins@gmail.com','5814432026','99 rue des Lilas','2023-06-06','PwdU0026Z','Actif','Proprietaire'),
('Nguyen','Hugo','hugo.nguyen@gmail.com','5814432027','21 rue du Soleil','2024-04-04','PwdU0027A1','Actif','Proprietaire'),
('Tran','Jade','jade.tran@gmail.com','5814432028','13 rue des Érables','2025-01-15','PwdU0028B1','Actif','Proprietaire'),
('Lefebvre','Maxime','maxime.lefebvre@gmail.com','5814432029','77 rue du Centre','2026-03-03','PwdU0029C1','Actif','Proprietaire'),
('Pelletier','Anna','anna.pelletier@gmail.com','5814432030','45 rue Bellevue','2020-08-18','PwdU0030D1','Actif','Proprietaire'),

('Cloutier','Gabriel','gabriel.cloutier@gmail.com','5814432031','56 rue des Cèdres','2021-02-02','PwdU0031E1','Actif','Proprietaire'),
('Boucher','Noemie','noemie.boucher@gmail.com','5814432032','12 rue des Pins','2022-03-11','PwdU0032F1','Actif','Proprietaire'),
('Couture','Simon','simon.couture@gmail.com','5814432033','34 rue St-Louis','2023-04-22','PwdU0033G1','Actif','Proprietaire'),
('Leduc','Victoria','victoria.leduc@gmail.com','5814432034','90 rue des Fleurs','2024-05-05','PwdU0034H1','Actif','Proprietaire'),
('Marchand','Benjamin','benjamin.marchand@gmail.com','5814432035','18 rue du Parc','2025-06-16','PwdU0035I1','Actif','Proprietaire'),
('Legault','Lisa','lisa.legault@gmail.com','5814432036','44 rue Royale','2026-07-07','PwdU0036J1','Actif','Proprietaire'),
('Gervais','Paul','paul.gervais@gmail.com','5814432037','27 rue du Lac','2020-09-09','PwdU0037K1','Actif','Proprietaire'),
('Vigneault','Florence','florence.vigneault@gmail.com','5814432038','61 rue Centrale','2021-10-10','PwdU0038L1','Actif','Proprietaire'),
('Proulx','Yann','yann.proulx@gmail.com','5814432039','70 rue du Nord','2022-11-11','PwdU0039M1','Actif','Proprietaire'),
('Blanchet','Maude','maude.blanchet@gmail.com','5814432040','15 rue Maple','2023-12-12','PwdU0040N1','Actif','Proprietaire'),

('Chevalier','Samuel','samuel.chevalier@gmail.com','5814432041','22 rue des Pins','2024-01-20','PwdU0041O1','Actif','Proprietaire'),
('Arsenault','Eva','eva.arsenault@gmail.com','5814432042','88 rue St-Paul','2025-02-21','PwdU0042P1','Actif','Proprietaire'),
('Bégin','Adam','adam.begin@gmail.com','5814432043','33 rue des Champs','2026-03-22','PwdU0043Q1','Actif','Proprietaire'),
('Lacroix','Amelie','amelie.lacroix@gmail.com','5814432044','54 rue du Port','2020-04-23','PwdU0044R1','Actif','Proprietaire'),
('Michaud','Theo','theo.michaud@gmail.com','5814432045','11 rue des Cèdres','2021-05-24','PwdU0045S1','Actif','Proprietaire'),
('Ouellet','Iris','iris.ouellet@gmail.com','5814432046','98 rue Centrale','2022-06-25','PwdU0046T1','Actif','Proprietaire'),
('Nadeau','Laurent','laurent.nadeau@gmail.com','5814432047','76 rue du Soleil','2023-07-26','PwdU0047U1','Actif','Proprietaire'),
('Dubois','Isabelle','isabelle.dubois@gmail.com','5814432048','39 rue des Fleurs','2024-08-27','PwdU0048V1','Actif','Proprietaire'),
('Hamel','Patrick','patrick.hamel@gmail.com','5814432049','20 rue du Parc','2025-09-28','PwdU0049W1','Actif','Proprietaire'),
('Tessier','Marie','marie.tessier@gmail.com','5814432050','5 rue Royale','2026-10-29','PwdU0050X1','Actif','Proprietaire'),

('Tremblay','Daniel','daniel.tremblay@gmail.com','5814432051','10 rue des Lilas','2020-01-05','PwdU0051A2','Actif','Proprietaire'),
('Gagnon','Jeremie','jeremie.gagnon@gmail.com','5814432052','11 rue des Érables','2021-02-06','PwdU0052B2','Actif','Proprietaire'),
('Roy','Alice','alice.roy@gmail.com','5814432053','12 rue du Lac','2022-03-07','PwdU0053C2','Actif','Proprietaire'),
('Cote','Marc','marc.cote@gmail.com','5814432054','13 rue Centrale','2023-04-08','PwdU0054D2','Actif','Proprietaire'),
('Bouchard','Sophie','sophie.bouchard@gmail.com','5814432055','14 rue du Nord','2024-05-09','PwdU0055E2','Actif','Proprietaire'),
('Pelletier','David','david.pelletier@gmail.com','5814432056','15 rue St-Jean','2025-06-10','PwdU0056F2','Actif','Proprietaire'),
('Lavoie','Julie','julie.lavoie@gmail.com','5814432057','16 rue du Port','2026-07-11','PwdU0057G2','Actif','Proprietaire'),
('Fortin','Thomas','thomas.fortin@gmail.com','5814432058','17 rue des Champs','2020-08-12','PwdU0058H2','Actif','Proprietaire'),
('Leclerc','Emma','emma.leclerc@gmail.com','5814432059','18 rue Maple','2021-09-13','PwdU0059I2','Actif','Proprietaire'),
('Bergeron','Alex','alex.bergeron@gmail.com','5814432060','19 rue Royale','2022-10-14','PwdU0060J2','Actif','Proprietaire'),

('Simard','Nicolas','nicolas.simard@gmail.com','5814432061','20 rue du Soleil','2023-11-15','PwdU0061K2','Actif','Proprietaire'),
('Morin','Chloe','chloe.morin@gmail.com','5814432062','21 rue Bellevue','2024-12-16','PwdU0062L2','Actif','Proprietaire'),
('Gauthier','Antoine','antoine.gauthier@gmail.com','5814432063','22 rue du Parc','2025-01-17','PwdU0063M2','Actif','Proprietaire'),
('Paquette','Laura','laura.paquette@gmail.com','5814432064','23 rue des Pins','2026-02-18','PwdU0064N2','Actif','Proprietaire'),
('Rousseau','Kevin','kevin.rousseau@gmail.com','5814432065','24 rue du Lac','2020-03-19','PwdU0065O2','Actif','Proprietaire'),
('Caron','Mia','mia.caron@gmail.com','5814432066','25 rue Centrale','2021-04-20','PwdU0066P2','Actif','Proprietaire'),
('Beaulieu','Louis','louis.beaulieu@gmail.com','5814432067','26 rue des Fleurs','2022-05-21','PwdU0067Q2','Actif','Proprietaire'),
('Blais','Sarah','sarah.blais@gmail.com','5814432068','27 rue St-Paul','2023-06-22','PwdU0068R2','Actif','Proprietaire'),
('Martel','Ethan','ethan.martel@gmail.com','5814432069','28 rue des Cèdres','2024-07-23','PwdU0069S2','Actif','Proprietaire'),
('Lapointe','Zoé','zoe.lapointe@gmail.com','5814432070','29 rue du Nord','2025-08-24','PwdU0070T2','Actif','Proprietaire'),

('Girard','William','william.girard@gmail.com','5814432071','30 rue du Port','2026-09-25','PwdU0071U2','Actif','Proprietaire'),
('Fournier','Olivier','olivier.fournier@gmail.com','5814432072','31 rue des Champs','2020-10-26','PwdU0072V2','Actif','Proprietaire'),
('Dupont','Camille','camille.dupont@gmail.com','5814432073','32 rue du Soleil','2021-11-27','PwdU0073W2','Actif','Proprietaire'),
('Gosselin','Raphael','raphael.gosselin@gmail.com','5814432074','33 rue Maple','2022-12-28','PwdU0074X2','Actif','Proprietaire'),
('Poulin','Lea','lea.poulin@gmail.com','5814432075','34 rue Royale','2023-01-29','PwdU0075Y2','Actif','Proprietaire'),
('Desjardins','Mathis','mathis.desjardins@gmail.com','5814432076','35 rue Centrale','2024-02-01','PwdU0076Z2','Actif','Proprietaire'),
('Nguyen','Clara','clara.nguyen@gmail.com','5814432077','36 rue du Lac','2025-03-02','PwdU0077A3','Actif','Proprietaire'),
('Tran','Hugo','hugo.tran@gmail.com','5814432078','37 rue des Pins','2026-04-03','PwdU0078B3','Actif','Proprietaire'),
('Lefebvre','Jade','jade.lefebvre@gmail.com','5814432079','38 rue St-Jean','2020-05-04','PwdU0079C3','Actif','Proprietaire'),
('Pelletier','Maxime','maxime.pelletier@gmail.com','5814432080','39 rue du Nord','2021-06-05','PwdU0080D3','Actif','Proprietaire'),

('Cloutier','Anna','anna.cloutier@gmail.com','5814432081','40 rue du Parc','2022-07-06','PwdU0081E3','Actif','Proprietaire'),
('Boucher','Gabriel','gabriel.boucher@gmail.com','5814432082','41 rue Centrale','2023-08-07','PwdU0082F3','Actif','Proprietaire'),
('Couture','Noemie','noemie.couture@gmail.com','5814432083','42 rue des Fleurs','2024-09-08','PwdU0083G3','Actif','Proprietaire'),
('Leduc','Simon','simon.leduc@gmail.com','5814432084','43 rue du Soleil','2025-10-09','PwdU0084H3','Actif','Proprietaire'),
('Marchand','Victoria','victoria.marchand@gmail.com','5814432085','44 rue Maple','2026-11-10','PwdU0085I3','Actif','Proprietaire'),
('Legault','Benjamin','benjamin.legault@gmail.com','5814432086','45 rue Royale','2020-12-11','PwdU0086J3','Actif','Proprietaire'),
('Gervais','Lisa','lisa.gervais@gmail.com','5814432087','46 rue du Lac','2021-01-12','PwdU0087K3','Actif','Proprietaire'),
('Vigneault','Paul','paul.vigneault@gmail.com','5814432088','47 rue Centrale','2022-02-13','PwdU0088L3','Actif','Proprietaire'),
('Proulx','Florence','florence.proulx@gmail.com','5814432089','48 rue des Pins','2023-03-14','PwdU0089M3','Actif','Proprietaire'),
('Blanchet','Yann','yann.blanchet@gmail.com','5814432090','49 rue du Nord','2024-04-15','PwdU0090N3','Actif','Proprietaire'),

('Chevalier','Maude','maude.chevalier@gmail.com','5814432091','50 rue du Port','2025-05-16','PwdU0091O3','Actif','Gardien'),
('Arsenault','Samuel','samuel.arsenault@gmail.com','5814432092','51 rue des Champs','2026-06-17','PwdU0092P3','Actif','Gardien'),
('Bégin','Eva','eva.begin@gmail.com','5814432093','52 rue Centrale','2020-07-18','PwdU0093Q3','Actif','Gardien'),
('Lacroix','Adam','adam.lacroix@gmail.com','5814432094','53 rue Maple','2021-08-19','PwdU0094R3','Actif','Gardien'),
('Michaud','Amelie','amelie.michaud@gmail.com','5814432095','54 rue Royale','2022-09-20','PwdU0095S3','Actif','Gardien'),
('Ouellet','Theo','theo.ouellet@gmail.com','5814432096','55 rue du Lac','2023-10-21','PwdU0096T3','Actif','Gardien'),
('Nadeau','Iris','iris.nadeau@gmail.com','5814432097','56 rue du Nord','2024-11-22','PwdU0097U3','Actif','Gardien'),
('Dubois','Laurent','laurent.dubois@gmail.com','5814432098','57 rue des Pins','2025-12-23','PwdU0098V3','Actif','Gardien'),
('Hamel','Isabelle','isabelle.hamel@gmail.com','5814432099','58 rue St-Paul','2026-01-24','PwdU0099W3','Actif','Gardien'),
('Tessier','Patrick','patrick.tessier@gmail.com','5814432100','59 rue du Soleil','2020-02-25','PwdU0100X3','Actif','Gardien');


INSERT INTO Animal (nom, espece, race, age, poids, idProprietaire, sexe, temperament, besoinsSpeciaux) VALUES
('Rex','chien','Labrador',5,28,1,'Mâle','Calme','Aucun'),
('Bella','chien','Beagle',3,12,2,'Femelle','Joueuse','Aucun'),
('Max','chien','Husky',6,24,3,'Mâle','Énergique','Aucun'),
('Luna','chien','Golden Retriever',4,30,4,'Femelle','Sociable','Aucun'),
('Rocky','chien','Bulldog',7,22,5,'Mâle','Calme','Médication légère'),
('Maya','chien','Caniche',2,7,6,'Femelle','Timide','Aucun'),
('Tango','chien','Berger allemand',5,34,7,'Mâle','Protecteur','Aucun'),
('Nala','chien','Chihuahua',1,3,8,'Femelle','Nerveuse','Aucun'),
('Oscar','chien','Border Collie',4,20,9,'Mâle','Très actif','Aucun'),
('Simba','chien','Doberman',6,32,10,'Mâle','Protecteur','Aucun'),

('Ruby','chien','Labrador',3,27,11,'Femelle','Sociable','Aucun'),
('Zeus','chien','Husky',5,26,12,'Mâle','Énergique','Aucun'),
('Loki','chien','Beagle',2,11,13,'Mâle','Curieux','Aucun'),
('Milo','chien','Golden Retriever',4,29,14,'Mâle','Affectueux','Aucun'),
('Nova','chien','Caniche',3,6,15,'Femelle','Calme','Aucun'),
('Kira','chien','Bulldog',6,23,16,'Femelle','Calme','Régime spécial'),
('Baxter','chien','Berger allemand',5,35,17,'Mâle','Protecteur','Aucun'),
('Coco','chien','Chihuahua',2,4,18,'Femelle','Nerveuse','Aucun'),
('Thor','chien','Doberman',7,33,19,'Mâle','Dominant','Aucun'),
('Sunny','chien','Border Collie',4,21,20,'Femelle','Très active','Aucun'),

('Minou','chat','Siamois',3,4,21,'Mâle','Calme','Aucun'),
('Chanel','chat','Maine Coon',5,7,22,'Femelle','Douce','Aucun'),
('Felix','chat','Bengal',2,5,23,'Mâle','Énergique','Aucun'),
('Lili','chat','Persan',4,6,24,'Femelle','Calme','Brossage fréquent'),
('Moka','chat','Sphynx',3,4,25,'Mâle','Affectueux','Soins de peau'),
('Neko','chat','Siamois',1,3,26,'Femelle','Timide','Aucun'),
('Shadow','chat','Maine Coon',6,8,27,'Mâle','Calme','Aucun'),
('BellaCat','chat','Bengal',2,5,28,'Femelle','Joueuse','Aucun'),
('Cleo','chat','Persan',5,6,29,'Femelle','Calme','Aucun'),
('Zara','chat','Sphynx',4,4,30,'Femelle','Affectueuse','Soins de peau'),

('Oreo','chat','Siamois',3,4,31,'Mâle','Curieux','Aucun'),
('LunaCat','chat','Maine Coon',2,7,32,'Femelle','Douce','Aucun'),
('Misty','chat','Bengal',4,5,33,'Femelle','Énergique','Aucun'),
('Snow','chat','Persan',6,6,34,'Mâle','Calme','Aucun'),
('Pixel','chat','Sphynx',1,3,35,'Mâle','Affectueux','Soins de peau'),
('Jazz','chat','Siamois',5,4,36,'Mâle','Calme','Aucun'),
('Tigrou','chat','Bengal',3,5,37,'Mâle','Joueur','Aucun'),
('Mia','chat','Maine Coon',4,7,38,'Femelle','Douce','Aucun'),
('Fiona','chat','Persan',2,6,39,'Femelle','Calme','Aucun'),
('Neo','chat','Sphynx',3,4,40,'Mâle','Affectueux','Soins de peau'),

('Biscuit','lapin','Nain',2,2,41,'Mâle','Calme','Aucun'),
('Fluffy','lapin','Bélier',3,3,42,'Femelle','Douce','Aucun'),
('Caramel','lapin','Nain',1,2,43,'Mâle','Timide','Aucun'),
('Pompom','lapin','Bélier',4,4,44,'Femelle','Calme','Aucun'),
('Snowy','lapin','Nain',2,1,45,'Femelle','Douce','Aucun'),
('Coco','lapin','Nain',3,2,46,'Mâle','Calme','Aucun'),
('Moka','lapin','Bélier',5,4,47,'Mâle','Calme','Aucun'),
('Litchi','lapin','Nain',1,2,48,'Femelle','Timide','Aucun'),
('Noisette','lapin','Bélier',2,3,49,'Femelle','Douce','Aucun'),
('Plume','lapin','Nain',3,2,50,'Femelle','Calme','Aucun'),

('Bunny','lapin','Nain',2,2,51,'Mâle','Calme','Aucun'),
('Roux','lapin','Bélier',4,4,52,'Mâle','Calme','Aucun'),
('Velours','lapin','Nain',1,1,53,'Femelle','Douce','Aucun'),
('Câlin','lapin','Bélier',3,3,54,'Mâle','Affectueux','Aucun'),
('Chouchou','lapin','Nain',2,2,55,'Femelle','Calme','Aucun'),

('Kiwi','oiseau','Perroquet',3,1,56,'Mâle','Bruyant','Aucun'),
('Rio','oiseau','Cacatoès',4,1,57,'Mâle','Sociable','Aucun'),
('Sky','oiseau','Perruche',2,0,58,'Femelle','Calme','Aucun'),
('Zazu','oiseau','Ara',5,2,59,'Mâle','Bruyant','Aucun'),
('CocoBird','oiseau','Cacatoès',6,1,60,'Femelle','Sociable','Aucun'),
('Blue','oiseau','Perruche',3,0,1,'Mâle','Calme','Aucun'),
('Sunny','oiseau','Ara',4,2,2,'Femelle','Énergique','Aucun'),
('Mango','oiseau','Cacatoès',5,1,3,'Mâle','Sociable','Aucun'),
('Pepper','oiseau','Perruche',2,0,4,'Femelle','Calme','Aucun'),
('Flappy','oiseau','Ara',3,2,5,'Mâle','Bruyant','Aucun'),

('Chico','oiseau','Cacatoès',4,1,6,'Mâle','Sociable','Aucun'),
('Loco','oiseau','Perruche',3,0,7,'Mâle','Calme','Aucun'),
('RioBird','oiseau','Ara',5,2,8,'Mâle','Énergique','Aucun'),
('Jazz','oiseau','Cacatoès',6,1,9,'Femelle','Sociable','Aucun'),
('Tico','oiseau','Perruche',2,0,10,'Mâle','Calme','Aucun'),

('Fury','furet','Angora',2,2,11,'Mâle','Énergique','Aucun'),
('Nox','furet','Standard',3,1,12,'Mâle','Curieux','Aucun'),
('LokiF','furet','Angora',4,2,13,'Mâle','Joueur','Aucun'),
('ShadowF','furet','Standard',2,1,14,'Femelle','Timide','Aucun'),
('MistyF','furet','Angora',3,2,15,'Femelle','Curieuse','Aucun'),
('Bolt','furet','Standard',1,1,16,'Mâle','Énergique','Aucun'),
('Ziggy','furet','Angora',2,2,17,'Mâle','Joueur','Aucun'),
('NovaF','furet','Standard',3,1,18,'Femelle','Curieuse','Aucun'),
('Flash','furet','Angora',4,2,19,'Mâle','Énergique','Aucun'),
('Pix','furet','Standard',2,1,20,'Femelle','Timide','Aucun'),

('Chips','hamster','Syrien',1,0,21,'Mâle','Calme','Aucun'),
('BiscuitH','hamster','Russe',1,0,22,'Femelle','Timide','Aucun'),
('CocoH','hamster','Syrien',2,0,23,'Mâle','Calme','Aucun'),
('Nugget','hamster','Russe',1,0,24,'Mâle','Joueur','Aucun'),
('MimiH','hamster','Syrien',1,0,25,'Femelle','Calme','Aucun'),
('FluffyH','hamster','Russe',2,0,26,'Femelle','Timide','Aucun'),
('Pip','hamster','Syrien',1,0,27,'Mâle','Calme','Aucun'),
('SnowH','hamster','Russe',1,0,28,'Femelle','Timide','Aucun'),
('Tiny','hamster','Syrien',2,0,29,'Mâle','Calme','Aucun'),
('Dot','hamster','Russe',1,0,30,'Femelle','Joueuse','Aucun'),

('Kameleon','caméléon','Panthère',3,1,31,'Mâle','Calme','Température contrôlée'),
('Chroma','caméléon','Voilé',4,1,32,'Femelle','Calme','Température contrôlée'),
('Iris','caméléon','Panthère',2,1,33,'Femelle','Timide','Température contrôlée'),
('NeoCam','caméléon','Voilé',3,1,34,'Mâle','Calme','Température contrôlée'),
('Color','caméléon','Panthère',5,1,35,'Mâle','Calme','Température contrôlée'),

('Spike','lézard','Gecko',2,1,36,'Mâle','Calme','Lampe UV'),
('Draco','lézard','Iguane',4,5,37,'Mâle','Dominant','Lampe UV'),
('Slink','lézard','Anolis',3,1,38,'Femelle','Timide','Lampe UV'),
('Scales','lézard','Gecko',2,1,39,'Mâle','Calme','Lampe UV'),
('Viper','lézard','Iguane',5,6,40,'Mâle','Dominant','Lampe UV');


INSERT INTO GardienAnimaux (
    idUtilisateur, experience, tarifHoraire, description, tarifJournalier, zoneService, verificationIdentite, actif
) VALUES
(61,2,15,'Je garde les chats et petits animaux',120,'Québec',TRUE,TRUE),
(62,5,18,'Je garde les chiens et chats',144,'Québec',TRUE,TRUE),
(63,1,12,'Je garde les hamsters et lapins',96,'Québec',FALSE,TRUE),
(64,8,22,'Je garde tous les animaux',176,'Lévis',TRUE,TRUE),
(65,3,16,'Je garde les oiseaux et lapins',128,'Québec',TRUE,TRUE),
(66,10,25,'Je garde les chiens',200,'Québec',TRUE,TRUE),
(67,6,20,'Je garde les chats et furets',160,'Lévis',TRUE,TRUE),
(68,4,17,'Je garde les petits animaux',136,'Québec',FALSE,TRUE),
(69,7,23,'Je garde les chiens et chats',184,'Québec',TRUE,TRUE),
(70,12,30,'Je garde tous les animaux',240,'Lévis',TRUE,TRUE),

(71,0,10,'Je garde les hamsters',80,'Québec',FALSE,TRUE),
(72,15,35,'Je garde les chiens et animaux exotiques',280,'Québec',TRUE,TRUE),
(73,9,24,'Je garde les chats',192,'Lévis',TRUE,TRUE),
(74,11,28,'Je garde les chiens et lapins',224,'Québec',TRUE,TRUE),
(75,2,14,'Je garde les oiseaux',112,'Québec',FALSE,TRUE),
(76,14,32,'Je garde tous les animaux',256,'Lévis',TRUE,TRUE),
(77,6,19,'Je garde les furets et hamsters',152,'Québec',TRUE,TRUE),
(78,3,15,'Je garde les chats et lapins',120,'Québec',FALSE,TRUE),
(79,8,21,'Je garde les chiens',168,'Lévis',TRUE,TRUE),
(80,13,29,'Je garde les chiens et chats',232,'Québec',TRUE,TRUE),

(81,5,18,'Je garde les petits animaux',144,'Québec',TRUE,TRUE),
(82,16,34,'Je garde tous les animaux',272,'Lévis',TRUE,TRUE),
(83,7,22,'Je garde les reptiles',176,'Québec',TRUE,TRUE),
(84,4,17,'Je garde les chats',136,'Québec',FALSE,TRUE),
(85,10,26,'Je garde les chiens et oiseaux',208,'Lévis',TRUE,TRUE),
(86,12,31,'Je garde tous les animaux',248,'Québec',TRUE,TRUE),
(87,1,11,'Je garde les hamsters et lapins',88,'Québec',FALSE,TRUE),
(88,9,23,'Je garde les chats et chiens',184,'Lévis',TRUE,TRUE),
(89,6,20,'Je garde les furets',160,'Québec',TRUE,TRUE),
(90,18,36,'Je garde tous les animaux',288,'Québec',TRUE,TRUE),

(91,2,13,'Je garde les oiseaux et reptiles',104,'Lévis',FALSE,TRUE),
(92,20,38,'Je garde tous les animaux',304,'Québec',TRUE,TRUE),
(93,11,27,'Je garde les chiens et chats',216,'Québec',TRUE,TRUE),
(94,3,15,'Je garde les petits animaux',120,'Lévis',FALSE,TRUE),
(95,14,33,'Je garde tous les animaux',264,'Québec',TRUE,TRUE),
(96,8,21,'Je garde les chats',168,'Québec',TRUE,TRUE),
(97,17,35,'Je garde les chiens et animaux exotiques',280,'Lévis',TRUE,TRUE),
(98,5,18,'Je garde les lapins et hamsters',144,'Québec',TRUE,TRUE),
(99,19,37,'Je garde tous les animaux',296,'Québec',TRUE,TRUE),
(100,7,22,'Je garde les chiens et chats',176,'Lévis',TRUE,TRUE);


INSERT INTO Disponibilite (idGardien, dateDebut, dateFin, statutDisponibilite) VALUES
(1, '2026-05-01', '2026-05-31', 'DISPONIBLE'),
(2, '2026-05-01', '2026-05-31', 'DISPONIBLE'),
(3, '2026-05-01', '2026-05-31', 'INDISPONIBLE'),
(4, '2026-05-05', '2026-05-20', 'DISPONIBLE'),
(5, '2026-05-10', '2026-05-25', 'DISPONIBLE');


INSERT INTO Service (idGardien, typeService, description, tarif, dureeEstimee) VALUES
(1, 'GARDE_JOUR', 'Garde de jour pour animaux', 40, 8),
(2, 'GARDE_NUIT', 'Garde de nuit pour animaux', 60, 12),
(3, 'VISITE_DOMICILE', 'Visite à domicile', 25, 1),
(4, 'GARDE_JOUR', 'Garde de jour pour chiens et chats', 45, 8),
(5, 'PROMENADE', 'Promenade pour chiens', 20, 1);


INSERT INTO DemandeReservation
(idProprietaire, idGardien, idAnimal, idService, dateDebut, dateFin, message, dateCreation, statutDemande)
VALUES
(1, 1, 1, 1, '2026-05-10', '2026-05-12', 'Besoin de garde pour trois jours', '2026-05-01', 'EN_ATTENTE'),
(2, 2, 2, 2, '2026-05-15', '2026-05-16', 'Garde de nuit pour mon chien', '2026-05-02', 'ACCEPTEE'),
(3, 4, 3, 4, '2026-05-11', '2026-05-13', 'Garde de jour pour mon animal', '2026-05-03', 'ACCEPTEE'),
(4, 5, 4, 5, '2026-05-18', '2026-05-18', 'Promenade demandée', '2026-05-04', 'REFUSEE');


INSERT INTO Reservation (idDemande, dateConfirmation, statutReservation, prixTotal) VALUES
(2, '2026-05-03', 'CONFIRMEE', 120),
(3, '2026-05-04', 'TERMINEE', 135);


INSERT INTO Reservation (idDemande, dateConfirmation, statutReservation, prixTotal) VALUES
(2, '2026-05-03', 'CONFIRMEE', 120),
(3, '2026-05-04', 'TERMINEE', 135);


INSERT INTO Paiement (montant, datePaiement, methodePaiement, idReservation, statutPaiement) VALUES
(120, '2026-05-03', 'Crédit', 1, 'PAYE'),
(135, '2026-05-04', 'Débit', 2, 'PAYE');


INSERT INTO Avis (note, commentaire, dateAvis, idProprietaire, idGardien, idReservation) VALUES
(5, 'Excellent service', '2026-05-20', 2, 2, 1),
(4, 'Très bonne expérience', '2026-05-21', 3, 4, 2);


-- Requête :
SELECT * FROM Animal;
SELECT * FROM Utilisateur;
SELECT * FROM GardienAnimaux;
SELECT * FROM Disponibilite;
SELECT * FROM Service;
SELECT * FROM DemandeReservation;
SELECT * FROM Reservation;
SELECT * FROM Paiement;
SELECT * FROM Avis;


-- Génère l'id des gardiens ainsi que leur prénom et nom
SELECT G.idGardien, U.prenom, U.nom FROM GardienAnimaux G, Utilisateur U WHERE G.idUtilisateur = U.idUtilisateur;

-- Requête qui renvoie le nom des clients et le nombre d'animaux qu'il possède
SELECT U.prenom, U.nom, COUNT(*) AS Nombre
FROM Utilisateur U, Animal A
WHERE U.idUtilisateur = A.idProprietaire
GROUP BY A.idProprietaire;

-- Requête qui renvoie les gardiens qui ont un taux horaire en bas de la moyenne (À MODIFIER)
SELECT idGardien, tarifHoraire
FROM GardienAnimaux
WHERE tarifHoraire < (SELECT AVG(tarifHoraire) FROM GardienAnimaux);

-- Requête qui renvoie les propriétaires et leur animaux
SELECT U.idUtilisateur, U.prenom, U.nom, A.nom, A.idAnimal
FROM Utilisateur U
INNER JOIN Animal A
ON U.idUtilisateur = A.idProprietaire;