from flask import Flask, jsonify, request
from flask_cors import CORS
from src.dataBase.database import *
from datetime import date

app = Flask(__name__)
CORS(app)


@app.route('/')
def index():
    return jsonify({'status': 'API Gardiennage en ligne'})



@app.route('/user/register', methods=['POST'])
def user_register():
    data = request.get_json()
    insert_utilisateur(
        data['lastName'],
        data['name'],
        data['email'],
        data['cellPhone'],
        data['adress'],
        data['password'],
        data.get('role', 'Proprietaire')
    )
    if data.get('role') == 'Gardien':
        user = get_utilisateur_by_email(data['email'])
        if user:
            insert_gardien(
                user[0],
                data.get('experience', 0),
                data.get('tarifHoraire', 0),
                data.get('description', ''),
                data.get('zoneService', None)
            )

    return jsonify({'status': 'created'}), 201


@app.route('/user/login', methods=['POST'])
def user_login():
    data = request.get_json()
    user = get_utilisateur_by_email(data['email'])
    if user is None:
        return jsonify({'error': 'Utilisateur introuvable'}), 404
    if user[7] != data['password']:
        return jsonify({'error': 'Mot de passe incorrect'}), 401
    return jsonify({
        'status': 'ok',
         'id': user[0],
        'name': user[1],
        'lastName': user[2],
        'email': user[3],
        'num': user[4],
        'adress': user[5],
        'date': str(user[6]),
        'role': user[8],
        'picture': user[9]
    }), 200


@app.route('/user/<int:id_utilisateur>', methods=['GET'])
def get_user(id_utilisateur):
    user = get_utilisateur_by_id(id_utilisateur)
    if user is None:
        return jsonify({'error': 'Introuvable'}), 404
    return jsonify({
        'id': user[0],
        'name': user[1],
        'lastName': user[2],
        'email': user[3],
        'num': user[4],
        'adress': user[5],
        'date': str(user[6]),
        'role': user[8],
        'picture': user[9]
    })


@app.route('/user/<int:id_utilisateur>', methods=['PUT'])
def update_user(id_utilisateur):
    data = request.get_json()
    update_utilisateur(
        id_utilisateur,
        data['lastName'],
        data['name'],
        data['email'],
        data['cellPhone'],
        data['adress']
    )
    return jsonify({'status': 'updated'})

@app.route('/user/<int:id_utilisateur>/pic', methods=['PUT'])
def update_user_pic(id_utilisateur):
    data = request.get_json()
    update_utilisateur_pic(
        id_utilisateur,
        data['picture']
    )
    return jsonify({'status': 'updated'})


@app.route('/user/<int:id_utilisateur>', methods=['DELETE'])
def delete_user(id_utilisateur):
    delete_utilisateur(id_utilisateur)
    return jsonify({'status': 'deleted'})




@app.route('/animal', methods=['POST'])
def create_animal():
    data = request.get_json()
    print(data)
    insert_animal(
        data['name'],
        data['species'],
        data['race'],
        data['age'],
        data['weight'],
        data['idProprietaire'],
        data.get('sexe'),
        data.get('temper'),
        data.get('specialNeeds')
    )
    return jsonify({'status': 'created'}), 201


@app.route('/animal/proprietaire/<int:id_proprietaire>', methods=['GET'])
def get_animaux(id_proprietaire):
    animaux = get_animaux_by_proprietaire(id_proprietaire)
    result = [
        {'idAnimal': a[0], 'name': a[1], 'species': a[2], 'race': a[3],
         'age': a[4], 'weight': a[5], 'idOwner': a[6],
         'sexe': a[7], 'temper': a[8], 'specialNeeds': a[9], 'picture': a[10]}
        for a in animaux
    ]
    return jsonify(result)

@app.route('/animal/<int:id_animal>', methods=['GET'])
def get_animal(id_animal):
    a = get_animal_by_id(id_animal)
    return jsonify({'idAnimal': a[0], 'name': a[1], 'species': a[2], 'race': a[3],
         'age': a[4], 'weight': a[5], 'idOwner': a[6],
         'sexe': a[7], 'temper': a[8], 'specialNeeds': a[9], 'picture': a[10]})

@app.route('/animal/<int:id_animal>', methods=['DELETE'])
def delete_animal_route(id_animal):
    delete_animal(id_animal)
    return jsonify({'status': 'deleted'})

@app.route('/animal/<int:id_animal>', methods=['PUT'])
def update_animal_image(id_animal):
    data = request.get_json()
    change_animal_picture(id_animal, data['picture'])
    return jsonify({'status': 'updated'}), 200

@app.route('/gardien', methods=['POST'])
def create_gardien():
    data = request.get_json()
    insert_gardien(
        data['idUtilisateur'],
        data['experience'],
        data['tarifHoraire'],
        data['description'],
        data.get('zoneService')
    )
    return jsonify({'status': 'created'}), 201


