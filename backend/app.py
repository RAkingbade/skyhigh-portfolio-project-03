import os
import socket
from flask import Flask, jsonify

app = Flask(__name__)

# The counter lives in memory, like a notebook on the cook's desk
counter = 0


@app.route("/api/data")
def data():
    global counter
    counter += 1
    return jsonify({
        "hostname": socket.gethostname(),
        "counter": counter,
        "api_key_loaded": bool(os.environ.get("API_KEY"))
    })


@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200
