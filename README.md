# Cloud To-Do App

A simple 3-tier to-do list app: Flask API + HTML/JS frontend + PostgreSQL.
Built as a beginner cloud/DevOps project — this is Stage 1 (the app itself).

## Run it locally with Docker

```bash
docker-compose up --build
```

Then open http://localhost:5000

## What's next (the DevOps roadmap)

1. ✅ App running locally in Docker (you are here)
2. Push this to a GitHub repo
3. Set up Terraform to provision AWS infra (EC2/ECS + RDS)
4. Add a GitHub Actions pipeline: test → build image → push to ECR → deploy
5. Add CloudWatch monitoring / alarms
6. (Bonus) Load balancer + HTTPS

## Project structure

```
todo-app/
├── app.py              # Flask backend + API routes
├── templates/
│   └── index.html      # Frontend UI
├── requirements.txt
├── Dockerfile
├── docker-compose.yml   # Runs app + Postgres together
└── README.md
```