@app.route('/gardien', methods=['GET'])
def list_gardiens():
    gardiens = get_all_gardiens()
    result = [
        {'id': g[0], 'experience': g[1], 'priceHour': g[2],
         'description': g[3], 'zoneService': g[4], 'verifId': g[5],
         'latName': g[6], 'name': g[7], 'email': g[8], 'adress': g[9], "photo": g[10]}
        for g in gardiens
    ]
    return jsonify(result)


@app.route('/gardien/<int:id_utilisateur>', methods=['GET'])
def get_gardien(id_utilisateur):
    g = get_gardien_by_id(id_utilisateur)
    if g is None:
        return jsonify({'error': 'Introuvable'}), 404
    return jsonify({'id': g[0], 'experience': g[1], 'priceHour': g[2],
         'description': g[3], 'zoneService': g[4], 'verifId': g[5],
         'latName': g[6], 'name': g[7], 'email': g[8], 'adress': g[9], "photo": g[10]})


@app.route('/gardien/<int:id_utilisateur>', methods=['PUT'])
def update_gardien_route(id_utilisateur):
    data = request.get_json()
    update_gardien(
        id_utilisateur,
        data['experience'],
        data['tarifHoraire'],
        data['description'],
        data['zoneService']
    )
    return jsonify({'status': 'updated'})


@app.route('/service', methods=['POST'])
def create_service():
    data = request.get_json()
    insert_service(
        data['idGardien'],
        data['typeService'],
        data['description'],
        data['dureeEstimee']
    )
    return jsonify({'status': 'created'}), 201


@app.route('/service/gardien/<int:id_gardien>', methods=['GET'])
def get_services(id_gardien):
    services = get_services_by_gardien(id_gardien)
    result = [
        {'idService': s[0], 'idGardien': s[1], 'typeService': s[2],
         'description': s[3], 'dureeEstimee': s[4]}
        for s in services
    ]
    return jsonify(result)


@app.route('/service/<int:id_service>', methods=['DELETE'])
def delete_service_route(id_service):
    delete_service(id_service)
    return jsonify({'status': 'deleted'})


@app.route('/disponibilite', methods=['POST'])
def create_disponibilite():
    data = request.get_json()
    insert_disponibilite(
        data['idGardien'],
        data['dateDebut'],
        data['dateFin'],
        data.get('statutDisponibilite', 'DISPONIBLE')
    )
    return jsonify({'status': 'created'}), 201


@app.route('/disponibilite/gardien/<int:id_gardien>', methods=['GET'])
def get_disponibilites(id_gardien):
    dispos = get_disponibilites_by_gardien(id_gardien)
    result = [
        {'idDisponibilite': d[0], 'idGardien': d[1],
         'dateDebut': str(d[2]), 'dateFin': str(d[3]), 'statut': d[4]}
        for d in dispos
    ]
    return jsonify(result)


@app.route('/disponibilite/<int:id_disponibilite>', methods=['PUT'])
def update_disponibilite(id_disponibilite):
    data = request.get_json()
    update_disponibilite_statut(id_disponibilite, data['statut'])
    return jsonify({'status': 'updated'})


@app.route('/demande', methods=['POST'])
def create_demande():
    data = request.get_json()
    insert_demandeReservation(
        data['idProprietaire'],
        data['idGardien'],
        data['idAnimal'],
        data['idService'],
        data['dateDebut'],
        data['dateFin'],
        data['message'],
        str(date.today())
    )
    return jsonify({'status': 'created'}), 201


@app.route('/demande/proprietaire/<int:id_proprietaire>', methods=['GET'])
def get_demandes_proprietaire(id_proprietaire):
    demandes = get_demandes_by_proprietaire(id_proprietaire)
    return jsonify([_format_demande(d) for d in demandes])


@app.route('/demande/gardien/<int:id_gardien>', methods=['GET'])
def get_demandes_gardien(id_gardien):
    demandes = get_demandes_by_gardien(id_gardien)
    return jsonify([_format_demande(d, with_proprietaire=True) for d in demandes])


@app.route('/demande/<int:id_demande>/statut', methods=['PUT'])
def update_demande_statut(id_demande):
    data = request.get_json()
    statut = data['statut']
    update_statut_demande(id_demande, statut)

    if statut == 'ACCEPTEE':
        demande = get_demande_by_id(id_demande)
        if demande:
            reservation_existante = get_reservation_by_demande(id_demande)
            if not reservation_existante:
                insert_reservation(
                    id_demande,
                    str(date.today()),
                    0,
                    'CONFIRMEE'
                )

    return jsonify({'status': 'updated'})


def _format_demande(d, with_proprietaire=False):
    result = {
        'idDemande': d[0], 'idProprietaire': d[1], 'idGardien': d[2],
        'idAnimal': d[3], 'idService': d[4],
        'dateDebut': str(d[5]), 'dateFin': str(d[6]),
        'message': d[7], 'dateCreation': str(d[8]), 'statutDemande': d[9]
    }
    if with_proprietaire:
        user = get_utilisateur_by_id(d[1])
        animal = get_animal_by_id(d[3])
        result['nomProprietaire'] = f"{user[1]} {user[2]}" if user else 'Anonyme'
        result['photoProprietaire'] = user[9] if user else None
        result['nomAnimal'] = animal[1] if animal else None
    return result


