import os
import socket
import requests
from flask import Flask, render_template_string

app = Flask(__name__)

# These come from OUTSIDE the container (Compose or a Kubernetes ConfigMap)
BACKEND_URL = os.environ.get("BACKEND_URL", "http://backend:5000")
APP_MESSAGE = os.environ.get("APP_MESSAGE", "Hello from Patchwork Labs!")

PAGE = """
<!doctype html>
<html>
<head>
  <title>Patchwork Labs</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f6fb; text-align: center; padding: 40px; }
    .card { background: white; max-width: 480px; margin: auto; padding: 24px;
            border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,.1); }
    .count { font-size: 48px; font-weight: bold; color: #2b6cb0; }
  </style>
</head>
<body>
  <div class="card">
    <h1>{{ message }}</h1>
    <p>Visit counter from the backend (v2):</p>
    <div class="count">{{ counter }}</div>
    <p>Frontend pod: <b>{{ frontend_host }}</b></p>
    <p>Backend pod: <b>{{ backend_host }}</b></p>
    <p>Status: {{ status }}</p>
  </div>
</body>
</html>
"""


@app.route("/")
def home():
    try:
        r = requests.get(f"{BACKEND_URL}/api/data", timeout=3)
        r.raise_for_status()
        data = r.json()
        backend_host = data["hostname"]
        counter = data["counter"]
        status = "✅ Connected to backend"
    except Exception as e:
        backend_host = "unreachable"
        counter = "?"
        status = f"❌ Could not reach backend: {e}"

    return render_template_string(
        PAGE,
        message=APP_MESSAGE,
        counter=counter,
        frontend_host=socket.gethostname(),
        backend_host=backend_host,
        status=status,
    )


@app.route("/health")
def health():
    return {"status": "ok"}, 200
