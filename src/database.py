import pymysql.cursors

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='PabloIsCrazy123',
    db='gardiennage_animaux_GLO2005_2026',
    autocommit=True
)

cursor = connection.cursor()

