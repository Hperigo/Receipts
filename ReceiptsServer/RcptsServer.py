from flask import Flask, render_template, request
from werkzeug import secure_filename


app = Flask(__name__)

@app.route("/")
def upload_file():
    return "Hello"



#  render_template("upload.html")

@app.route("/uploader", methods=["GET", "POST"])
def uploaded_file():
    if request.method == "POST":
        print(request.get_json())
        return "POST Ok"
    else:
        return "GET OK"



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4000, debug=True)
