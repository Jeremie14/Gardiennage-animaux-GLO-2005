import pymysql.cursors

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='PabloIsCrazy123',
    # password='Aymen12345',
    db='gardiennage_animaux_GLO2005_2026',
    autocommit=True
)

cursor = connection.cursor()

#Transmet les inscriptions dans la bd
def insert_utilisateur(nom, prenom, email, num, adresse, mot_de_passe):
    request = (f'INSERT INTO Utilisateur(nom, prenom, email, numTelephone, adresse, motDepasse)'
               f'VALUES ("{nom}", "{prenom}", "{email}", "{num}", "{adresse}", "{mot_de_passe}");')
    cursor.execute(request)
    connection.commit()

#Transmet les réservations dans la table reservation
def insert_reservation(date, prix): #Rajouter statut ici?
    request = (f'INSERT INTO Reservation(dateConfirmation, prixTotal) VALUES ("{date}", "{prix}");')
    cursor.execute(request)
    connection.commit()

#Transmet les paiements à la bd
def insert_paiement(montant, date, methode): #Rajouter statut ici aussi?
    request = (f'INSERT INTO Paiement(montant, datePaiement, methodePaiement) VALUES ("{montant}", "{date}", "{methode}");')
    cursor.execute(request)
    connection.commit()

#Transmet les avis à la bd
def insert_avis(note, commentaire, date):
    request = (f'INSERT INTO Avis(note, commentaire, dateAvis) VALUES ("{note}", "{commentaire}", "{date}");')
    cursor.execute(request)
    connection.commit()

#Transmet les disponibilites à la bd
def insert_disponibilite(debut, fin):
    request = (f'INSERT INTO Disponibilite(dateDebut, dateFin) VALUES ("{debut}", "{fin}");')
    cursor.execute(request)
    connection.commit()

#Transmet les services à la bd
def insert_service(type, description, tarif, duree): #Ajouter le id du gardien?
    request = (f'INSERT INTO Service(typeService, description, tarif, dureeEstimee) VALUES ("{type}", "{description}", "{tarif}", "{duree}");')
    cursor.execute(request)
    connection.commit()

#Transmet les demandes de reservation à la bd
def insert_demandeReservation(debut, fin, message, creation): #Ajouter le statut ici
    request = (f'INSERT INTO demandeReservation(dateDebut, dateFin, message, dateCreation) VALUES ("{debut}", "{fin}", "{message}", "{creation}");')
    cursor.execute(request)
    connection.commit()

#Transmet les ajouts d'animaux à la bd
def insert_animal(nom, espece, race, age, poids, sexe, temperament, besoins):
    request = (f'INSERT INTO Animal(nom, espece, race, age, poids, sexe, temperament, besoinsSpeciaux)'
               f' VALUES("{nom}", "{espece}", "{race}", "{age}", "{poids}", "{sexe}", "{temperament}", "{besoins}");')
    cursor.execute(request)
    connection.commit()

def insert_gardien(experience, tarifH, tarifJ, zone, verification, actif):
    request = (f'INSERT INTO GardienAnimaux(experience, tarifHoraire, description, tariffJournalier, zoneService, verficationIdentite, actif) '
               f'VALUES("{experience}", "{tarifH}", "{tarifJ}", "{zone}", "{verification}", "{actif}");')
    cursor.execute(request)
    connection.commit()

