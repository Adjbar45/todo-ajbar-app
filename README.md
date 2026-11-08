# Cloud To-Do: Flask + PostgreSQL on Docker and Kubernetes

A small to-do web app used as a hands-on DevOps project: containerized with Docker, run locally with Docker Compose, and deployed to a local Kubernetes cluster (minikube).

```
Browser ──HTTP──▶ Flask app (Gunicorn, :5000) ──SQL──▶ PostgreSQL
```

## Stack

- **App:** Python, Flask, Gunicorn, psycopg2
- **Database:** PostgreSQL 16
- **Containers:** Docker, Docker Compose
- **Orchestration:** Kubernetes (minikube)

## Project layout

```
.
├── app.py                 # Flask API + creates the table on startup
├── templates/index.html   # Frontend (HTML + JavaScript)
├── requirements.txt
├── Dockerfile             # Non-root user, health check, Gunicorn
├── docker-compose.yml     # App + Postgres for local use
├── .env.example           # Copy to .env and set your own password
└── k8s/
    ├── 00-secret.yaml     # DB credentials (placeholder values)
    ├── 10-postgres.yaml   # Headless Service + StatefulSet + persistent volume
    └── 20-web.yaml        # Deployment (2 replicas), probes, Service
```

## Run with Docker Compose

```bash
cp .env.example .env        # optional: set your own DB password
docker compose up --build
```

Open http://localhost:5000. Stop with `docker compose down` (add `-v` to also delete the data volume).

## Run on Kubernetes (minikube)

```bash
minikube start --driver=docker

docker build -t todo-web:1.0 .
minikube image load todo-web:1.0
minikube image load postgres:16-alpine

kubectl apply -f k8s/
kubectl get pods -w

kubectl port-forward svc/web 8080:5000
```

Open http://localhost:8080.

Clean up:

```bash
kubectl delete -f k8s/
kubectl delete pvc -l app=postgres
minikube delete
```

## What this project demonstrates

- Dockerfile with layer caching, non-root user, `COPY --chown`, and a health check
- Gunicorn in the container instead of Flask's development server
- Compose startup order based on a database health check
- Kubernetes Deployment, StatefulSet with persistent storage, Secrets, readiness/liveness probes, and rolling updates
- Config through environment variables (no credentials in the image)

## Lessons learned

- Gunicorn never runs the `if __name__ == "__main__"` block, so database setup must run at import time.
- A non-root container user needs read access to the copied files (`COPY --chown`).
- minikube cannot see local Docker images until they are loaded with `minikube image load`.

## Next steps

Deploy to AWS, add CI/CD with GitHub Actions, and describe the infrastructure with Terraform.

## Security note

`k8s/00-secret.yaml` contains placeholder credentials for local learning only. Kubernetes Secrets are base64-encoded, not encrypted. Do not commit real passwords.
