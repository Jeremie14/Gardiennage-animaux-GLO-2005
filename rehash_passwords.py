from passlib.hash import sha256_crypt
import pymysql

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='Aymen12345',
    db='gardiennage_animaux_GLO2005_2026',
    autocommit=True
)

cursor = connection.cursor()

cursor.execute('SELECT idUtilisateur, motDePasse FROM Utilisateur')
users = cursor.fetchall()

updated = 0
skipped = 0

for user in users:
    id_utilisateur = user[0]
    mot_de_passe = user[1]

    if mot_de_passe and mot_de_passe.startswith('$5$'):
        skipped += 1
        continue

    hashed = sha256_crypt.hash(mot_de_passe)
    cursor.execute(
        'UPDATE Utilisateur SET motDePasse=%s WHERE idUtilisateur=%s',
        (hashed, id_utilisateur)
    )
    updated += 1

cursor.close()
connection.close()

print(f'✅ {updated} mots de passe hashés')
print(f'⏭️  {skipped} déjà hashés, ignorés')