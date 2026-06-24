# RetailRec — MLOps & DevOps Platform

**End-to-end MLOps pipeline with GitOps CI/CD on Kubernetes**

A retail product recommendation system built to demonstrate real-world DevOps practices:
microservices, containerisation, Kubernetes orchestration, Jenkins CI, and ArgoCD GitOps CD.

---

## Live Architecture

```
Browser
   │
   ▼ NodePort 30003
┌──────────────────────────────────────────────────┐
│  ui (Flask + Jinja2)                             │
│  Dark theme dashboard — recommendations + history│
└──────┬──────────────────────┬────────────────────┘
       │                      │
       ▼                      ▼
┌─────────────┐      ┌─────────────────┐
│  ml-api     │      │  data-service   │
│  scikit-learn│     │  Flask +        │
│  affinity   │      │  SQLAlchemy +   │
│  matrix     │      │  PostgreSQL     │
│  top 5 recs │      │  prediction log │
└──────┬──────┘      └────────┬────────┘
       │                      │
       ▼                      ▼
┌─────────────────┐   ┌───────────────────────┐
│ monitor-service │   │  postgres (StatefulSet)│
│ Prometheus      │   │  PVC persistent storage│
│ metrics         │   └───────────────────────┘
└─────────────────┘
```

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Language | Python 3.12 |
| Frameworks | Flask, SQLAlchemy, scikit-learn, Prometheus client |
| Containerisation | Docker, Docker Compose |
| Orchestration | Kubernetes (Minikube → EKS) |
| CI | Jenkins (Docker) |
| CD | ArgoCD (GitOps) |
| Registry | Docker Hub |
| IaC | Terraform (Week 2) |
| Cloud | AWS — EKS, EC2, ECR (Week 2) |
| Monitoring | Prometheus + Grafana (Week 2) |

---

## Microservices

| Service | Port | Description |
|---------|------|-------------|
| `ml-api` | 5000 | Loads `model.pkl`, returns top 5 product recommendations per user |
| `data-service` | 5001 | Logs predictions to PostgreSQL, serves history |
| `monitor-service` | 5002 | Records Prometheus metrics, exposes `/metrics` |
| `ui` | 5003 | Flask dashboard — recommendations + prediction history |
| `postgres` | 5432 | StatefulSet with PVC for persistent storage |

---

## CI/CD Pipeline

```
git push
    │
    ▼
Jenkins (Docker container)
    ├── Stage 1: Checkout from GitHub
    ├── Stage 2: docker build × 4 images
    ├── Stage 3: docker push → Docker Hub (thoratshubham/*)
    └── Stage 4: sed update k8s manifests → git push
                                                │
                                                ▼
                                    ArgoCD (in-cluster)
                                    polls GitHub every 3 min
                                    detects manifest change
                                    kubectl apply → rolling update
                                    zero downtime deployment
```

---

## Repository Structure

```
.
├── Jenkinsfile                    # CI pipeline
├── argocd/
│   └── retailrec-app.yaml        # ArgoCD Application manifest
├── docker-compose.yml             # Local development stack
├── k8s/
│   ├── data-service/
│   │   ├── configmap.yaml        # Non-sensitive env vars
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── ml-api/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── monitor-service/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── postgres/
│   │   ├── secret.yaml           # gitignored — create manually
│   │   ├── service.yaml          # headless ClusterIP
│   │   └── statefulset.yaml
│   └── ui/
│       ├── deployment.yaml
│       └── service.yaml          # NodePort 30003
└── services/
    ├── data-service/
    ├── ml-api/
    ├── monitor-service/
    └── ui/
        └── templates/
            └── index.html
```

---

## Local Setup

### Prerequisites
- Docker
- Minikube
- kubectl
- Jenkins (Docker)

### Run with Docker Compose
```bash
docker compose up --build
# UI available at http://localhost:5003
```

### Deploy to Minikube
```bash
minikube start --driver=docker

# Create postgres secret (not in git)
kubectl apply -f k8s/postgres/secret.yaml

# Apply all manifests
kubectl apply -R -f k8s/

# Access UI
minikube service ui --url
```

### Start Jenkins
```bash
docker start jenkins
# Access at http://localhost:8080
```

### Start ArgoCD
```bash
kubectl port-forward svc/argocd-server -n argocd 8090:443
# Access at https://localhost:8090
```

---

## Secrets

`k8s/postgres/secret.yaml` is gitignored. Create it manually:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
  namespace: default
type: Opaque
data:
  POSTGRES_PASSWORD: ZGV2b3BzMTIz   # base64 encoded
```

---

## Project Progress

```
Week 1 — Local Stack (Complete)
  ✅ 4 Python Flask microservices
  ✅ scikit-learn recommendation model
  ✅ Docker + Docker Compose
  ✅ Kubernetes manifests (Minikube)
  ✅ Jenkins CI pipeline (Jenkinsfile)
  ✅ ArgoCD GitOps CD
  ✅ Full end-to-end pipeline verified

Week 2 — AWS + Production (Planned)
  ⬜ Terraform: VPC + EKS cluster
  ⬜ Jenkins on EC2 + GitHub webhooks
  ⬜ Deploy to EKS (same manifests)
  ⬜ Prometheus + Grafana via Helm
  ⬜ README update + v1.0 tag
```

---

## Docker Hub

Images: `thoratshubham/{ml-api,data-service,monitor-service,ui}:v{n}`

Latest: `v7`
