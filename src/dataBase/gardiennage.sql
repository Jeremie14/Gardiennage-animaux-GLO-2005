CREATE DATABASE gardiennage_animaux_GLO2005_2026;


SHOW DATABASES;

USE gardiennage_animaux_GLO2005_2026;
SHOW TABLES;

DROP TABLE Utilisateur;
DROP TABLE Animal;
DROP TABLE Avis;
DROP TABLE demandeReservation;
DROP TABLE disponibilite;
DROP TABLE GardienAnimaux;
DROP TABLE Paiement;
DROP TABLE Reservation;
DROP TABLE Service;


CREATE TABLE Utilisateur (
    idUtilisateur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    numTelephone VARCHAR(10) UNIQUE,
    adresse VARCHAR(100),
    dateInscription DATE DEFAULT (CURRENT_DATE),
    motDePasse VARCHAR(20),
    role ENUM('Proprietaire', 'Gardien') DEFAULT 'Proprietaire',
    photoDeProfil TEXT
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
    photo TEXT,
    FOREIGN KEY (idProprietaire) REFERENCES Utilisateur(idUtilisateur) ON DELETE CASCADE
);

CREATE TABLE GardienAnimaux (
    idGardien INT PRIMARY KEY,
    experience INT(2),
    tarifHoraire INT(3),
    description VARCHAR(1000),
    zoneService VARCHAR(100) DEFAULT 'Québec',
    verificationIdentite BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idGardien) REFERENCES Utilisateur(idUtilisateur) ON DELETE CASCADE
);

CREATE TABLE Disponibilite (
    idDisponibilite INT PRIMARY KEY AUTO_INCREMENT,
    idGardien INT,
    dateDebut DATE, -- Ajouter la date du jour?
    dateFin DATE,
    statutDisponibilite ENUM('DISPONIBLE', 'INDISPONIBLE', 'RESERVE'),
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien)
);

CREATE TABLE Service (
    idService INT PRIMARY KEY AUTO_INCREMENT,
    idGardien INT,
    typeService VARCHAR(100),
    description VARCHAR(100),
    dureeEstimee INT, -- Ajouter un CHECK pour duree > 0 ? OUI
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
    prixTotal INT(5), -- CHECK pour prix > 0 ? OUI
    FOREIGN KEY (idDemande) REFERENCES DemandeReservation(idDemande)
);

CREATE TABLE Paiement (
    idPaiement INT PRIMARY KEY AUTO_INCREMENT,
    montant INT(5), -- CHECK pour montant > 0 ? OUI
    datePaiement DATE,
    methodePaiement ENUM('Crédit', 'Débit', 'Espèce'),
    idReservation INT,
    statutPaiement ENUM('EN_ATTENTE', 'PAYE', 'REMBOURSE'),
    FOREIGN KEY (idReservation) REFERENCES Reservation(idReservation)
);

CREATE TABLE Avis (
    idAvis INT PRIMARY KEY AUTO_INCREMENT,
    note INT(3), -- S'assurer que ca soit entre 0 et 100 ici?
    commentaire VARCHAR(1000),
    dateAvis DATE,
    idProprietaire INT,
    idGardien INT,
    idReservation INT,
    FOREIGN KEY (idReservation) REFERENCES Reservation(idReservation),
    FOREIGN KEY (idGardien) REFERENCES GardienAnimaux(idGardien),
    FOREIGN KEY (idProprietaire) REFERENCES Utilisateur(idUtilisateur)
);

-- INDEXATION

CREATE INDEX idx_demande_proprietaire ON DemandeReservation(idProprietaire);
CREATE INDEX idx_demande_gardien ON DemandeReservation(idGardien);
CREATE INDEX idx_demande_dates ON DemandeReservation(dateDebut, dateFin);
CREATE INDEX idx_demande_statut ON DemandeReservation(statutDemande);

CREATE INDEX idx_disponibilite_gardien ON Disponibilite(idGardien);
CREATE INDEX idx_disponibilite_dates ON Disponibilite(dateDebut, dateFin);

CREATE INDEX idx_service_gardien ON Service(idGardien);
CREATE INDEX idx_service_type ON Service(typeService);

CREATE INDEX idx_avis_gardien ON Avis(idGardien);

CREATE INDEX idx_paiement_reservation ON Paiement(idReservation);

CREATE INDEX idx_animal_proprietaire ON Animal(idProprietaire);

CREATE INDEX idx_gardien_utilisateur ON GardienAnimaux(idGardien);



-- DONNÉES

