from passlib.hash import sha256_crypt
import pymysql

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='PabloIsCrazy123',
    # password='Aymen12345',
    db='gardiennage_animaux_GLO2005_2026',
    autocommit=True
)

cursor = connection.cursor()

def password_hash(password):
    return sha256_crypt.encrypt(password)

def verify_password(password, password_actual):
    return sha256_crypt.verify(password, password_actual)

def modify_utilisateur(email, password):
    hashed_password = password_hash(password)
    request = f"UPDATE Utilisateur SET motDePasse = '{hashed_password}' WHERE email = '{email}';"
    cursor.execute(request)

def check_user_password(email, password):
    request = """SELECT motDePasse FROM Utilisateur WHERE email = '{}'""".format(email)
    cursor.execute(request)
    hashed_password = cursor.fetchone()[0]
    return verify_password(password, hashed_password)

# Test de modification
modify_utilisateur('jeremie.tremblay@gmail.com', 'PwdU0001A')

# Test de vérification
result = check_user_password('jeremie.tremblay@gmail.com', 'PwdU0001A')
print(f"Mot de passe correct:{result}") # Résultat attendu : TRUE