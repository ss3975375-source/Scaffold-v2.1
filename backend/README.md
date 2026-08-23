# Backend foundation

The backend is intentionally small at this stage. It provides the starting point for the modular Go API.

## Local development

From the repository root:

```bash
docker compose -f docker-compose.foundation.yml up --build
```

The API health endpoint is then available at `http://localhost:8080/health`.

> The credentials in `docker-compose.foundation.yml` are development-only placeholders. Never use them in production.

Production secrets will be supplied through the deployment environment and secret manager rather than committed to Git.
