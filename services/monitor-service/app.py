from flask import Flask, request, jsonify, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import os

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "ml_api_requests_total",
    "Total number of recommendation requests"
)
REQUEST_ERRORS = Counter(
    "ml_api_errors_total",
    "Total number of failed requests"
)
RESPONSE_TIME = Histogram(
    "ml_api_response_time_seconds",
    "Response time of recommendation requests",
    buckets=[0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0]
)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "monitor-service"}), 200


@app.route("/record", methods=["POST"])
def record():
    body = request.get_json()
    if not body:
        return jsonify({"error": "empty body"}), 400

    status        = body.get("status", "success")
    response_time = float(body.get("response_time", 0))

    REQUEST_COUNT.inc()
    RESPONSE_TIME.observe(response_time)
    if status != "success":
        REQUEST_ERRORS.inc()

    return jsonify({"status": "recorded"}), 200


@app.route("/metrics", methods=["GET"])
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


@app.route("/summary", methods=["GET"])
def summary():
    return jsonify({
        "total_requests": REQUEST_COUNT._value.get(),
        "total_errors":   REQUEST_ERRORS._value.get(),
        "service":        "monitor-service"
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002, debug=False)
