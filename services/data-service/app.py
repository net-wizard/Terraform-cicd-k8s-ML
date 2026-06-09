from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)

DB_PATH = os.getenv("DB_PATH", "sqlite:///predictions.db")
app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
    "DATABASE_URL",
    "postgresql://devops:devops123@postgres:5432/retaildb"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


class Prediction(db.Model):
    __tablename__ = "predictions"
    id              = db.Column(db.Integer, primary_key=True)
    user_id         = db.Column(db.String(50), nullable=False)
    recommendations = db.Column(db.Text, nullable=False)
    response_time_s = db.Column(db.Float, nullable=False)
    timestamp       = db.Column(db.DateTime, default=datetime.utcnow)


with app.app_context():
    db.create_all()


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "data-service"}), 200


@app.route("/log", methods=["POST"])
def log_prediction():
    body = request.get_json()
    if not body:
        return jsonify({"error": "empty body"}), 400

    required = ["user_id", "recommendations", "response_time_s"]
    for field in required:
        if field not in body:
            return jsonify({"error": f"{field} is required"}), 400

    record = Prediction(
        user_id         = str(body["user_id"]),
        recommendations = ",".join(body["recommendations"]),
        response_time_s = float(body["response_time_s"])
    )
    db.session.add(record)
    db.session.commit()

    return jsonify({"status": "logged", "id": record.id}), 201


@app.route("/history", methods=["GET"])
def history():
    limit   = request.args.get("limit", 50, type=int)
    records = Prediction.query.order_by(
                  Prediction.timestamp.desc()
              ).limit(limit).all()

    return jsonify([{
        "id":              r.id,
        "user_id":         r.user_id,
        "recommendations": r.recommendations.split(","),
        "response_time_s": r.response_time_s,
        "timestamp":       r.timestamp.isoformat()
    } for r in records]), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=False)
