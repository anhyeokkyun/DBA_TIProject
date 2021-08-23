# Libraries required
from flask import Flask, Blueprint, request, render_template, flash, redirect, url_for
import urllib3
import json
import modelpredict
import makedatafile

# Assign a Flask object to this application
app = Flask(__name__)

# Set up the routing path by the app object
@app.route("/")
def main_get():
    return render_template('/ML_Predict_Front.html')

@app.route("/modelpredict", methods=['POST', 'GET'])
def modelpredictRoute():
    makedatafile.run() 
    return modelpredict.run()
    
if __name__ == "__main__":
    app.run(host="192.168.5.12", port="5000", debug = True)

