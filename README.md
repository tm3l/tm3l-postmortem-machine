# 🔬 Postmortem Machine

**Feed it incident reports and it extracts the failure patterns so you can check if YOU'RE vulnerable to the same thing.**

Postmortem Machine is an automated incident intelligence system. It ingests public and internal postmortem/incident reports, runs NLP and classification pipelines to extract failure modes and root causes, clusters systemic failure patterns across organizations, and generates interactive "Am I Vulnerable?" audit checklists for engineering teams.

---

## 🚧 Project Status

**Status**: 🚧 Under Construction — Active architectural scaffolding & pipeline development.

---

## ✨ Features

- **📥 Postmortem Ingestion**: Ingest incident reports from Markdown, PDF, HTML, or public sources (e.g., status pages, engineering blogs).
- **🧠 NLP Failure Extraction**: Extract affected components, trigger events, failure cascades, and mitigation steps via Python NLP pipelines.
- **🔍 Failure Mode Classification**: Categorize incidents using standard reliability taxonomies (e.g., cascading timeouts, stale cache stampede, split-brain DNS, missing circuit breaker).
- **🧩 Cross-Incident Pattern Clustering**: Identify shared systemic weaknesses appearing across multiple organizations or services.
- **🛡️ "Am I Vulnerable?" Checklists**: Generate actionable verification checklists to evaluate your infrastructure against known failure modes.
- **👥 Human Review & Admin Dashboard**: Review extracted patterns, tune classifications, and approve patterns with Go templ + HTMX interface.
- **📊 React Incident Explorer**: Rich frontend to search, filter, and explore historical postmortems, root causes, and prevention strategies.

---

## 🏗️ Architecture

```
                    ┌──────────────────────────────────────────┐
                    │               Data Sources               │
                    │   (Public Blogs, Status Pages, Docs)     │
                    └────────────────────┬─────────────────────┘
                                         │ Ingest
                                         ▼
   ┌────────────────────────────────────────────────────────────────────────┐
   │                     Postmortem Machine Backend                         │
   │                                                                        │
   │   ┌─────────────────────┐                  ┌───────────────────────┐   │
   │   │   Go API Server     │◄─ Job Triggers ─►│   Python NLP Jobs     │   │
   │   │  (Ingest & Admin)   │   & Status Sync  │ (Extract / Classify)  │   │
   │   └──────────┬──────────┘                  └───────────┬───────────┘   │
   │              │                                         │               │
   │              ▼                                         │               │
   │        ┌─────────────────────────────────────────────────────┐         │
   │        │               PostgreSQL + pgvector                 │         │
   │        │     (Incidents, Failure Patterns, Checklists)       │         │
   │        └──────────────────────────┬──────────────────────────┘         │
   └───────────────────────────────────┼────────────────────────────────────┘
                                       │ Query
                                       ▼
                    ┌──────────────────────────────────────────┐
                    │       React Incident Explorer (UI)       │
                    │   Search, Pattern Graphs & Checklists    │
                    └────────────────────┬─────────────────────┘
```

---

## 🧰 Tech Stack

| Component | Technology | Rationale |
| :--- | :--- | :--- |
| **API Server & Admin** | **Go 1.23**, `templ`, `HTMX` | High-throughput ingestion orchestration, lightweight concurrency, and fast server-rendered admin workflows without complex build steps. |
| **NLP & Extraction Jobs** | **Python 3.12**, `spaCy`, `hatch`/`uv` | Rich ecosystem for natural language parsing, entity extraction, taxonomy classification, and optional LLM summarization tasks. |
| **Storage & Vectors** | **PostgreSQL 16** (`pgvector`) | Relational integrity for incident metadata combined with vector embeddings for semantic pattern similarity. |
| **Incident Explorer** | **React 19**, **Vite 6**, **TypeScript**, **TailwindCSS** | High-interactivity frontend for visual pattern exploration, graph navigation, and interactive vulnerability audits. |
| **Deployment** | **Docker Compose**, **Kubernetes** | Unified containerization for heterogeneous Go and Python services with seamless local dev and scalable cloud deployment. |

---

## 🚀 Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/)
- Optional local toolchains: Go 1.23+, Python 3.12+ (`uv`), Node.js 22+ (`pnpm` or `npm`)

### Run with Docker Compose

```bash
# Clone the repository
git clone https://github.com/tm3l/tm3l-postmortem-machine.git
cd postmortem-machine

# Start PostgreSQL, Go API Server, and Python Jobs worker
docker compose up --build
```

Access the services:
- **Go API & Admin UI**: `http://localhost:8080`
- **React Incident Explorer**: `http://localhost:5173`
- **PostgreSQL**: `localhost:5432` (`postmortem` / `postmortem`)

---

## 🛠️ Local Development

A root `Makefile` provides common commands:

```bash
# Build all components
make build

# Build individual services
make build-server
make build-jobs
make build-explorer

# Run test suites
make test

# Start / stop docker compose stack
make docker-up
make docker-down
```

---

## 📂 Repository Structure

```
postmortem-machine/
├── server/               # Go API server & templ/HTMX admin UI
│   ├── cmd/server/       # Application entrypoint
│   ├── internal/         # Ingest orchestration, pattern matching, data store
│   └── api/              # OpenAPI specification
├── jobs/                 # Python NLP extraction and classification pipeline
│   └── src/              # Extraction, classification, pattern clustering modules
├── explorer/             # React 19 + Vite incident exploration SPA
├── deploy/               # Dockerfiles and Kubernetes manifests
├── docs/                 # Architectural specifications and ADRs
└── bruno/                # Bruno API collection
```

---

## 📄 License

Distributed under the [MIT License](LICENSE).
