# Terraform-cicd-k8s-ML
**End-to-end MLOps/DevOps Retail Personalization Platform**

## Technology Stack
- **Cloud:** AWS
- **IaC:** Terraform
- **Orchestration:** Kubernetes (EKS)
- **CI/CD:** Jenkins + ArgoCD
- **Monitoring:** Prometheus + Grafana
- **Logging:** EFK Stack (Elasticsearch, Fluentd, Kibana) + Jaeger
- **MLOps:** MLflow + Feast
- **Streaming:** Apache Kafka

## Architecture Components
1. **Infrastructure Layer**: Terraform, AWS, EKS
2. **Application Layer**: Microservices (Go/Python/Node.js)
3. **ML Layer**: Training pipelines, model serving
4. **CI/CD Layer**: Jenkins pipelines, GitOps
5. **Observability Layer**: 
   - Metrics: Prometheus
   - Logging: EFK Stack
   - Tracing: Jaeger
   - Dashboards: Grafana

## Project Phases
✅ Phase 0: Foundation (Current)  
⬜ Phase 1: Containerization  
⬜ Phase 2: CI/CD Foundation  
⬜ Phase 3: ML Integration  
⬜ Phase 4: Advanced DevOps & Logging  
⬜ Phase 5: Production Features  
⬜ Phase 6: Polish & Documentation