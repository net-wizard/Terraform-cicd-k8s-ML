from flask import Flask, render_template, request, jsonify
import requests
import os
import sys

app = Flask(__name__)

# ── Required env vars ─────────────────────────────────────
def get_required_env(key):
    value = os.getenv(key)
    if not value:
        print(f"ERROR: {key} environment variable not set", file=sys.stderr)
        sys.exit(1)
    return value

ML_API_URL       = get_required_env("ML_API_URL")
DATA_SERVICE_URL = get_required_env("DATA_SERVICE_URL")


@app.route("/", methods=["GET"])
def index():
    # Fetch users and products for dropdowns
    try:
        users    = requests.get(f"{ML_API_URL}/users",    timeout=3).json().get("users", [])
        products = requests.get(f"{ML_API_URL}/products", timeout=3).json().get("products", [])
        history  = requests.get(f"{DATA_SERVICE_URL}/history?limit=10", timeout=3).json()
    except Exception as e:
        users, products, history = [], [], []

    return render_template(
        "index.html",
        users=users,
        products=products,
        history=history
    )


@app.route("/recommend", methods=["POST"])
def recommend():
    user_id = request.form.get("user_id")
    if not user_id:
        return jsonify({"error": "user_id required"}), 400
    try:
        resp = requests.post(
            f"{ML_API_URL}/recommend",
            json={"user_id": user_id},
            timeout=5
        )
        return jsonify(resp.json()), resp.status_code
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "ui"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=False)