@app.route('/reservation', methods=['POST'])
def create_reservation():
    data = request.get_json()
    insert_reservation(
        data['idDemande'],
        data['dateConfirmation'],
        data['prixTotal'],
        data.get('statutReservation', 'CONFIRMEE')
    )
    return jsonify({'status': 'created'}), 201


@app.route('/reservation/<int:id_reservation>', methods=['GET'])
def get_reservation(id_reservation):
    r = get_reservation_by_id(id_reservation)
    if r is None:
        return jsonify({'error': 'Introuvable'}), 404
    return jsonify({
        'idReservation': r[0], 'idDemande': r[1],
        'dateConfirmation': str(r[2]), 'statut': r[3], 'prixTotal': r[4]
    })


@app.route('/reservation/<int:id_reservation>/statut', methods=['PUT'])
def update_reservation_statut(id_reservation):
    data = request.get_json()
    update_statut_reservation(id_reservation, data['statut'])
    return jsonify({'status': 'updated'})

@app.route('/reservation/<int:id_utilisateur>/confirmee', methods=['GET'])
def get_confirmee_reservation(id_utilisateur):
    rows = get_confirmed_reservations_by_user_id(id_utilisateur)

    if not rows:
        return jsonify({'error': 'Aucune réservation confirmée trouvée'}), 404

    reservations = []
    for r in rows:
        reservations.append({
            'idReservation':    r[0],
            'idDemande':        r[1],
            'dateConfirmation': str(r[2]),
            'Totalprice':       r[4],
            'idGardien':        r[7],
            'idAnimal':         r[8],
            'idService':        r[9],
            'dateDebut':        str(r[10]),
            'dateFin':          str(r[11]),
            'message':          r[12],
            'dateCreation':     str(r[13])
        })

    return jsonify(reservations), 200

@app.route('/reservation/<int:id_utilisateur>/passees', methods=['GET'])
def get_passees_reservation(id_utilisateur):
    rows = get_past_reservations_by_user_id(id_utilisateur)

    if not rows:
        return jsonify([]), 200

    reservations = []
    for r in rows:
        reservations.append({
            'idReservation':    r[0],
            'idDemande':        r[1],
            'dateConfirmation': str(r[2]),
            'statut': r[3],
            'Totalprice':       r[4],
            'idGardien':        r[7],
            'idAnimal':         r[8],
            'idService':        r[9],
            'dateDebut':        str(r[10]),
            'dateFin':          str(r[11]),
            'message':          r[12],
            'dateCreation':     str(r[13])
        })

    return jsonify(reservations), 200
@app.route('/paiement', methods=['POST'])
def create_paiement():
    data = request.get_json()
    insert_paiement(
        data['montant'],
        data['datePaiement'],
        data['methodePaiement'],
        data['idReservation'],
        data.get('statutPaiement', 'EN_ATTENTE')
    )
    return jsonify({'status': 'created'}), 201


@app.route('/paiement/reservation/<int:id_reservation>', methods=['GET'])
def get_paiement(id_reservation):
    p = get_paiement_by_reservation(id_reservation)
    if p is None:
        return jsonify({'error': 'Introuvable'}), 404
    return jsonify({
        'idPaiement': p[0], 'montant': p[1], 'datePaiement': str(p[2]),
        'methodePaiement': p[3], 'idReservation': p[4], 'statutPaiement': p[5]
    })


@app.route('/paiement/<int:id_paiement>/statut', methods=['PUT'])
def update_paiement_statut(id_paiement):
    data = request.get_json()
    update_statut_paiement(id_paiement, data['statut'])
    return jsonify({'status': 'updated'})


@app.route('/avis', methods=['POST'])
def create_avis():
    data = request.get_json()
    insert_avis(
        data['note'],
        data['commentaire'],
        data['dateAvis'],
        data['idProprietaire'],
        data['idGardien'],
        data['idReservation']
    )
    return jsonify({'status': 'created'}), 201


@app.route('/avis/gardien/<int:id_gardien>', methods=['GET'])
def get_avis(id_gardien):
    avis_list = get_avis_by_gardien(id_gardien)
    result = []
    for a in avis_list:
        user = get_utilisateur_by_id(a[4])
        result.append({
            'idAvis': a[0], 'note': a[1], 'commentaire': a[2],
            'dateAvis': str(a[3]), 'idProprietaire': a[4],
            'idGardien': a[5], 'idReservation': a[6],
            'nomProprietaire': f"{user[1]} {user[2]}" if user else 'Anonyme',
            'photoProprietaire': user[9] if user else None
        })
    return jsonify(result)


@app.route('/avis/gardien/<int:id_gardien>/moyenne', methods=['GET'])
def get_moyenne(id_gardien):
    moyenne = get_moyenne_avis_gardien(id_gardien)
    return jsonify({'idGardien': id_gardien, 'moyenneNote': round(float(moyenne), 2) if moyenne else None})


if __name__ == '__main__':
    app.run(debug=True)