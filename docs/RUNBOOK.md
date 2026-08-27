# TM3L Postmortem Machine — Operational Runbook

## 1. Quick Start & Triage
```bash
just preflight
just up
just health
just logs
```

## 2. Port Architecture
- **Go API Server**: `http://localhost:8083`
- **React Incident Explorer**: `http://localhost:5175`
- **PostgreSQL Database**: `localhost:5434`

## 3. Incident Playbooks
- **Python NLP Worker Stalls**: Check `docker compose logs postmortem-jobs` for memory spikes during spaCy / NLP embeddings.
- **Database Connection Reset**: Run `just health` to verify PostgreSQL status.
