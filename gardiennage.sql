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