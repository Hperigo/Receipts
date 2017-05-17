import os
from flask import Flask, render_template, request, redirect, url_for, json
from werkzeug import secure_filename

from pymongo import MongoClient

mongo_client = MongoClient()
mongo_db = mongo_client["receipts"]

UPLOAD_FOLDER = './uploads'
ALLOWED_EXTENSIONS = set(['pdf', 'png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


def allowed_file(filename):
    return '.' in filename and \
       filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route("/")
def upload_file():
    return "Hello"


@app.route("/image", methods=["GET", "POST"])
def upload_image():
    if request.method == "POST":
        print("--- POOST: ")
        # check if the post request has the file part
        if 'file' not in request.files:
            print("no file")
            flash('No file part')
            return "ERROR: NO FILE"
        file = request.files['file']
        # if user does not select file, browser also
        # submit a empty part without filename
        print(file.filename)

        if file.filename == '':
            print("no file name")
            flash('No selected file')
            return "ERROR: NO FILE NAME"

        if file and allowed_file(file.filename):
            print("file OK")

            json_data  = json.loads(request.form["waka"])
            print(json_data["uuid"])
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return "OK"
        else:
            print("wat")




@app.route("/data", methods=["GET", "POST"])
def upload_json():
    if request.method == "POST":
        json = request.get_json()
        print(json)
        mongo_db["docs"].insert_one(json)
        return "DATA Ok"
    else:
        return "GET OK"



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4000, debug=True)
