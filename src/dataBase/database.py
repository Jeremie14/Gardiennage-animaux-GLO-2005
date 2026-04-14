import pymysql.cursors

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Aymen12345',
    'db': 'gardiennage_animaux_GLO2005_2026',
    'autocommit': True,
}

def get_cursor():
    connection = pymysql.connect(**DB_CONFIG)
    return connection, connection.cursor()


# ─── Utilisateur ─────────────────────────────────────────────────────────────

def insert_utilisateur(nom, prenom, email, num, adresse, mot_de_passe, role='Proprietaire'):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Utilisateur(nom, prenom, email, numTelephone, adresse, dateInscription, motDePasse, role) '
            'VALUES (%s, %s, %s, %s, %s, CURDATE(), %s, %s)',
            (nom, prenom, email, num, adresse, mot_de_passe, role)
        )
    finally:
        cursor.close()
        connection.close()


def get_utilisateur_by_email(email):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Utilisateur WHERE email = %s', (email,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def get_utilisateur_by_id(id_utilisateur):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Utilisateur WHERE idUtilisateur = %s', (id_utilisateur,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def get_all_utilisateurs():
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Utilisateur')
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def update_utilisateur(id_utilisateur, nom, prenom, email, num, adresse):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'UPDATE Utilisateur SET nom=%s, prenom=%s, email=%s, numTelephone=%s, adresse=%s '
            'WHERE idUtilisateur=%s',
            (nom, prenom, email, num, adresse, id_utilisateur)
        )
    finally:
        cursor.close()
        connection.close()

def update_utilisateur_pic(id_utilisateur, picture):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'UPDATE Utilisateur SET photoDeProfil =%s '
            'WHERE idUtilisateur=%s',
            (picture, id_utilisateur)
        )
    finally:
        cursor.close()
        connection.close()



def delete_utilisateur(id_utilisateur):
    connection, cursor = get_cursor()
    try:
        cursor.execute('DELETE FROM Utilisateur WHERE idUtilisateur=%s', (id_utilisateur,))
    finally:
        cursor.close()
        connection.close()


# ─── Animal ──────────────────────────────────────────────────────────────────

def insert_animal(nom, espece, race, age, poids, id_proprietaire, sexe, temperament, besoins_speciaux):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Animal(nom, espece, race, age, poids, idProprietaire, sexe, temperament, besoinsSpeciaux) '
            'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)',
            (nom, espece, race, age, poids, id_proprietaire, sexe, temperament, besoins_speciaux)
        )
    finally:
        cursor.close()
        connection.close()


def get_animaux_by_proprietaire(id_proprietaire):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Animal WHERE idProprietaire=%s', (id_proprietaire,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def get_animal_by_id(id_animal):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Animal WHERE idAnimal=%s', (id_animal,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def delete_animal(id_animal):
    connection, cursor = get_cursor()
    try:
        cursor.execute('DELETE FROM Animal WHERE idAnimal=%s', (id_animal,))
    finally:
        cursor.close()
        connection.close()


def change_animal_picture(id_animal, picture):
    connection, cursor = get_cursor()
    try:
        cursor.execute('UPDATE Animal SET photo=%s WHERE idAnimal=%s', (picture, id_animal))
    finally:
        cursor.close()
        connection.close()


# ─── GardienAnimaux ──────────────────────────────────────────────────────────

def insert_gardien(id_utilisateur, experience, tarif_horaire, description
                   , zone_service=None):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO GardienAnimaux(idGardien, experience, tarifHoraire, description, zoneService, verificationIdentite) '
            'VALUES (%s, %s, %s, %s, %s, FALSE)',
            (id_utilisateur, experience, tarif_horaire, description, zone_service)
        )
    finally:
        cursor.close()
        connection.close()


def get_gardien_by_id(id_utilisateur):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT G.*, U.nom, U.prenom, U.email, U.adresse, U.photoDeProfil '
            'FROM GardienAnimaux G '
            'JOIN Utilisateur U ON G.idGardien = U.idUtilisateur '
            'WHERE G.idGardien=%s',
            (id_utilisateur,)
        )
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def get_all_gardiens():
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT G.*, U.nom, U.prenom, U.email, U.adresse, U.photoDeProfil '
            'FROM GardienAnimaux G '
            'JOIN Utilisateur U ON G.idGardien = U.idUtilisateur'
        )
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def update_gardien(id_utilisateur, experience, tarif_horaire, description, zone_service):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            f'UPDATE GardienAnimaux SET experience=%s, tarifHoraire=%s, description=%s, '
            f'zoneService=%s WHERE idGardien=%s',
            (experience, tarif_horaire, description, zone_service, id_utilisateur)
        )
    finally:
        cursor.close()
        connection.close()


