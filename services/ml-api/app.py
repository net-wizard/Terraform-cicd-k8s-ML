from flask import Flask, request, jsonify
import pickle
import os
import requests
import time

app = Flask(__name__)

# Load model once when the app starts
MODEL_PATH = os.getenv("MODEL_PATH", "model.pkl")
DATA_SERVICE_URL = os.getenv("DATA_SERVICE_URL", "http://data-service:5001")
MONITOR_SERVICE_URL = os.getenv("MONITOR_SERVICE_URL", "http://monitor-service:5002")

with open(MODEL_PATH, "rb") as f:
    model_data = pickle.load(f)

user_item_matrix = model_data["matrix"]
product_names    = model_data["products"]
user_ids         = model_data["users"]


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "ml-api"}), 200


@app.route("/recommend", methods=["POST"])
def recommend():
    start_time = time.time()

    body = request.get_json()
    if not body or "user_id" not in body:
        return jsonify({"error": "user_id is required"}), 400

    user_id = str(body["user_id"])

    if user_id not in user_ids:
        return jsonify({"error": f"user_id '{user_id}' not found"}), 404

    # Get recommendations
    user_index    = user_ids.index(user_id)
    user_vector   = user_item_matrix[user_index]
    top_indices   = sorted(range(len(user_vector)),
                           key=lambda i: user_vector[i],
                           reverse=True)[:5]
    recommendations = [product_names[i] for i in top_indices]

    response_time = round(time.time() - start_time, 4)

    result = {
        "user_id":         user_id,
        "recommendations": recommendations,
        "response_time_s": response_time
    }

    # Log to data-service (non-blocking — don't fail if it's down)
    try:
        requests.post(
            f"{DATA_SERVICE_URL}/log",
            json=result,
            timeout=2
        )
    except Exception:
        pass

    # Update metrics in monitor-service (non-blocking)
    try:
        requests.post(
            f"{MONITOR_SERVICE_URL}/record",
            json={"response_time": response_time, "status": "success"},
            timeout=2
        )
    except Exception:
        pass

    return jsonify(result), 200


@app.route("/products", methods=["GET"])
def products():
    return jsonify({"products": product_names}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
