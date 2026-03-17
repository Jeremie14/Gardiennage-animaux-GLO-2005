CREATE DATABASE gardiennage_animaux_GLO2005_2026;


SHOW DATABASES;

USE gardiennage_animaux_GLO2005_2026;
SHOW TABLES;

CREATE TABLE Utilisateur (
    idUtilisateur char(5) PRIMARY KEY,
    nom varchar(100),
    prenom varchar(100),
    email varchar(100),
    numTelephone varchar(20),
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
    idProprietaire char(5) -- FK(fixer plus tard) -> Pas trouvé ailleurs
);

CREATE TABLE GardienAnimaux (
    idGardien char(5) PRIMARY KEY,
    idUtilisateur char(5),
    experience int(2),
    tarifHoraire int(3),
    description varchar(1000),
    evaluationMoyenne varchar(3), -- A modifier --> Fonction calcul moyenne
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
    FOREIGN KEY (idAnimal) REFERENCES Animal(idAnimal)
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
    idAvis char(5),
    note int(3),
    commentaire varchar(1000),
    dateAvis DATE,
    idClient char(5), -- FK a rajouter
    idGardien char(5),
    FOREIGN KEY(idGardien) REFERENCES GardienAnimaux(idGardien)
)