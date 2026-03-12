CREATE DATABASE gardiennage_animaux_GLO2005_2026;


SHOW DATABASES;

USE gardiennage_animaux_GLO2005_2026;
SHOW TABLES;

CREATE TABLE Utilisateur (idUtilisateur char(5) PRIMARY KEY,
                          nom varchar(50),
                          prenom varchar(50),
                          email varchar(100),
                          numTelephone varchar(20),
                          adresse varchar(100),
                          dateInscription DATE
);

CREATE TABLE Animal (idAnimal char(5) PRIMARY KEY,
                          nom varchar(50),
                          espece varchar(50),
                          race varchar(50),
                          age int(2),
                          poids int(3),
                          idProprietaire char(5) -- Plus tard, ajouter que cest une fk
);

