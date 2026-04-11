import pymysql.cursors

connection = pymysql.connect(
    host='localhost',
    user='root',
   # password='PabloIsCrazy123',
    password='Aymen12345',
    db='gardiennage_animaux_GLO2005_2026',
    autocommit=True
)

cursor = connection.cursor()


def insert_utilisateur(nom, prenom, email, num, adresse, mot_de_passe, role='Proprietaire'):
    request = (
        f'INSERT INTO Utilisateur(nom, prenom, email, numTelephone, adresse, dateInscription, motDePasse, role) '
        f'VALUES ("{nom}", "{prenom}", "{email}", "{num}", "{adresse}", CURDATE(), "{mot_de_passe}", "{role}");'
    )
    cursor.execute(request)


def get_utilisateur_by_email(email):
    cursor.execute(f'SELECT * FROM Utilisateur WHERE email = "{email}";')
    return cursor.fetchone()


def get_utilisateur_by_id(id_utilisateur):
    cursor.execute(f'SELECT * FROM Utilisateur WHERE idUtilisateur = {id_utilisateur};')
    return cursor.fetchone()


def get_all_utilisateurs():
    cursor.execute('SELECT * FROM Utilisateur;')
    return cursor.fetchall()


def update_utilisateur(id_utilisateur, nom, prenom, email, num, adresse):
    request = (
        f'UPDATE Utilisateur SET nom="{nom}", prenom="{prenom}", email="{email}", '
        f'numTelephone="{num}", adresse="{adresse}" '
        f'WHERE idUtilisateur={id_utilisateur};'
    )
    cursor.execute(request)


def delete_utilisateur(id_utilisateur):
    cursor.execute(f'DELETE FROM Utilisateur WHERE idUtilisateur={id_utilisateur};')


# ─── Animal ──────────────────────────────────────────────────────────────────

#def insert_animal(nom, espece, race, age, poids, id_proprietaire, sexe=None, temperament=None, besoins_speciaux=None):
   # request = (
       # f'INSERT INTO Animal(nom, espece, race, age, poids, idProprietaire, sexe, temperament, besoinsSpeciaux) '
       # f'VALUES ("{nom}", "{espece}", "{race}", {age}, {poids}, {id_proprietaire}, '
       # f'{"NULL" if sexe is None else f\'"{sexe}"\''}, '
       # f'{"NULL" if temperament is None else f\'"{temperament}"\''}, '
       # f'{"NULL" if besoins_speciaux is None else f\'"{besoins_speciaux}"\'});')
      #  cursor.execute(request)


def get_animaux_by_proprietaire(id_proprietaire):
    cursor.execute(f'SELECT * FROM Animal WHERE idProprietaire={id_proprietaire};')
    return cursor.fetchall()


def get_animal_by_id(id_animal):
    cursor.execute(f'SELECT * FROM Animal WHERE idAnimal={id_animal};')
    return cursor.fetchone()


def delete_animal(id_animal):
    cursor.execute(f'DELETE FROM Animal WHERE idAnimal={id_animal};')

def change_animal_picture(id_animal, picture):
    cursor.execute(f'UPDATE Animal SET image="{picture}" WHERE idAnimal={id_animal};')

# ─── GardienAnimaux ──────────────────────────────────────────────────────────

def insert_gardien(id_utilisateur, experience, tarif_horaire, description,
                   tarif_journalier=None, zone_service=None):
    request = (
        f'INSERT INTO GardienAnimaux(idGardien, experience, tarifHoraire, description, zoneService, verificationIdentite) '
        f'VALUES ({id_utilisateur}, {experience}, {tarif_horaire}, "{description}", '
        f'{"NULL" if tarif_journalier is None else tarif_journalier}, '
        #f'{"NULL" if zone_service is None else f\'"{zone_service}"\''}, '
        f'FALSE, TRUE);'
    )
    cursor.execute(request)


def get_gardien_by_id(id_utilisateur):
    cursor.execute(f'SELECT G.*, U.nom, U.prenom, U.email, U.adresse, U.photoDeProfil  '
                   f'FROM GardienAnimaux G '
                   f'JOIN Utilisateur U ON G.idGardien = U.idUtilisateur '
                   f'WHERE G.idGardien={id_utilisateur};')

    return cursor.fetchone()


def get_all_gardiens():
    cursor.execute(
        f'SELECT G.*, U.nom, U.prenom, U.email, U.adresse, U.photoDeProfil '
        f'FROM GardienAnimaux G '
        f'JOIN Utilisateur U ON G.idGardien = U.idUtilisateur ;'
    )
    return cursor.fetchall()


def update_gardien(id_utilisateur, experience, tarif_horaire, description, tarif_journalier, zone_service):
    request = (
        f'UPDATE GardienAnimaux SET experience={experience}, tarifHoraire={tarif_horaire}, '
        f'description="{description}", tariffJournalier={tarif_journalier}, zoneService="{zone_service}" '
        f'WHERE idUtilisateur={id_utilisateur};'
    )
    cursor.execute(request)


# ─── Service ─────────────────────────────────────────────────────────────────

def insert_service(id_gardien, type_service, description, tarif, duree):
    request = (
        f'INSERT INTO Service(idGardien, typeService, description, tarif, dureeEstimee) '
        f'VALUES ({id_gardien}, "{type_service}", "{description}", {tarif}, {duree});'
    )
    cursor.execute(request)