# ─── Service ─────────────────────────────────────────────────────────────────

def insert_service(id_gardien, type_service, description, duree):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Service(idGardien, typeService, description, dureeEstimee) '
            'VALUES (%s, %s, %s, %s)',
            (id_gardien, type_service, description, duree)
        )
    finally:
        cursor.close()
        connection.close()


def get_services_by_gardien(id_gardien):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Service WHERE idGardien=%s', (id_gardien,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def get_service_by_id(id_service):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Service WHERE idService=%s', (id_service,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def delete_service(id_service):
    connection, cursor = get_cursor()
    try:
        cursor.execute('UPDATE DemandeReservation SET idService=NULL WHERE idService=%s', (id_service,))
        cursor.execute('DELETE FROM Service WHERE idService=%s', (id_service,))
    finally:
        cursor.close()
        connection.close()


# ─── Disponibilite ───────────────────────────────────────────────────────────

def insert_disponibilite(id_gardien, debut, fin, statut='DISPONIBLE'):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Disponibilite(idGardien, dateDebut, dateFin, statutDisponibilite) '
            'VALUES (%s, %s, %s, %s)',
            (id_gardien, debut, fin, statut)
        )
    finally:
        cursor.close()
        connection.close()


def get_disponibilites_by_gardien(id_gardien):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Disponibilite WHERE idGardien=%s', (id_gardien,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def update_disponibilite_statut(id_disponibilite, statut):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'UPDATE Disponibilite SET statutDisponibilite=%s WHERE idDisponibilite=%s',
            (statut, id_disponibilite)
        )
    finally:
        cursor.close()
        connection.close()


# ─── DemandeReservation ──────────────────────────────────────────────────────

def insert_demandeReservation(id_proprietaire, id_gardien, id_animal, id_service,
                              debut, fin, message, creation, nombre_heures):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO DemandeReservation(idProprietaire, idGardien, idAnimal, idService, '
            'dateDebut, dateFin, message, dateCreation, statutDemande, nombreHeures) '
            'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, "EN_ATTENTE", %s)',
            (id_proprietaire, id_gardien, id_animal, id_service, debut, fin, message, creation, nombre_heures)
        )
        return cursor.lastrowid
    finally:
        cursor.close()
        connection.close()

def get_demandes_by_proprietaire(id_proprietaire):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM DemandeReservation WHERE idProprietaire=%s', (id_proprietaire,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def get_demandes_by_gardien(id_gardien):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM DemandeReservation WHERE idGardien=%s', (id_gardien,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def update_statut_demande(id_demande, statut):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'UPDATE DemandeReservation SET statutDemande=%s WHERE idDemande=%s',
            (statut, id_demande)
        )
    finally:
        cursor.close()
        connection.close()


def get_demande_by_id(id_demande):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM DemandeReservation WHERE idDemande=%s', (id_demande,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def get_accepted_demandes_by_owner_id(id_proprietaire):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT * FROM DemandeReservation WHERE idProprietaire=%s AND statutDemande="ACCEPTEE"',
            (id_proprietaire,)
        )
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


# ─── Reservation ─────────────────────────────────────────────────────────────
def insert_reservation(id_demande, date, prix, statut='CONFIRMEE'):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Reservation(idDemande, dateConfirmation, statutReservation, prixTotal) '
            'VALUES (%s, %s, %s, %s)',
            (id_demande, date, statut, prix)
        )
        return cursor.lastrowid
    finally:
        cursor.close()
        connection.close()


def get_reservation_by_id(id_reservation):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Reservation WHERE idReservation=%s', (id_reservation,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def get_reservation_by_demande(id_demande):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Reservation WHERE idDemande=%s', (id_demande,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def update_statut_reservation(id_reservation, statut):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'UPDATE Reservation SET statutReservation=%s WHERE idReservation=%s',
            (statut, id_reservation)
        )
    finally:
        cursor.close()
        connection.close()