INSERT INTO Utilisateur (nom, prenom, email, numTelephone, adresse, dateInscription, motDePasse, role, photoDeProfil) VALUES
('Tremblay', 'Jeremie', 'jeremie.tremblay@gmail.com', '5814432001', '123 rue de la Fontaine', '2020-03-15', 'Pass0001', 'Proprietaire', 'https://randomuser.me/api/portraits/men/1.jpg'),
('Gagnon', 'Alice', 'alice.gagnon@gmail.com', '5814432002', '45 rue Principale', '2021-06-18', 'Pass0002', 'Gardien', 'https://randomuser.me/api/portraits/women/1.jpg'),
('Roy', 'Marc', 'marc.roy@gmail.com', '5814432003', '78 rue du Parc', '2022-01-10', 'Pass0003', 'Proprietaire', 'https://randomuser.me/api/portraits/men/2.jpg'),
('Cote', 'Sophie', 'sophie.cote@gmail.com', '5814432004', '12 rue des Pins', '2023-09-05', 'Pass0004', 'Gardien', 'https://randomuser.me/api/portraits/women/2.jpg'),
('Bouchard', 'David', 'david.bouchard@gmail.com', '5814432005', '90 avenue Royale', '2024-11-18', 'Pass0005', 'Proprietaire', 'https://randomuser.me/api/portraits/men/3.jpg'),
('Pelletier', 'Julie', 'julie.pelletier@gmail.com', '5814432006', '33 rue Saint-Jean', '2020-07-22', 'Pass0006', 'Gardien', 'https://randomuser.me/api/portraits/women/3.jpg'),
('Lavoie', 'Thomas', 'thomas.lavoie@gmail.com', '5814432007', '88 rue Commerciale', '2021-12-01', 'Pass0007', 'Proprietaire', 'https://randomuser.me/api/portraits/men/4.jpg'),
('Fortin', 'Emma', 'emma.fortin@gmail.com', '5814432008', '17 rue Centrale', '2022-04-14', 'Pass0008', 'Gardien', 'https://randomuser.me/api/portraits/women/4.jpg'),
('Leclerc', 'Alex', 'alex.leclerc@gmail.com', '5814432009', '56 rue du Lac', '2023-02-28', 'Pass0009', 'Proprietaire', 'https://randomuser.me/api/portraits/men/5.jpg'),
('Bergeron', 'Nicolas', 'nicolas.bergeron@gmail.com', '5814432010', '101 rue Maple', '2025-08-19', 'Pass0010', 'Gardien', 'https://randomuser.me/api/portraits/women/5.jpg'),
('Simard', 'Chloe', 'chloe.simard@gmail.com', '5814432011', '22 rue des Saules', '2020-10-10', 'Pass0011', 'Proprietaire', 'https://randomuser.me/api/portraits/women/6.jpg'),
('Morin', 'Antoine', 'antoine.morin@gmail.com', '5814432012', '64 rue de la Gare', '2021-03-03', 'Pass0012', 'Gardien', 'https://randomuser.me/api/portraits/men/6.jpg'),
('Gauthier', 'Laura', 'laura.gauthier@gmail.com', '5814432013', '77 rue Bellevue', '2022-06-17', 'Pass0013', 'Proprietaire', 'https://randomuser.me/api/portraits/women/7.jpg'),
('Paquette', 'Kevin', 'kevin.paquette@gmail.com', '5814432014', '9 rue du Moulin', '2023-01-25', 'Pass0014', 'Gardien', 'https://randomuser.me/api/portraits/men/7.jpg'),
('Rousseau', 'Mia', 'mia.rousseau@gmail.com', '5814432015', '18 rue du Centre', '2024-05-09', 'Pass0015', 'Proprietaire', 'https://randomuser.me/api/portraits/women/8.jpg'),
('Caron', 'Louis', 'louis.caron@gmail.com', '5814432016', '39 rue des Erables', '2025-09-30', 'Pass0016', 'Gardien', 'https://randomuser.me/api/portraits/men/8.jpg'),
('Beaulieu', 'Sarah', 'sarah.beaulieu@gmail.com', '5814432017', '120 rue St-Paul', '2026-02-14', 'Pass0017', 'Proprietaire', 'https://randomuser.me/api/portraits/women/9.jpg'),
('Blais', 'Ethan', 'ethan.blais@gmail.com', '5814432018', '55 rue des Champs', '2020-11-11', 'Pass0018', 'Gardien', 'https://randomuser.me/api/portraits/men/9.jpg'),
('Martel', 'Zoe', 'zoe.martel@gmail.com', '5814432019', '41 rue du Nord', '2021-08-08', 'Pass0019', 'Proprietaire', 'https://randomuser.me/api/portraits/women/10.jpg'),
('Lapointe', 'William', 'william.lapointe@gmail.com', '5814432020', '73 rue des Fleurs', '2022-12-12', 'Pass0020', 'Gardien', 'https://randomuser.me/api/portraits/men/10.jpg'),
('Girard', 'Olivier', 'olivier.girard@gmail.com', '5814432021', '14 rue du Port', '2023-03-15', 'Pass0021', 'Proprietaire', 'https://randomuser.me/api/portraits/men/11.jpg'),
('Fournier', 'Camille', 'camille.fournier@gmail.com', '5814432022', '66 rue des Champs', '2024-07-20', 'Pass0022', 'Gardien', 'https://randomuser.me/api/portraits/women/11.jpg'),
('Dupont', 'Raphael', 'raphael.dupont@gmail.com', '5814432023', '88 rue du Marche', '2020-05-01', 'Pass0023', 'Proprietaire', 'https://randomuser.me/api/portraits/men/12.jpg'),
('Gosselin', 'Lea', 'lea.gosselin@gmail.com', '5814432024', '32 rue des Bois', '2021-09-09', 'Pass0024', 'Gardien', 'https://randomuser.me/api/portraits/women/12.jpg'),
('Poulin', 'Mathis', 'mathis.poulin@gmail.com', '5814432025', '10 rue St-Michel', '2022-10-10', 'Pass0025', 'Proprietaire', 'https://randomuser.me/api/portraits/men/13.jpg'),
('Desjardins', 'Clara', 'clara.desjardins@gmail.com', '5814432026', '99 rue des Lilas', '2023-06-06', 'Pass0026', 'Gardien', 'https://randomuser.me/api/portraits/women/13.jpg'),
('Nguyen', 'Hugo', 'hugo.nguyen@gmail.com', '5814432027', '21 rue du Soleil', '2024-04-04', 'Pass0027', 'Proprietaire', 'https://randomuser.me/api/portraits/men/14.jpg'),
('Tran', 'Jade', 'jade.tran@gmail.com', '5814432028', '13 rue des Erables', '2025-01-15', 'Pass0028', 'Gardien', 'https://randomuser.me/api/portraits/women/14.jpg'),
('Lefebvre', 'Maxime', 'maxime.lefebvre@gmail.com', '5814432029', '77 rue du Centre', '2020-03-03', 'Pass0029', 'Proprietaire', 'https://randomuser.me/api/portraits/men/15.jpg'),
('Pelletier', 'Anna', 'anna.pelletier2@gmail.com', '5814432030', '45 rue Bellevue', '2021-08-18', 'Pass0030', 'Gardien', 'https://randomuser.me/api/portraits/women/15.jpg'),
('Cloutier', 'Gabriel', 'gabriel.cloutier@gmail.com', '5814432031', '56 rue des Cedres', '2022-02-02', 'Pass0031', 'Proprietaire', 'https://randomuser.me/api/portraits/men/16.jpg'),
('Boucher', 'Noemie', 'noemie.boucher@gmail.com', '5814432032', '12 rue des Acacias', '2023-03-11', 'Pass0032', 'Gardien', 'https://randomuser.me/api/portraits/women/16.jpg'),
('Couture', 'Simon', 'simon.couture@gmail.com', '5814432033', '34 rue St-Louis', '2024-04-22', 'Pass0033', 'Proprietaire', 'https://randomuser.me/api/portraits/men/17.jpg'),
('Leduc', 'Victoria', 'victoria.leduc@gmail.com', '5814432034', '90 rue des Fleurs', '2020-05-05', 'Pass0034', 'Gardien', 'https://randomuser.me/api/portraits/women/17.jpg'),
('Marchand', 'Benjamin', 'benjamin.marchand@gmail.com', '5814432035', '18 rue du Parc', '2021-06-16', 'Pass0035', 'Proprietaire', 'https://randomuser.me/api/portraits/men/18.jpg'),
('Legault', 'Lisa', 'lisa.legault@gmail.com', '5814432036', '44 rue Royale', '2022-07-07', 'Pass0036', 'Gardien', 'https://randomuser.me/api/portraits/women/18.jpg'),
('Gervais', 'Paul', 'paul.gervais@gmail.com', '5814432037', '27 rue du Lac', '2023-08-09', 'Pass0037', 'Proprietaire', 'https://randomuser.me/api/portraits/men/19.jpg'),
('Vigneault', 'Florence', 'florence.vigneault@gmail.com', '5814432038', '61 rue Centrale', '2024-09-10', 'Pass0038', 'Gardien', 'https://randomuser.me/api/portraits/women/19.jpg'),
('Proulx', 'Yann', 'yann.proulx@gmail.com', '5814432039', '70 rue du Nord', '2020-10-11', 'Pass0039', 'Proprietaire', 'https://randomuser.me/api/portraits/men/20.jpg'),
('Blanchet', 'Maude', 'maude.blanchet@gmail.com', '5814432040', '15 rue Maple', '2021-11-12', 'Pass0040', 'Gardien', 'https://randomuser.me/api/portraits/women/20.jpg'),
('Chevalier', 'Samuel', 'samuel.chevalier@gmail.com', '5814432041', '22 rue des Pins', '2022-12-20', 'Pass0041', 'Proprietaire', 'https://randomuser.me/api/portraits/men/21.jpg'),
('Arsenault', 'Eva', 'eva.arsenault@gmail.com', '5814432042', '88 rue St-Paul', '2023-01-21', 'Pass0042', 'Gardien', 'https://randomuser.me/api/portraits/women/21.jpg'),
('Begin', 'Adam', 'adam.begin@gmail.com', '5814432043', '33 rue des Champs', '2024-02-22', 'Pass0043', 'Proprietaire', 'https://randomuser.me/api/portraits/men/22.jpg'),
('Lacroix', 'Amelie', 'amelie.lacroix@gmail.com', '5814432044', '54 rue du Port', '2020-03-23', 'Pass0044', 'Gardien', 'https://randomuser.me/api/portraits/women/22.jpg'),
('Michaud', 'Theo', 'theo.michaud@gmail.com', '5814432045', '11 rue des Cedres', '2021-04-24', 'Pass0045', 'Proprietaire', 'https://randomuser.me/api/portraits/men/23.jpg'),
('Ouellet', 'Iris', 'iris.ouellet@gmail.com', '5814432046', '98 rue Centrale', '2022-05-25', 'Pass0046', 'Gardien', 'https://randomuser.me/api/portraits/women/23.jpg'),
('Nadeau', 'Laurent', 'laurent.nadeau@gmail.com', '5814432047', '76 rue du Soleil', '2023-06-26', 'Pass0047', 'Proprietaire', 'https://randomuser.me/api/portraits/men/24.jpg'),
('Dubois', 'Isabelle', 'isabelle.dubois@gmail.com', '5814432048', '39 rue des Fleurs', '2024-07-27', 'Pass0048', 'Gardien', 'https://randomuser.me/api/portraits/women/24.jpg'),
('Hamel', 'Patrick', 'patrick.hamel@gmail.com', '5814432049', '20 rue du Parc', '2025-08-28', 'Pass0049', 'Proprietaire', 'https://randomuser.me/api/portraits/men/25.jpg'),
('Tessier', 'Marie', 'marie.tessier@gmail.com', '5814432050', '5 rue Royale', '2020-09-29', 'Pass0050', 'Gardien', 'https://randomuser.me/api/portraits/women/25.jpg'),
('Fontaine', 'Alexis', 'alexis.fontaine@gmail.com', '5814432051', '10 rue des Lilas', '2021-01-05', 'Pass0051', 'Proprietaire', 'https://randomuser.me/api/portraits/men/26.jpg'),
('Carpentier', 'Elise', 'elise.carpentier@gmail.com', '5814432052', '11 rue des Erables', '2022-02-06', 'Pass0052', 'Gardien', 'https://randomuser.me/api/portraits/women/26.jpg'),
('Lepage', 'Felix', 'felix.lepage@gmail.com', '5814432053', '12 rue du Lac', '2023-03-07', 'Pass0053', 'Proprietaire', 'https://randomuser.me/api/portraits/men/27.jpg'),
('Dube', 'Charlotte', 'charlotte.dube@gmail.com', '5814432054', '13 rue Bellevue', '2024-04-08', 'Pass0054', 'Gardien', 'https://randomuser.me/api/portraits/women/27.jpg'),
('Masse', 'Sebastien', 'sebastien.masse@gmail.com', '5814432055', '14 rue du Centre', '2020-05-09', 'Pass0055', 'Proprietaire', 'https://randomuser.me/api/portraits/men/28.jpg'),
('Picard', 'Amelie', 'amelie.picard@gmail.com', '5814432056', '15 rue St-Jean', '2021-06-10', 'Pass0056', 'Gardien', 'https://randomuser.me/api/portraits/women/28.jpg'),
('Charron', 'Julien', 'julien.charron@gmail.com', '5814432057', '16 rue Maple', '2022-07-11', 'Pass0057', 'Proprietaire', 'https://randomuser.me/api/portraits/men/29.jpg'),
('Belanger', 'Lucie', 'lucie.belanger@gmail.com', '5814432058', '17 rue du Port', '2023-08-12', 'Pass0058', 'Gardien', 'https://randomuser.me/api/portraits/women/29.jpg'),
('Lemieux', 'Charles', 'charles.lemieux@gmail.com', '5814432059', '18 avenue Royale', '2024-09-13', 'Pass0059', 'Proprietaire', 'https://randomuser.me/api/portraits/men/30.jpg'),
('Dion', 'Stephanie', 'stephanie.dion@gmail.com', '5814432060', '19 rue des Bois', '2020-10-14', 'Pass0060', 'Gardien', 'https://randomuser.me/api/portraits/women/30.jpg'),
('Corriveau', 'Nathan', 'nathan.corriveau@gmail.com', '5814432061', '20 rue Centrale', '2021-11-15', 'Pass0061', 'Proprietaire', 'https://randomuser.me/api/portraits/men/31.jpg'),
('Savard', 'Emilie', 'emilie.savard@gmail.com', '5814432062', '21 rue des Saules', '2022-12-16', 'Pass0062', 'Gardien', 'https://randomuser.me/api/portraits/women/31.jpg'),
('Parent', 'Benoit', 'benoit.parent@gmail.com', '5814432063', '22 rue du Moulin', '2023-01-17', 'Pass0063', 'Proprietaire', 'https://randomuser.me/api/portraits/men/32.jpg'),
('Audet', 'Valerie', 'valerie.audet@gmail.com', '5814432064', '23 rue des Champs', '2024-02-18', 'Pass0064', 'Gardien', 'https://randomuser.me/api/portraits/women/32.jpg'),
('Boivin', 'Mathieu', 'mathieu.boivin@gmail.com', '5814432065', '24 rue du Soleil', '2020-03-19', 'Pass0065', 'Proprietaire', 'https://randomuser.me/api/portraits/men/33.jpg'),
('Grenier', 'Audrey', 'audrey.grenier@gmail.com', '5814432066', '25 rue St-Paul', '2021-04-20', 'Pass0066', 'Gardien', 'https://randomuser.me/api/portraits/women/33.jpg'),
('Venne', 'Nicolas', 'nicolas.venne@gmail.com', '5814432067', '26 rue du Nord', '2022-05-21', 'Pass0067', 'Proprietaire', 'https://randomuser.me/api/portraits/men/34.jpg'),
('Houle', 'Melissa', 'melissa.houle@gmail.com', '5814432068', '27 rue des Pins', '2023-06-22', 'Pass0068', 'Gardien', 'https://randomuser.me/api/portraits/women/34.jpg'),
('Lafleur', 'Jerome', 'jerome.lafleur@gmail.com', '5814432069', '28 rue Commerciale', '2024-07-23', 'Pass0069', 'Proprietaire', 'https://randomuser.me/api/portraits/men/35.jpg'),
('Levesque', 'Genevieve', 'genevieve.levesque@gmail.com', '5814432070', '29 rue du Lac', '2020-08-24', 'Pass0070', 'Gardien', 'https://randomuser.me/api/portraits/women/35.jpg'),
('Bourque', 'Pascal', 'pascal.bourque@gmail.com', '5814432071', '30 rue des Erables', '2021-09-25', 'Pass0071', 'Proprietaire', 'https://randomuser.me/api/portraits/men/36.jpg'),
('Poirier', 'Natalie', 'natalie.poirier@gmail.com', '5814432072', '31 rue Bellevue', '2022-10-26', 'Pass0072', 'Gardien', 'https://randomuser.me/api/portraits/women/36.jpg'),
('Mailloux', 'Dominic', 'dominic.mailloux@gmail.com', '5814432073', '32 rue du Parc', '2023-11-27', 'Pass0073', 'Proprietaire', 'https://randomuser.me/api/portraits/men/37.jpg'),
('Hudon', 'Vanessa', 'vanessa.hudon@gmail.com', '5814432074', '33 rue Royale', '2024-12-28', 'Pass0074', 'Gardien', 'https://randomuser.me/api/portraits/women/37.jpg'),
('Renaud', 'Francois', 'francois.renaud@gmail.com', '5814432075', '34 rue des Fleurs', '2020-01-29', 'Pass0075', 'Proprietaire', 'https://randomuser.me/api/portraits/men/38.jpg'),
('Labonte', 'Josee', 'josee.labonte@gmail.com', '5814432076', '35 rue du Centre', '2021-02-01', 'Pass0076', 'Gardien', 'https://randomuser.me/api/portraits/women/38.jpg'),
('Champagne', 'Eric', 'eric.champagne@gmail.com', '5814432077', '36 rue St-Louis', '2022-03-02', 'Pass0077', 'Proprietaire', 'https://randomuser.me/api/portraits/men/39.jpg'),
('Lachance', 'Caroline', 'caroline.lachance@gmail.com', '5814432078', '37 rue du Port', '2023-04-03', 'Pass0078', 'Gardien', 'https://randomuser.me/api/portraits/women/39.jpg'),
('Turgeon', 'Alexandre', 'alexandre.turgeon@gmail.com', '5814432079', '38 rue Maple', '2024-05-04', 'Pass0079', 'Proprietaire', 'https://randomuser.me/api/portraits/men/40.jpg'),
('Demers', 'Nathalie', 'nathalie.demers@gmail.com', '5814432080', '39 rue du Soleil', '2020-06-05', 'Pass0080', 'Gardien', 'https://randomuser.me/api/portraits/women/40.jpg'),
('Vachon', 'Philippe', 'philippe.vachon@gmail.com', '5814432081', '40 rue des Cedres', '2021-07-06', 'Pass0081', 'Proprietaire', 'https://randomuser.me/api/portraits/men/41.jpg'),
('Charbonneau', 'Annie', 'annie.charbonneau@gmail.com', '5814432082', '41 rue St-Jean', '2022-08-07', 'Pass0082', 'Gardien', 'https://randomuser.me/api/portraits/women/41.jpg'),
('Desrosiers', 'Patrice', 'patrice.desrosiers@gmail.com', '5814432083', '42 rue du Lac', '2023-09-08', 'Pass0083', 'Proprietaire', 'https://randomuser.me/api/portraits/men/42.jpg'),
('Boisvert', 'Sylvie', 'sylvie.boisvert@gmail.com', '5814432084', '43 rue des Lilas', '2024-10-09', 'Pass0084', 'Gardien', 'https://randomuser.me/api/portraits/women/42.jpg'),
('Mercier', 'Christian', 'christian.mercier@gmail.com', '5814432085', '44 rue Centrale', '2020-11-10', 'Pass0085', 'Proprietaire', 'https://randomuser.me/api/portraits/men/43.jpg'),
('Forget', 'Isabelle', 'isabelle.forget@gmail.com', '5814432086', '45 rue du Moulin', '2021-12-11', 'Pass0086', 'Gardien', 'https://randomuser.me/api/portraits/women/43.jpg'),
('Samson', 'Vincent', 'vincent.samson@gmail.com', '5814432087', '46 rue des Saules', '2022-01-12', 'Pass0087', 'Proprietaire', 'https://randomuser.me/api/portraits/men/44.jpg'),
('Rheaume', 'Martine', 'martine.rheaume@gmail.com', '5814432088', '47 rue du Nord', '2023-02-13', 'Pass0088', 'Gardien', 'https://randomuser.me/api/portraits/women/44.jpg'),
('Lacombe', 'Frederic', 'frederic.lacombe@gmail.com', '5814432089', '48 rue St-Paul', '2024-03-14', 'Pass0089', 'Proprietaire', 'https://randomuser.me/api/portraits/men/45.jpg'),
('Grondin', 'Pascale', 'pascale.grondin@gmail.com', '5814432090', '49 rue des Bois', '2020-04-15', 'Pass0090', 'Gardien', 'https://randomuser.me/api/portraits/women/45.jpg'),
('Thibault', 'Jonathan', 'jonathan.thibault@gmail.com', '5814432091', '50 avenue Royale', '2021-05-16', 'Pass0091', 'Proprietaire', 'https://randomuser.me/api/portraits/men/46.jpg'),
('Perron', 'Helene', 'helene.perron@gmail.com', '5814432092', '51 rue des Champs', '2022-06-17', 'Pass0092', 'Gardien', 'https://randomuser.me/api/portraits/women/46.jpg'),
('Dagenais', 'Mickael', 'mickael.dagenais@gmail.com', '5814432093', '52 rue du Parc', '2023-07-18', 'Pass0093', 'Proprietaire', 'https://randomuser.me/api/portraits/men/47.jpg'),
('Francoeur', 'Danielle', 'danielle.francoeur@gmail.com', '5814432094', '53 rue Bellevue', '2024-08-19', 'Pass0094', 'Gardien', 'https://randomuser.me/api/portraits/women/47.jpg'),
('Beland', 'Sebastien', 'sebastien.beland@gmail.com', '5814432095', '54 rue du Soleil', '2020-09-20', 'Pass0095', 'Proprietaire', 'https://randomuser.me/api/portraits/men/48.jpg'),
('Fortier', 'Karine', 'karine.fortier@gmail.com', '5814432096', '55 rue des Erables', '2021-10-21', 'Pass0096', 'Gardien', 'https://randomuser.me/api/portraits/women/48.jpg'),
('Langlois', 'Stephane', 'stephane.langlois@gmail.com', '5814432097', '56 rue St-Louis', '2022-11-22', 'Pass0097', 'Proprietaire', 'https://randomuser.me/api/portraits/men/49.jpg'),
('Brodeur', 'Veronique', 'veronique.brodeur@gmail.com', '5814432098', '57 rue du Port', '2023-12-23', 'Pass0098', 'Gardien', 'https://randomuser.me/api/portraits/women/49.jpg'),
('Cormier', 'Daniel', 'daniel.cormier@gmail.com', '5814432099', '58 rue Maple', '2024-01-24', 'Pass0099', 'Proprietaire', 'https://randomuser.me/api/portraits/men/50.jpg'),
('Giroux', 'Monique', 'monique.giroux@gmail.com', '5814432100', '59 rue des Fleurs', '2020-02-25', 'Pass0100', 'Gardien', 'https://randomuser.me/api/portraits/women/50.jpg');

