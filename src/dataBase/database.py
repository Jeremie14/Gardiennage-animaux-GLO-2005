import pymysql.cursors

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='PabloIsCrazy123',
    db='gardiennage_animaux_GLO2005_2026',
    autocommit=True
)

cursor = connection.cursor()

#Transmet les inscriptions dans la bd
def insert_utilisateur(nom, prenom, email, num, adresse, mot_de_passe):
    sql = """
          INSERT INTO Utilisateur
              (nom, prenom, email, numTelephone, adresse, motDepasse)
          VALUES (%s, %s, %s, %s, %s, %s) \
          """

    cursor.execute(sql, (nom, prenom, email, num, adresse, mot_de_passe))
    connection.commit()

#Transmet les réservations dans la table reservation
#