def get_services_by_gardien(id_gardien):
    cursor.execute(f'SELECT * FROM Service WHERE idGardien={id_gardien};')
    return cursor.fetchall()


def get_service_by_id(id_service):
    cursor.execute(f'SELECT * FROM Service WHERE idService={id_service};')
    return cursor.fetchone()


def delete_service(id_service):
    cursor.execute(f'DELETE FROM Service WHERE idService={id_service};')


# ─── Disponibilite ───────────────────────────────────────────────────────────

def insert_disponibilite(id_gardien, debut, fin, statut='DISPONIBLE'):
    request = (
        f'INSERT INTO Disponibilite(idGardien, dateDebut, dateFin, statutDisponibilite) '
        f'VALUES ({id_gardien}, "{debut}", "{fin}", "{statut}");'
    )
    cursor.execute(request)


def get_disponibilites_by_gardien(id_gardien):
    cursor.execute(f'SELECT * FROM Disponibilite WHERE idGardien={id_gardien};')
    return cursor.fetchall()


def update_disponibilite_statut(id_disponibilite, statut):
    cursor.execute(
        f'UPDATE Disponibilite SET statutDisponibilite="{statut}" WHERE idDisponibilite={id_disponibilite};'
    )


# ─── DemandeReservation ──────────────────────────────────────────────────────

def insert_demandeReservation(id_proprietaire, id_gardien, id_animal, id_service,
                              debut, fin, message, creation):
    request = (
        f'INSERT INTO DemandeReservation(idProprietaire, idGardien, idAnimal, idService, '
        f'dateDebut, dateFin, message, dateCreation, statutDemande) '
        f'VALUES ({id_proprietaire}, {id_gardien}, {id_animal}, {id_service}, '
        f'"{debut}", "{fin}", "{message}", "{creation}", "EN_ATTENTE");'
    )
    cursor.execute(request)


def get_demandes_by_proprietaire(id_proprietaire):
    cursor.execute(f'SELECT * FROM DemandeReservation WHERE idProprietaire={id_proprietaire};')
    return cursor.fetchall()


def get_demandes_by_gardien(id_gardien):
    cursor.execute(f'SELECT * FROM DemandeReservation WHERE idGardien={id_gardien};')
    return cursor.fetchall()


def update_statut_demande(id_demande, statut):
    cursor.execute(
        f'UPDATE DemandeReservation SET statutDemande="{statut}" WHERE idDemande={id_demande};'
    )


def get_demande_by_id(id_demande):
    cursor.execute(f'SELECT * FROM DemandeReservation WHERE idDemande={id_demande};')
    return cursor.fetchone()


# ─── Reservation ─────────────────────────────────────────────────────────────

def insert_reservation(id_demande, date, prix, statut='CONFIRMEE'):
    request = (
        f'INSERT INTO Reservation(idDemande, dateConfirmation, statutReservation, prixTotal) '
        f'VALUES ({id_demande}, "{date}", "{statut}", {prix});'
    )
    cursor.execute(request)


def get_reservation_by_id(id_reservation):
    cursor.execute(f'SELECT * FROM Reservation WHERE idReservation={id_reservation};')
    return cursor.fetchone()


def get_reservation_by_demande(id_demande):
    cursor.execute(f'SELECT * FROM Reservation WHERE idDemande={id_demande};')
    return cursor.fetchone()


def update_statut_reservation(id_reservation, statut):
    cursor.execute(
        f'UPDATE Reservation SET statutReservation="{statut}" WHERE idReservation={id_reservation};'
    )


# ─── Paiement ────────────────────────────────────────────────────────────────

def insert_paiement(montant, date, methode, id_reservation, statut='EN_ATTENTE'):
    request = (
        f'INSERT INTO Paiement(montant, datePaiement, methodePaiement, idReservation, statutPaiement) '
        f'VALUES ({montant}, "{date}", "{methode}", {id_reservation}, "{statut}");'
    )
    cursor.execute(request)


def get_paiement_by_reservation(id_reservation):
    cursor.execute(f'SELECT * FROM Paiement WHERE idReservation={id_reservation};')
    return cursor.fetchone()


def update_statut_paiement(id_paiement, statut):
    cursor.execute(
        f'UPDATE Paiement SET statutPaiement="{statut}" WHERE idPaiement={id_paiement};'
    )


# ─── Avis ─────────────────────────────────────────────────────────────────────

def insert_avis(note, commentaire, date, id_proprietaire, id_gardien, id_reservation):
    request = (
        f'INSERT INTO Avis(note, commentaire, dateAvis, idProprietaire, idGardien, idReservation) '
        f'VALUES ({note}, "{commentaire}", "{date}", {id_proprietaire}, {id_gardien}, {id_reservation});'
    )
    cursor.execute(request)


def get_avis_by_gardien(id_gardien):
    cursor.execute(f'SELECT * FROM Avis WHERE idGardien={id_gardien};')
    return cursor.fetchall()


def get_moyenne_avis_gardien(id_gardien):
    cursor.execute(f'SELECT AVG(note) AS moyenne FROM Avis WHERE idGardien={id_gardien};')
    result = cursor.fetchone()
    return result[0] if result else None