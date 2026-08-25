# 🔬 tm3l-postmortem-machine

> **Feed it incident reports and it extracts the failure patterns so you can check if YOU'RE vulnerable to the same thing.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8.svg)](server/go.mod)
[![Python Version](https://img.shields.io/badge/Python-3.12-3776AB.svg)](jobs/pyproject.toml)
[![React](https://img.shields.io/badge/React-19-61DAFB.svg)](explorer/package.json)

---

## 📖 Table of Contents
1. [Overview](#-overview)
2. [Architecture](#-architecture)
3. [Tech Stack](#-tech-stack)
4. [Getting Started](#-getting-started)
5. [Documentation](#-documentation)

---

## 🌟 Overview
Incident intelligence platform that parses unstructured public postmortems using NLP. It extracts failure cascades, generates vector embeddings to cluster similar architectural weaknesses, and outputs actionable "Am I Vulnerable?" audit checklists.

## 📊 Architecture

```mermaid
graph TD
    subgraph "Client Tier"
        UI[React 19 Incident Explorer]
        Admin[Go templ + HTMX Review Panel]
    end

    subgraph "Core Orchestration"
        Go[Go 1.23 API Gateway]
    end

    subgraph "Machine Learning Jobs"
        Py[Python 3.12 NLP & spaCy]
    end

    subgraph "Data & Vector Store"
        PG[(PostgreSQL 17 + pgvector)]
        PB[(PocketBase 0.25)]
    end

    UI -->|REST API| Go
    UI -->|Live Checklists SSE| PB
    Admin -->|HTML CRUD| Go
    Go -->|Dispatch Jobs| Py
    Py -->|Extract & Embed| PG
    Go -->|SQL / Similarity Search| PG
    Go -->|Publish Results| PB
```

## 🛠 Tech Stack
- **API Orchestrator**: Go 1.23 + `templ` + `HTMX`
- **NLP Engine**: Python 3.12 + `uv` + `spaCy`
- **Incident Explorer**: React 19 + TypeScript + Vite 6
- **Databases**: PostgreSQL 17 (`pgvector`) + PocketBase 0.25 (Edge/Real-time)

## 🚀 Getting Started
```bash
git clone https://github.com/tm3l/tm3l-postmortem-machine.git
cd tm3l-postmortem-machine
make docker-up
```
Visit `http://localhost:5175` to view the incident explorer.

## 📚 Documentation
See [`docs/architecture.md`](docs/architecture.md) for detailed internals.