INSERT INTO Animal (nom, espece, race, age, poids, idProprietaire, sexe, temperament, besoinsSpeciaux, photo) VALUES
('Chien1','Chien','Labrador',5,30,1,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=1'),
('Chat2','Chat','Siamois',3,5,3,'Femelle','Calme','Aucun','https://placekitten.com/500/500'),
('Oiseau3','Oiseau','Perroquet',4,1,5,'Mâle','Bruyant','Aucun','https://loremflickr.com/500/500/bird'),
('Lapin4','Lapin','Nain',2,2,7,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet5','Furet','Domestique',3,1,9,'Mâle','Curieux','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster6','Hamster','Russe',1,1,11,'Femelle','Actif','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien7','Chien','Boxer',6,32,13,'Mâle','Protecteur','Aucun','https://placedog.net/500/500?id=2'),
('Chat8','Chat','Persan',4,5,15,'Femelle','Calme','Brossage','https://placekitten.com/501/500'),
('Oiseau9','Oiseau','Ara',5,1,17,'Mâle','Sociable','Aucun','https://loremflickr.com/500/500/parrot'),
('Lapin10','Lapin','Angora',3,3,19,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet11','Furet','Albinos',2,1,21,'Mâle','Joueur','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster12','Hamster','Doré',2,1,23,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien13','Chien','Beagle',4,20,25,'Mâle','Curieux','Aucun','https://placedog.net/500/500?id=3'),
('Chat14','Chat','Bengal',2,4,27,'Femelle','Énergique','Aucun','https://placekitten.com/502/500'),
('Oiseau15','Oiseau','Canari',2,1,29,'Mâle','Chanteur','Aucun','https://loremflickr.com/500/500/canary'),
('Lapin16','Lapin','Bélier',2,2,31,'Femelle','Douce','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet17','Furet','Domestique',3,1,33,'Mâle','Actif','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster18','Hamster','Chinois',1,1,35,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien19','Chien','Husky',3,25,37,'Mâle','Actif','Exercice','https://placedog.net/500/500?id=4'),
('Chat20','Chat','Maine Coon',3,6,39,'Femelle','Indépendante','Aucun','https://placekitten.com/503/500'),
('Oiseau21','Oiseau','Perruche',3,1,41,'Mâle','Actif','Aucun','https://loremflickr.com/500/500/budgie'),
('Lapin22','Lapin','Nain',1,2,43,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet23','Furet','Domestique',4,1,45,'Mâle','Curieux','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster24','Hamster','Russe',1,1,47,'Femelle','Actif','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien25','Chien','Golden Retriever',4,28,49,'Mâle','Affectueux','Aucun','https://placedog.net/500/500?id=5'),
('Chat26','Chat','Ragdoll',2,6,51,'Femelle','Calme','Aucun','https://placekitten.com/504/500'),
('Oiseau27','Oiseau','Cacatoès',6,1,53,'Mâle','Bruyant','Attention','https://loremflickr.com/500/500/cockatoo'),
('Lapin28','Lapin','Angora',4,3,55,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet29','Furet','Albinos',2,1,57,'Mâle','Joueur','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster30','Hamster','Doré',2,1,59,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/hamster'),

-- répétition logique pour atteindre 100

('Chien31','Chien','Mixte',3,22,61,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=6'),
('Chat32','Chat','Mixte',2,5,63,'Femelle','Calme','Aucun','https://placekitten.com/505/500'),
('Oiseau33','Oiseau','Perroquet',5,1,65,'Mâle','Bruyant','Aucun','https://loremflickr.com/500/500/bird'),
('Lapin34','Lapin','Nain',2,2,67,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet35','Furet','Domestique',3,1,69,'Mâle','Curieux','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster36','Hamster','Russe',1,1,71,'Femelle','Actif','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien37','Chien','Mixte',4,24,73,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=7'),
('Chat38','Chat','Mixte',3,5,75,'Femelle','Calme','Aucun','https://placekitten.com/506/500'),
('Oiseau39','Oiseau','Ara',6,1,77,'Mâle','Sociable','Aucun','https://loremflickr.com/500/500/parrot'),
('Lapin40','Lapin','Angora',3,3,79,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet41','Furet','Albinos',2,1,81,'Mâle','Joueur','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster42','Hamster','Doré',2,1,83,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien43','Chien','Mixte',3,23,85,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=8'),
('Chat44','Chat','Mixte',2,5,87,'Femelle','Calme','Aucun','https://placekitten.com/507/500'),
('Oiseau45','Oiseau','Canari',2,1,89,'Mâle','Chanteur','Aucun','https://loremflickr.com/500/500/canary'),
('Lapin46','Lapin','Nain',2,2,91,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet47','Furet','Domestique',3,1,93,'Mâle','Curieux','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster48','Hamster','Russe',1,1,95,'Femelle','Actif','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien49','Chien','Mixte',4,25,97,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=9'),
('Chat50','Chat','Mixte',3,5,99,'Femelle','Calme','Aucun','https://placekitten.com/508/500'),

('Chien51','Chien','Mixte',3,22,1,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=10'),
('Chat52','Chat','Mixte',2,5,3,'Femelle','Calme','Aucun','https://placekitten.com/509/500'),
('Oiseau53','Oiseau','Perroquet',4,1,5,'Mâle','Bruyant','Aucun','https://loremflickr.com/500/500/bird'),
('Lapin54','Lapin','Nain',2,2,7,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),
('Furet55','Furet','Domestique',3,1,9,'Mâle','Curieux','Aucun','https://loremflickr.com/500/500/ferret'),
('Hamster56','Hamster','Russe',1,1,11,'Femelle','Actif','Aucun','https://loremflickr.com/500/500/hamster'),

('Chien57','Chien','Mixte',4,24,13,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=11'),
('Chat58','Chat','Mixte',3,5,15,'Femelle','Calme','Aucun','https://placekitten.com/510/500'),
('Oiseau59','Oiseau','Ara',5,1,17,'Mâle','Sociable','Aucun','https://loremflickr.com/500/500/parrot'),
('Lapin60','Lapin','Angora',3,3,19,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien61','Chien','Mixte',3,22,21,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=12'),
('Chat62','Chat','Mixte',2,5,23,'Femelle','Calme','Aucun','https://placekitten.com/511/500'),
('Oiseau63','Oiseau','Canari',2,1,25,'Mâle','Chanteur','Aucun','https://loremflickr.com/500/500/canary'),
('Lapin64','Lapin','Nain',2,2,27,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien65','Chien','Mixte',4,25,29,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=13'),
('Chat66','Chat','Mixte',3,5,31,'Femelle','Calme','Aucun','https://placekitten.com/512/500'),
('Oiseau67','Oiseau','Perroquet',5,1,33,'Mâle','Bruyant','Aucun','https://loremflickr.com/500/500/bird'),
('Lapin68','Lapin','Angora',3,3,35,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien69','Chien','Mixte',3,22,37,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=14'),
('Chat70','Chat','Mixte',2,5,39,'Femelle','Calme','Aucun','https://placekitten.com/513/500'),
('Oiseau71','Oiseau','Ara',6,1,41,'Mâle','Sociable','Aucun','https://loremflickr.com/500/500/parrot'),
('Lapin72','Lapin','Nain',2,2,43,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien73','Chien','Mixte',4,24,45,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=15'),
('Chat74','Chat','Mixte',3,5,47,'Femelle','Calme','Aucun','https://placekitten.com/514/500'),
('Oiseau75','Oiseau','Canari',2,1,49,'Mâle','Chanteur','Aucun','https://loremflickr.com/500/500/canary'),
('Lapin76','Lapin','Angora',3,3,51,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien77','Chien','Mixte',3,22,53,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=16'),
('Chat78','Chat','Mixte',2,5,55,'Femelle','Calme','Aucun','https://placekitten.com/515/500'),
('Oiseau79','Oiseau','Perroquet',5,1,57,'Mâle','Bruyant','Aucun','https://loremflickr.com/500/500/bird'),
('Lapin80','Lapin','Nain',2,2,59,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien81','Chien','Mixte',4,25,61,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=17'),
('Chat82','Chat','Mixte',3,5,63,'Femelle','Calme','Aucun','https://placekitten.com/516/500'),
('Oiseau83','Oiseau','Ara',6,1,65,'Mâle','Sociable','Aucun','https://loremflickr.com/500/500/parrot'),
('Lapin84','Lapin','Angora',3,3,67,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien85','Chien','Mixte',3,22,69,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=18'),
('Chat86','Chat','Mixte',2,5,71,'Femelle','Calme','Aucun','https://placekitten.com/517/500'),
('Oiseau87','Oiseau','Canari',2,1,73,'Mâle','Chanteur','Aucun','https://loremflickr.com/500/500/canary'),
('Lapin88','Lapin','Nain',2,2,75,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien89','Chien','Mixte',4,24,77,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=19'),
('Chat90','Chat','Mixte',3,5,79,'Femelle','Calme','Aucun','https://placekitten.com/518/500'),
('Oiseau91','Oiseau','Perroquet',5,1,81,'Mâle','Bruyant','Aucun','https://loremflickr.com/500/500/bird'),
('Lapin92','Lapin','Angora',3,3,83,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien93','Chien','Mixte',3,22,85,'Mâle','Actif','Aucun','https://placedog.net/500/500?id=20'),
('Chat94','Chat','Mixte',2,5,87,'Femelle','Calme','Aucun','https://placekitten.com/519/500'),
('Oiseau95','Oiseau','Ara',6,1,89,'Mâle','Sociable','Aucun','https://loremflickr.com/500/500/parrot'),
('Lapin96','Lapin','Nain',2,2,91,'Femelle','Timide','Aucun','https://loremflickr.com/500/500/rabbit'),

('Chien97','Chien','Mixte',4,25,93,'Mâle','Joueur','Aucun','https://placedog.net/500/500?id=21'),
('Chat98','Chat','Mixte',3,5,95,'Femelle','Calme','Aucun','https://placekitten.com/520/500'),
('Oiseau99','Oiseau','Canari',2,1,97,'Mâle','Chanteur','Aucun','https://loremflickr.com/500/500/canary'),
('Lapin100','Lapin','Angora',3,3,99,'Femelle','Calme','Aucun','https://loremflickr.com/500/500/rabbit');

INSERT INTO GardienAnimaux (idGardien, experience, tarifHoraire, description, zoneService, verificationIdentite) VALUES
(2,5,20,'Gardienne expérimentée avec chats et chiens','Québec',TRUE),
(4,3,18,'Aime les animaux et très patiente','Québec',FALSE),
(6,7,25,'Gardienne professionnelle fiable','Québec',TRUE),
(8,2,15,'Débute mais motivée','Québec',FALSE),
(10,6,22,'Très fiable et ponctuelle','Québec',TRUE),
(12,4,19,'Bonne expérience avec petits animaux','Québec',TRUE),
(14,8,30,'Spécialiste des chiens actifs','Québec',TRUE),
(16,1,15,'Nouvelle gardienne passionnée','Québec',FALSE),
(18,9,32,'Expert en soins animaliers','Québec',TRUE),
(20,5,21,'Aime jouer avec les animaux','Québec',FALSE),

(22,6,23,'Très attentive aux besoins','Québec',TRUE),
(24,2,17,'Disponible et flexible','Québec',FALSE),
(26,7,26,'Expérience variée','Québec',TRUE),
(28,3,18,'Bonne avec chats et lapins','Québec',FALSE),
(30,10,35,'Professionnelle certifiée','Québec',TRUE),
(32,4,20,'Douce et calme','Québec',TRUE),
(34,6,24,'Aime les longues promenades','Québec',FALSE),
(36,1,16,'Débutante motivée','Québec',FALSE),
(38,8,28,'Très recommandée','Québec',TRUE),
(40,5,22,'Fiable et ponctuelle','Québec',TRUE),

(42,3,19,'Expérience modérée','Québec',FALSE),
(44,7,27,'Très bon contact avec animaux','Québec',TRUE),
(46,2,17,'Calme et patiente','Québec',FALSE),
(48,9,33,'Expert confirmé','Québec',TRUE),
(50,6,24,'Très responsable','Québec',TRUE),
(52,4,21,'Aime tous les animaux','Québec',FALSE),
(54,8,29,'Très dynamique','Québec',TRUE),
(56,1,15,'Débutant sérieux','Québec',FALSE),
(58,5,22,'Bonne relation animale','Québec',TRUE),
(60,7,26,'Expérience solide','Québec',TRUE),

(62,3,18,'Gentil et attentionné','Québec',FALSE),
(64,6,23,'Très fiable','Québec',TRUE),
(66,2,17,'Calme','Québec',FALSE),
(68,9,34,'Très expérimenté','Québec',TRUE),
(70,5,22,'Flexible','Québec',TRUE),
(72,4,20,'Aime les petits animaux','Québec',FALSE),
(74,7,27,'Très actif','Québec',TRUE),
(76,1,16,'Motivé','Québec',FALSE),
(78,8,30,'Excellent gardien','Québec',TRUE),
(80,6,24,'Responsable','Québec',TRUE),

(82,3,19,'Patient','Québec',FALSE),
(84,7,28,'Très compétent','Québec',TRUE),
(86,2,17,'Calme','Québec',FALSE),
(88,9,35,'Expert','Québec',TRUE),
(90,5,23,'Fiable','Québec',TRUE),
(92,4,21,'Affectueux','Québec',FALSE),
(94,8,29,'Très bon service','Québec',TRUE),
(96,1,15,'Débutant','Québec',FALSE),
(98,6,25,'Expérience correcte','Québec',TRUE),
(100,7,27,'Très recommandé','Québec',TRUE);

INSERT INTO Disponibilite (idGardien, dateDebut, dateFin, statutDisponibilite) VALUES
(2,'2026-05-01','2026-05-05','DISPONIBLE'),
(2,'2026-05-10','2026-05-15','RESERVE'),

(4,'2026-05-02','2026-05-06','DISPONIBLE'),
(4,'2026-05-11','2026-05-16','INDISPONIBLE'),

(6,'2026-05-03','2026-05-07','DISPONIBLE'),
(6,'2026-05-12','2026-05-17','RESERVE'),

(8,'2026-05-04','2026-05-08','DISPONIBLE'),
(8,'2026-05-13','2026-05-18','INDISPONIBLE'),

(10,'2026-05-05','2026-05-09','DISPONIBLE'),
(10,'2026-05-14','2026-05-19','RESERVE'),

(12,'2026-05-06','2026-05-10','DISPONIBLE'),
(12,'2026-05-15','2026-05-20','INDISPONIBLE'),

(14,'2026-05-07','2026-05-11','DISPONIBLE'),
(14,'2026-05-16','2026-05-21','RESERVE'),

(16,'2026-05-08','2026-05-12','DISPONIBLE'),
(16,'2026-05-17','2026-05-22','INDISPONIBLE'),

(18,'2026-05-09','2026-05-13','DISPONIBLE'),
(18,'2026-05-18','2026-05-23','RESERVE'),

(20,'2026-05-10','2026-05-14','DISPONIBLE'),
(20,'2026-05-19','2026-05-24','INDISPONIBLE'),

(22,'2026-05-11','2026-05-15','DISPONIBLE'),
(22,'2026-05-20','2026-05-25','RESERVE'),

(24,'2026-05-12','2026-05-16','DISPONIBLE'),
(24,'2026-05-21','2026-05-26','INDISPONIBLE'),

(26,'2026-05-13','2026-05-17','DISPONIBLE'),
(26,'2026-05-22','2026-05-27','RESERVE'),

(28,'2026-05-14','2026-05-18','DISPONIBLE'),
(28,'2026-05-23','2026-05-28','INDISPONIBLE'),

(30,'2026-05-15','2026-05-19','DISPONIBLE'),
(30,'2026-05-24','2026-05-29','RESERVE'),

(32,'2026-05-16','2026-05-20','DISPONIBLE'),
(32,'2026-05-25','2026-05-30','INDISPONIBLE'),

(34,'2026-05-17','2026-05-21','DISPONIBLE'),
(34,'2026-05-26','2026-05-31','RESERVE'),

(36,'2026-05-18','2026-05-22','DISPONIBLE'),
(36,'2026-05-27','2026-06-01','INDISPONIBLE'),

(38,'2026-05-19','2026-05-23','DISPONIBLE'),
(38,'2026-05-28','2026-06-02','RESERVE'),

(40,'2026-05-20','2026-05-24','DISPONIBLE'),
(40,'2026-05-29','2026-06-03','INDISPONIBLE'),

(42,'2026-05-21','2026-05-25','DISPONIBLE'),
(42,'2026-05-30','2026-06-04','RESERVE'),

(44,'2026-05-22','2026-05-26','DISPONIBLE'),
(44,'2026-05-31','2026-06-05','INDISPONIBLE'),

(46,'2026-05-23','2026-05-27','DISPONIBLE'),
(46,'2026-06-01','2026-06-06','RESERVE'),

(48,'2026-05-24','2026-05-28','DISPONIBLE'),
(48,'2026-06-02','2026-06-07','INDISPONIBLE'),

(50,'2026-05-25','2026-05-29','DISPONIBLE'),
(50,'2026-06-03','2026-06-08','RESERVE'),

(52,'2026-05-26','2026-05-30','DISPONIBLE'),
(52,'2026-06-04','2026-06-09','INDISPONIBLE'),

(54,'2026-05-27','2026-05-31','DISPONIBLE'),
(54,'2026-06-05','2026-06-10','RESERVE'),

(56,'2026-05-28','2026-06-01','DISPONIBLE'),
(56,'2026-06-06','2026-06-11','INDISPONIBLE'),

(58,'2026-05-29','2026-06-02','DISPONIBLE'),
(58,'2026-06-07','2026-06-12','RESERVE'),

(60,'2026-05-30','2026-06-03','DISPONIBLE'),
(60,'2026-06-08','2026-06-13','INDISPONIBLE'),

(62,'2026-05-31','2026-06-04','DISPONIBLE'),
(62,'2026-06-09','2026-06-14','RESERVE'),

(64,'2026-06-01','2026-06-05','DISPONIBLE'),
(64,'2026-06-10','2026-06-15','INDISPONIBLE'),

(66,'2026-06-02','2026-06-06','DISPONIBLE'),
(66,'2026-06-11','2026-06-16','RESERVE'),

(68,'2026-06-03','2026-06-07','DISPONIBLE'),
(68,'2026-06-12','2026-06-17','INDISPONIBLE'),

(70,'2026-06-04','2026-06-08','DISPONIBLE'),
(70,'2026-06-13','2026-06-18','RESERVE'),

(72,'2026-06-05','2026-06-09','DISPONIBLE'),
(72,'2026-06-14','2026-06-19','INDISPONIBLE'),

(74,'2026-06-06','2026-06-10','DISPONIBLE'),
(74,'2026-06-15','2026-06-20','RESERVE'),

(76,'2026-06-07','2026-06-11','DISPONIBLE'),
(76,'2026-06-16','2026-06-21','INDISPONIBLE'),

(78,'2026-06-08','2026-06-12','DISPONIBLE'),
(78,'2026-06-17','2026-06-22','RESERVE'),

(80,'2026-06-09','2026-06-13','DISPONIBLE'),
(80,'2026-06-18','2026-06-23','INDISPONIBLE'),

(82,'2026-06-10','2026-06-14','DISPONIBLE'),
(82,'2026-06-19','2026-06-24','RESERVE'),

(84,'2026-06-11','2026-06-15','DISPONIBLE'),
(84,'2026-06-20','2026-06-25','INDISPONIBLE'),

(86,'2026-06-12','2026-06-16','DISPONIBLE'),
(86,'2026-06-21','2026-06-26','RESERVE'),

(88,'2026-06-13','2026-06-17','DISPONIBLE'),
(88,'2026-06-22','2026-06-27','INDISPONIBLE'),

(90,'2026-06-14','2026-06-18','DISPONIBLE'),
(90,'2026-06-23','2026-06-28','RESERVE'),

(92,'2026-06-15','2026-06-19','DISPONIBLE'),
(92,'2026-06-24','2026-06-29','INDISPONIBLE'),

(94,'2026-06-16','2026-06-20','DISPONIBLE'),
(94,'2026-06-25','2026-06-30','RESERVE'),

(96,'2026-06-17','2026-06-21','DISPONIBLE'),
(96,'2026-06-26','2026-07-01','INDISPONIBLE'),

(98,'2026-06-18','2026-06-22','DISPONIBLE'),
(98,'2026-06-27','2026-07-02','RESERVE'),

(100,'2026-06-19','2026-06-23','DISPONIBLE'),
(100,'2026-06-28','2026-07-03','INDISPONIBLE');

INSERT INTO Service (idGardien, typeService, description, dureeEstimee) VALUES
(2,'Promenade','Promenade quotidienne du chien',60),
(2,'Garde à domicile','Garde chez le propriétaire',180),
(2,'Visite','Visite et nourrissage',30),

(4,'Promenade','Promenade quotidienne du chien',60),
(4,'Garde à domicile','Garde chez le propriétaire',180),
(4,'Visite','Visite et nourrissage',30),

(6,'Promenade','Promenade quotidienne du chien',60),
(6,'Garde à domicile','Garde chez le propriétaire',180),
(6,'Visite','Visite et nourrissage',30),

(8,'Promenade','Promenade quotidienne du chien',60),
(8,'Garde à domicile','Garde chez le propriétaire',180),
(8,'Visite','Visite et nourrissage',30),

(10,'Promenade','Promenade quotidienne du chien',60),
(10,'Garde à domicile','Garde chez le propriétaire',180),
(10,'Visite','Visite et nourrissage',30),

(12,'Promenade','Promenade quotidienne du chien',60),
(12,'Garde à domicile','Garde chez le propriétaire',180),
(12,'Visite','Visite et nourrissage',30),

(14,'Promenade','Promenade quotidienne du chien',60),
(14,'Garde à domicile','Garde chez le propriétaire',180),
(14,'Visite','Visite et nourrissage',30),

(16,'Promenade','Promenade quotidienne du chien',60),
(16,'Garde à domicile','Garde chez le propriétaire',180),
(16,'Visite','Visite et nourrissage',30),

(18,'Promenade','Promenade quotidienne du chien',60),
(18,'Garde à domicile','Garde chez le propriétaire',180),
(18,'Visite','Visite et nourrissage',30),

(20,'Promenade','Promenade quotidienne du chien',60),
(20,'Garde à domicile','Garde chez le propriétaire',180),
(20,'Visite','Visite et nourrissage',30),

(22,'Promenade','Promenade quotidienne du chien',60),
(22,'Garde à domicile','Garde chez le propriétaire',180),
(22,'Visite','Visite et nourrissage',30),

(24,'Promenade','Promenade quotidienne du chien',60),
(24,'Garde à domicile','Garde chez le propriétaire',180),
(24,'Visite','Visite et nourrissage',30),

(26,'Promenade','Promenade quotidienne du chien',60),
(26,'Garde à domicile','Garde chez le propriétaire',180),
(26,'Visite','Visite et nourrissage',30),

(28,'Promenade','Promenade quotidienne du chien',60),
(28,'Garde à domicile','Garde chez le propriétaire',180),
(28,'Visite','Visite et nourrissage',30),

(30,'Promenade','Promenade quotidienne du chien',60),
(30,'Garde à domicile','Garde chez le propriétaire',180),
(30,'Visite','Visite et nourrissage',30),

(32,'Promenade','Promenade quotidienne du chien',60),
(32,'Garde à domicile','Garde chez le propriétaire',180),
(32,'Visite','Visite et nourrissage',30),

(34,'Promenade','Promenade quotidienne du chien',60),
(34,'Garde à domicile','Garde chez le propriétaire',180),
(34,'Visite','Visite et nourrissage',30),

(36,'Promenade','Promenade quotidienne du chien',60),
(36,'Garde à domicile','Garde chez le propriétaire',180),
(36,'Visite','Visite et nourrissage',30),

(38,'Promenade','Promenade quotidienne du chien',60),
(38,'Garde à domicile','Garde chez le propriétaire',180),
(38,'Visite','Visite et nourrissage',30),

(40,'Promenade','Promenade quotidienne du chien',60),
(40,'Garde à domicile','Garde chez le propriétaire',180),
(40,'Visite','Visite et nourrissage',30),

(42,'Promenade','Promenade quotidienne du chien',60),
(42,'Garde à domicile','Garde chez le propriétaire',180),
(42,'Visite','Visite et nourrissage',30),

(44,'Promenade','Promenade quotidienne du chien',60),
(44,'Garde à domicile','Garde chez le propriétaire',180),
(44,'Visite','Visite et nourrissage',30),

(46,'Promenade','Promenade quotidienne du chien',60),
(46,'Garde à domicile','Garde chez le propriétaire',180),
(46,'Visite','Visite et nourrissage',30),

(48,'Promenade','Promenade quotidienne du chien',60),
(48,'Garde à domicile','Garde chez le propriétaire',180),
(48,'Visite','Visite et nourrissage',30),

(50,'Promenade','Promenade quotidienne du chien',60),
(50,'Garde à domicile','Garde chez le propriétaire',180),
(50,'Visite','Visite et nourrissage',30),

(52,'Promenade','Promenade quotidienne du chien',60),
(52,'Garde à domicile','Garde chez le propriétaire',180),
(52,'Visite','Visite et nourrissage',30),

(54,'Promenade','Promenade quotidienne du chien',60),
(54,'Garde à domicile','Garde chez le propriétaire',180),
(54,'Visite','Visite et nourrissage',30),

(56,'Promenade','Promenade quotidienne du chien',60),
(56,'Garde à domicile','Garde chez le propriétaire',180),
(56,'Visite','Visite et nourrissage',30),

(58,'Promenade','Promenade quotidienne du chien',60),
(58,'Garde à domicile','Garde chez le propriétaire',180),
(58,'Visite','Visite et nourrissage',30),

(60,'Promenade','Promenade quotidienne du chien',60),
(60,'Garde à domicile','Garde chez le propriétaire',180),
(60,'Visite','Visite et nourrissage',30),

(62,'Promenade','Promenade quotidienne du chien',60),
(62,'Garde à domicile','Garde chez le propriétaire',180),
(62,'Visite','Visite et nourrissage',30),

(64,'Promenade','Promenade quotidienne du chien',60),
(64,'Garde à domicile','Garde chez le propriétaire',180),
(64,'Visite','Visite et nourrissage',30),

(66,'Promenade','Promenade quotidienne du chien',60),
(66,'Garde à domicile','Garde chez le propriétaire',180),
(66,'Visite','Visite et nourrissage',30),

(68,'Promenade','Promenade quotidienne du chien',60),
(68,'Garde à domicile','Garde chez le propriétaire',180),
(68,'Visite','Visite et nourrissage',30),

(70,'Promenade','Promenade quotidienne du chien',60),
(70,'Garde à domicile','Garde chez le propriétaire',180),
(70,'Visite','Visite et nourrissage',30),

(72,'Promenade','Promenade quotidienne du chien',60),
(72,'Garde à domicile','Garde chez le propriétaire',180),
(72,'Visite','Visite et nourrissage',30),

(74,'Promenade','Promenade quotidienne du chien',60),
(74,'Garde à domicile','Garde chez le propriétaire',180),
(74,'Visite','Visite et nourrissage',30),

(76,'Promenade','Promenade quotidienne du chien',60),
(76,'Garde à domicile','Garde chez le propriétaire',180),
(76,'Visite','Visite et nourrissage',30),

(78,'Promenade','Promenade quotidienne du chien',60),
(78,'Garde à domicile','Garde chez le propriétaire',180),
(78,'Visite','Visite et nourrissage',30),

(80,'Promenade','Promenade quotidienne du chien',60),
(80,'Garde à domicile','Garde chez le propriétaire',180),
(80,'Visite','Visite et nourrissage',30),

(82,'Promenade','Promenade quotidienne du chien',60),
(82,'Garde à domicile','Garde chez le propriétaire',180),
(82,'Visite','Visite et nourrissage',30),

(84,'Promenade','Promenade quotidienne du chien',60),
(84,'Garde à domicile','Garde chez le propriétaire',180),
(84,'Visite','Visite et nourrissage',30),

(86,'Promenade','Promenade quotidienne du chien',60),
(86,'Garde à domicile','Garde chez le propriétaire',180),
(86,'Visite','Visite et nourrissage',30),

(88,'Promenade','Promenade quotidienne du chien',60),
(88,'Garde à domicile','Garde chez le propriétaire',180),
(88,'Visite','Visite et nourrissage',30),

(90,'Promenade','Promenade quotidienne du chien',60),
(90,'Garde à domicile','Garde chez le propriétaire',180),
(90,'Visite','Visite et nourrissage',30),

(92,'Promenade','Promenade quotidienne du chien',60),
(92,'Garde à domicile','Garde chez le propriétaire',180),
(92,'Visite','Visite et nourrissage',30),

(94,'Promenade','Promenade quotidienne du chien',60),
(94,'Garde à domicile','Garde chez le propriétaire',180),
(94,'Visite','Visite et nourrissage',30),

(96,'Promenade','Promenade quotidienne du chien',60),
(96,'Garde à domicile','Garde chez le propriétaire',180),
(96,'Visite','Visite et nourrissage',30),

(98,'Promenade','Promenade quotidienne du chien',60),
(98,'Garde à domicile','Garde chez le propriétaire',180),
(98,'Visite','Visite et nourrissage',30),

(100,'Promenade','Promenade quotidienne du chien',60),
(100,'Garde à domicile','Garde chez le propriétaire',180),
(100,'Visite','Visite et nourrissage',30);

INSERT INTO DemandeReservation (idProprietaire, idGardien, idAnimal, idService, dateDebut, dateFin, message, dateCreation, statutDemande) VALUES
(1,2,1,1,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(3,2,2,2,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(5,2,3,3,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(7,4,4,4,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(9,4,5,5,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(11,4,6,6,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(13,6,7,7,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(15,6,8,8,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(17,6,9,9,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(19,8,10,10,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(21,8,11,11,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(23,8,12,12,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(25,10,13,13,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(27,10,14,14,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(29,10,15,15,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(31,12,16,16,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(33,12,17,17,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(35,12,18,18,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(37,14,19,19,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(39,14,20,20,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(41,14,21,21,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(43,16,22,22,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(45,16,23,23,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(47,16,24,24,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(49,18,25,25,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(51,18,26,26,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(53,18,27,27,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(55,20,28,28,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(57,20,29,29,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(59,20,30,30,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(61,22,31,31,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(63,22,32,32,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(65,22,33,33,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(67,24,34,34,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(69,24,35,35,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(71,24,36,36,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(73,26,37,37,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(75,26,38,38,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(77,26,39,39,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(79,28,40,40,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(81,28,41,41,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(83,28,42,42,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(85,30,43,43,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(87,30,44,44,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(89,30,45,45,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(91,32,46,46,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(93,32,47,47,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(95,32,48,48,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(97,34,49,49,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(99,34,50,50,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(1,34,51,51,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(3,36,52,52,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(5,36,53,53,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(7,36,54,54,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(9,38,55,55,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(11,38,56,56,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(13,38,57,57,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(15,40,58,58,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(17,40,59,59,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(19,40,60,60,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(21,42,61,61,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(23,42,62,62,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(25,42,63,63,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(27,44,64,64,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(29,44,65,65,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(31,44,66,66,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(33,46,67,67,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(35,46,68,68,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(37,46,69,69,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE'),

(39,48,70,70,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(41,48,71,71,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(43,48,72,72,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','ANNULEE'),

(45,50,73,73,'2026-05-01','2026-05-03','Besoin de garde','2026-04-01','EN_ATTENTE'),
(47,50,74,74,'2026-05-05','2026-05-06','Promenade demandée','2026-04-02','ACCEPTEE'),
(49,50,75,75,'2026-05-10','2026-05-12','Visite quotidienne','2026-04-03','REFUSEE');

INSERT INTO Reservation (idDemande, dateConfirmation, statutReservation, prixTotal) VALUES
(2,'2026-04-03','CONFIRMEE',120),
(5,'2026-04-03','EN_COURS',80),
(8,'2026-04-03','TERMINEE',150),
(11,'2026-04-03','CONFIRMEE',90),
(14,'2026-04-03','EN_COURS',110),
(17,'2026-04-03','TERMINEE',130),
(20,'2026-04-03','CONFIRMEE',95),
(23,'2026-04-03','EN_COURS',100),
(26,'2026-04-03','TERMINEE',140),
(29,'2026-04-03','CONFIRMEE',85),

(32,'2026-04-03','EN_COURS',120),
(35,'2026-04-03','TERMINEE',90),
(38,'2026-04-03','CONFIRMEE',110),
(41,'2026-04-03','EN_COURS',105),
(44,'2026-04-03','TERMINEE',135),
(47,'2026-04-03','CONFIRMEE',95),
(50,'2026-04-03','EN_COURS',115),
(53,'2026-04-03','TERMINEE',125),
(56,'2026-04-03','CONFIRMEE',100),
(59,'2026-04-03','EN_COURS',90),

(62,'2026-04-03','TERMINEE',140),
(65,'2026-04-03','CONFIRMEE',85),
(68,'2026-04-03','EN_COURS',120),
(71,'2026-04-03','TERMINEE',130),
(74,'2026-04-03','CONFIRMEE',95);

INSERT INTO Paiement (montant, datePaiement, methodePaiement, idReservation, statutPaiement) VALUES
(120,'2026-04-04','Crédit',151,'PAYE'),
(80,'2026-04-04','Débit',152,'PAYE'),
(150,'2026-04-05','Crédit',153,'PAYE'),
(90,'2026-04-05','Espèce',154,'EN_ATTENTE'),
(110,'2026-04-06','Crédit',155,'PAYE'),

(130,'2026-04-06','Débit',156,'PAYE'),
(95,'2026-04-07','Crédit',157,'PAYE'),
(100,'2026-04-07','Espèce',158,'EN_ATTENTE'),
(140,'2026-04-08','Crédit',159,'PAYE'),
(85,'2026-04-08','Débit',160,'PAYE'),

(120,'2026-04-09','Crédit',161,'PAYE'),
(90,'2026-04-09','Espèce',162,'REMBOURSE'),
(110,'2026-04-10','Crédit',163,'PAYE'),
(105,'2026-04-10','Débit',164,'PAYE'),
(135,'2026-04-11','Crédit',165,'PAYE'),

(95,'2026-04-11','Espèce',166,'EN_ATTENTE'),
(115,'2026-04-12','Crédit',167,'PAYE'),
(125,'2026-04-12','Débit',168,'PAYE'),
(100,'2026-04-13','Crédit',169,'PAYE'),
(90,'2026-04-13','Espèce',170,'REMBOURSE'),

(140,'2026-04-14','Crédit',171,'PAYE'),
(85,'2026-04-14','Débit',172,'PAYE'),
(120,'2026-04-15','Crédit',173,'PAYE'),
(130,'2026-04-15','Espèce',174,'EN_ATTENTE'),
(95,'2026-04-16','Crédit',175,'PAYE');

INSERT INTO Avis (note, commentaire, dateAvis, idProprietaire, idGardien, idReservation) VALUES
-- Gardiens 2 → 100 (5 avis chacun)

(85,'Très bon service','2026-04-20',1,2,151),
(90,'Super gardien','2026-04-21',3,2,152),
(75,'Correct','2026-04-22',5,2,153),
(95,'Excellent','2026-04-23',7,2,154),
(80,'Bon travail','2026-04-24',9,2,155),

(88,'Très satisfait','2026-04-20',11,4,152),
(92,'Parfait','2026-04-21',13,4,153),
(70,'Peut mieux faire','2026-04-22',15,4,154),
(85,'Bon gardien','2026-04-23',17,4,155),
(90,'Recommandé','2026-04-24',19,4,156),

(80,'Bon service','2026-04-20',21,6,153),
(95,'Excellent','2026-04-21',23,6,154),
(78,'Satisfait','2026-04-22',25,6,155),
(88,'Très bien','2026-04-23',27,6,156),
(91,'Top','2026-04-24',29,6,157),

(84,'Très bon','2026-04-20',31,8,154),
(89,'Super','2026-04-21',33,8,155),
(76,'Correct','2026-04-22',35,8,156),
(93,'Excellent','2026-04-23',37,8,157),
(82,'Bien','2026-04-24',39,8,158),

(87,'Bon service','2026-04-20',41,10,155),
(91,'Très satisfait','2026-04-21',43,10,156),
(79,'Correct','2026-04-22',45,10,157),
(94,'Excellent','2026-04-23',47,10,158),
(83,'Bien','2026-04-24',49,10,159),

(85,'Très bon','2026-04-20',51,12,156),
(90,'Super','2026-04-21',53,12,157),
(77,'Correct','2026-04-22',55,12,158),
(92,'Excellent','2026-04-23',57,12,159),
(81,'Bien','2026-04-24',59,12,160),

(86,'Très bien','2026-04-20',61,14,157),
(93,'Top','2026-04-21',63,14,158),
(74,'Moyen','2026-04-22',65,14,159),
(90,'Super','2026-04-23',67,14,160),
(82,'Bien','2026-04-24',69,14,161),

(88,'Très satisfait','2026-04-20',71,16,158),
(91,'Excellent','2026-04-21',73,16,159),
(79,'Correct','2026-04-22',75,16,160),
(94,'Top','2026-04-23',77,16,161),
(83,'Bien','2026-04-24',79,16,162),

(84,'Bon','2026-04-20',81,18,159),
(90,'Très bien','2026-04-21',83,18,160),
(76,'Correct','2026-04-22',85,18,161),
(92,'Excellent','2026-04-23',87,18,162),
(80,'Bien','2026-04-24',89,18,163),

(87,'Très bon','2026-04-20',91,20,160),
(93,'Excellent','2026-04-21',93,20,161),
(78,'Correct','2026-04-22',95,20,162),
(91,'Super','2026-04-23',97,20,163),
(85,'Bien','2026-04-24',99,20,164),

-- même pattern jusqu’à 100

(86,'Très bon','2026-04-20',1,22,161),
(90,'Super','2026-04-21',3,22,162),
(77,'Correct','2026-04-22',5,22,163),
(92,'Excellent','2026-04-23',7,22,164),
(84,'Bien','2026-04-24',9,22,165),

(88,'Très satisfait','2026-04-20',11,24,162),
(91,'Excellent','2026-04-21',13,24,163),
(79,'Correct','2026-04-22',15,24,164),
(94,'Top','2026-04-23',17,24,165),
(83,'Bien','2026-04-24',19,24,166),

(84,'Bon','2026-04-20',21,26,163),
(90,'Très bien','2026-04-21',23,26,164),
(76,'Correct','2026-04-22',25,26,165),
(92,'Excellent','2026-04-23',27,26,166),
(80,'Bien','2026-04-24',29,26,167),

(87,'Très bon','2026-04-20',31,28,164),
(93,'Excellent','2026-04-21',33,28,165),
(78,'Correct','2026-04-22',35,28,166),
(91,'Super','2026-04-23',37,28,167),
(85,'Bien','2026-04-24',39,28,168),

(86,'Très bon','2026-04-20',41,30,165),
(90,'Super','2026-04-21',43,30,166),
(77,'Correct','2026-04-22',45,30,167),
(92,'Excellent','2026-04-23',47,30,168),
(84,'Bien','2026-04-24',49,30,169),

(88,'Très satisfait','2026-04-20',51,32,166),
(91,'Excellent','2026-04-21',53,32,167),
(79,'Correct','2026-04-22',55,32,168),
(94,'Top','2026-04-23',57,32,169),
(83,'Bien','2026-04-24',59,32,170),

(84,'Bon','2026-04-20',61,34,167),
(90,'Très bien','2026-04-21',63,34,168),
(76,'Correct','2026-04-22',65,34,169),
(92,'Excellent','2026-04-23',67,34,170),
(80,'Bien','2026-04-24',69,34,171),

(87,'Très bon','2026-04-20',71,36,168),
(93,'Excellent','2026-04-21',73,36,169),
(78,'Correct','2026-04-22',75,36,170),
(91,'Super','2026-04-23',77,36,171),
(85,'Bien','2026-04-24',79,36,172),

(86,'Très bon','2026-04-20',81,38,169),
(90,'Super','2026-04-21',83,38,170),
(77,'Correct','2026-04-22',85,38,171),
(92,'Excellent','2026-04-23',87,38,172),
(84,'Bien','2026-04-24',89,38,173),

(88,'Très satisfait','2026-04-20',91,40,170),
(91,'Excellent','2026-04-21',93,40,171),
(79,'Correct','2026-04-22',95,40,172),
(94,'Top','2026-04-23',97,40,173),
(83,'Bien','2026-04-24',99,40,174),

(84,'Bon','2026-04-20',1,42,171),
(90,'Très bien','2026-04-21',3,42,172),
(76,'Correct','2026-04-22',5,42,173),
(92,'Excellent','2026-04-23',7,42,174),
(80,'Bien','2026-04-24',9,42,175),

(87,'Très bon','2026-04-20',11,44,172),
(93,'Excellent','2026-04-21',13,44,173),
(78,'Correct','2026-04-22',15,44,174),
(91,'Super','2026-04-23',17,44,175),
(85,'Bien','2026-04-24',19,44,151),

(86,'Très bon','2026-04-20',21,46,173),
(90,'Super','2026-04-21',23,46,174),
(77,'Correct','2026-04-22',25,46,175),
(92,'Excellent','2026-04-23',27,46,151),
(84,'Bien','2026-04-24',29,46,152),

(88,'Très satisfait','2026-04-20',31,48,174),
(91,'Excellent','2026-04-21',33,48,175),
(79,'Correct','2026-04-22',35,48,151),
(94,'Top','2026-04-23',37,48,152),
(83,'Bien','2026-04-24',39,48,153),

(84,'Bon','2026-04-20',41,50,175),
(90,'Très bien','2026-04-21',43,50,151),
(76,'Correct','2026-04-22',45,50,152),
(92,'Excellent','2026-04-23',47,50,153),
(80,'Bien','2026-04-24',49,50,154);

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

SELECT G.*, U.nom, U.prenom, U.email, U.adresse, U.photoDeProfil
        FROM GardienAnimaux G
        JOIN Utilisateur U ON G.idGardien = U.idUtilisateur ;

ALTER TABLE Animal MODIFY photo LONGTEXT;
ALTER TABLE Utilisateur MODIFY photoDeProfil LONGTEXT;

SELECT *
FROM Reservation R
JOIN Demandereservation D ON D.idDemande = R.idDemande
WHERE (D.idProprietaire = 3 OR D.idGardien = 3)
AND R.statutReservation = "CONFIRMEE";