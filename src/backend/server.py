from flask import Flask, jsonify, request
from flask_cors import CORS
from src.dataBase.database import *

app = Flask(__name__)

@app.route('/')
def index(): pass


@app.route("/user/register", methods=['POST'])
def user_register():
    data = request.get_json()
    lastName = data['lastName']
    name = data['name']
    email = data['email']
    password = data['password']
    cellPhone = data['cellPhone']
    adress = data['adress']
    insert_utilisateur(lastName, name, email, cellPhone, adress, password)
    return jsonify({'status': 'created'})




if __name__ == '__main__':
    app.run()
