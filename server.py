from flask import Flask, render_template, jsonify, request
#from database import ______#

app = Flask(__name__)

@app.route('/')
def index(): pass

if __name__ == '__main__':
    app.run()