def get_confirmed_reservations_by_user_id(id_utilisateur):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT * FROM Reservation R '
            'JOIN DemandeReservation D ON D.idDemande = R.idDemande '
            'WHERE (D.idProprietaire = %s OR D.idGardien = %s) '
            'AND R.statutReservation = "CONFIRMEE"',
            (id_utilisateur, id_utilisateur)
        )
        return cursor.fetchall() or []
    finally:
        cursor.close()
        connection.close()

def get_past_reservations_by_user_id(id_utilisateur):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT * FROM Reservation R '
            'JOIN DemandeReservation D ON D.idDemande = R.idDemande '
            'WHERE (D.idProprietaire = %s OR D.idGardien = %s) '
            'AND R.statutReservation != "CONFIRMEE"',
            (id_utilisateur, id_utilisateur)
        )
        return cursor.fetchall() or []
    finally:
        cursor.close()
        connection.close()

# ─── Paiement ────────────────────────────────────────────────────────────────

def insert_paiement(montant, date, methode, id_reservation, statut='EN_ATTENTE'):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Paiement(montant, datePaiement, methodePaiement, idReservation, statutPaiement) '
            'VALUES (%s, %s, %s, %s, %s)',
            (montant, date, methode, id_reservation, statut)
        )
        return cursor.lastrowid
    finally:
        cursor.close()
        connection.close()

def get_paiement_by_reservation(id_reservation):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Paiement WHERE idReservation=%s', (id_reservation,))
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def update_statut_paiement(id_paiement, statut):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'UPDATE Paiement SET statutPaiement=%s WHERE idPaiement=%s',
            (statut, id_paiement)
        )
    finally:
        cursor.close()
        connection.close()


# ─── Avis ────────────────────────────────────────────────────────────────────

def insert_avis(note, commentaire, date, id_proprietaire, id_gardien, id_reservation):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'INSERT INTO Avis(note, commentaire, dateAvis, idProprietaire, idGardien, idReservation) '
            'VALUES (%s, %s, %s, %s, %s, %s)',
            (note, commentaire, date, id_proprietaire, id_gardien, id_reservation)
        )
    finally:
        cursor.close()
        connection.close()


def get_avis_by_gardien(id_gardien):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT * FROM Avis WHERE idGardien=%s', (id_gardien,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def get_moyenne_avis_gardien(id_gardien):
    connection, cursor = get_cursor()
    try:
        cursor.execute('SELECT CalculerNoteMoyenneGardien(%s)', (id_gardien,))
        result = cursor.fetchone()
        return result[0] if result else 0.00
    finally:
        cursor.close()
        connection.close()


def get_revenue_gardien(id_gardien):
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT G.idGardien, U.prenom, U.nom, '
            'COUNT(R.idReservation) AS nbReservations, '
            'COALESCE(SUM(R.prixTotal), 0) AS revenuTotal '
            'FROM GardienAnimaux G '
            'JOIN Utilisateur U ON U.idUtilisateur = G.idGardien '
            'LEFT JOIN DemandeReservation DR ON DR.idGardien = G.idGardien '
            'LEFT JOIN Reservation R ON R.idDemande = DR.idDemande '
            'AND R.statutReservation IN ("CONFIRMEE", "EN_COURS", "TERMINEE") '
            'WHERE G.idGardien = %s '
            'GROUP BY G.idGardien, U.prenom, U.nom',
            (id_gardien,)
        )
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()

def get_top_gardiens():
    connection, cursor = get_cursor()
    try:
        cursor.execute(
            'SELECT G.idGardien, U.prenom, U.nom, U.photoDeProfil, '
            'ROUND(AVG(A.note), 2) AS noteMoyenne, COUNT(A.idAvis) AS nbAvis, '
            'G.tarifHoraire, G.description '
            'FROM GardienAnimaux G '
            'JOIN Utilisateur U ON U.idUtilisateur = G.idGardien '
            'JOIN Avis A ON A.idGardien = G.idGardien '
            'GROUP BY G.idGardien, U.prenom, U.nom, U.photoDeProfil, G.tarifHoraire, G.description '
            'HAVING COUNT(A.idAvis) >= 3 '
            'ORDER BY noteMoyenne DESC, nbAvis DESC '
            'LIMIT 5'
        )
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()
