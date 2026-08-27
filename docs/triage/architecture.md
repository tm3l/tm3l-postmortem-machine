# Postmortem Machine Architecture

## 1. System Overview

Postmortem Machine is an automated incident pattern extraction and reliability auditing platform. The system is designed around a three-tier architecture optimized for high-throughput ingestion, sophisticated natural language parsing, and rapid interactive vulnerability exploration.

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
   │              ▼                                         ▼               │
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
                    └──────────────────────────────────────────┘
```

---

## 2. Three-Tier Architectural Components

### Tier 1: Ingestion & Control Plane (Go API Server)
- **Role**: Primary entry point for incident intake, webhook endpoints, data persistence coordination, and admin review workflows.
- **Key Modules**:
  - `internal/api`: RESTful OpenAPI-compliant endpoints for frontend applications and automated crawlers.
  - `internal/ingest`: Raw payload intake, content normalization (Markdown/HTML/text cleaning), and dispatching jobs to the worker queue.
  - `internal/patterns`: Failure pattern lookup, similarity filtering, and checklist generation.
  - `internal/store`: Database access layer (PostgreSQL connection pool, schema migrations, and queries).
  - `internal/web`: Server-rendered admin and review interface built with `templ` + `HTMX` for low-overhead administrative verification.
- **Why Go**: Go delivers exceptional concurrency characteristics, fast cold-start performance, predictable memory usage, and single-binary deployment.

### Tier 2: Intelligence & Processing Plane (Python NLP Worker)
- **Role**: Asynchronous execution of compute-heavy natural language processing, entity extraction, taxonomy classification, and pattern clustering.
- **Key Modules**:
  - `src/postmortem_jobs/extract.py`: Parses unstructured text to pull out chronological event logs, root cause statements, and trigger triggers.
  - `src/postmortem_jobs/classify.py`: Evaluates extracted content against established reliability taxonomy graphs (e.g., cascade failure, split-brain, thundering herd, configuration drift).
  - `src/postmortem_jobs/patterns.py`: Calculates cross-incident vector similarity, clusters recurring structural failure signatures, and links new incidents to global pattern definitions.
  - `src/postmortem_jobs/summarize.py`: Optional integration with LLM providers for concise executive synthesis and automated checklist drafting.
- **Why Python**: Unmatched ecosystem for machine learning, linguistic parsing (`spaCy`), vector embeddings, and LLM orchestration.

### Tier 3: Presentation Plane (React Incident Explorer)
- **Role**: Rich client-side single page application allowing engineers to search incidents, visualize failure cascades, and evaluate their own systems against patterns.
- **Tech**: React 19, TypeScript, Vite 6, TailwindCSS.
- **Key Capabilities**:
  - Semantic and keyword search across postmortems.
  - Graph-based pattern visualization showing shared failure modes across different systems.
  - Interactive "Am I Vulnerable?" defensive checklists that engineering teams can run against their infrastructure.

---

## 3. Go-to-Python Job Orchestration Workflow

The Go server acts as the central coordinator and source of truth, managing job lifecycles for the Python workers:

```
[Client / Crawler]
       │
       │ 1. POST /api/v1/incidents (Raw postmortem)
       ▼
[Go API Server]
       │
       │ 2. Persist incident record with status = 'pending'
       ▼
[PostgreSQL]
       │
       │ 3. Enqueue job / HTTP dispatch to Python Worker
       ▼
[Python NLP Jobs Worker]
       │
       │ 4. Run entity extraction (extract.py)
       │ 5. Run taxonomy classification (classify.py)
       │ 6. Match pattern clusters & generate vectors (patterns.py)
       ▼
[PostgreSQL] (Write entities, taxonomy tags, embeddings)
       │
       │ 7. Callback / Status update (status = 'classified')
       ▼
[Go API Server] (templ/HTMX Admin Dashboard)
       │
       │ 8. Human Review / Approval
       ▼
[React Explorer UI] (Available for vulnerability checks)
```

1. **Ingest**: The Go API receives raw postmortem text via REST or crawler pipelines and stores it in PostgreSQL with status `pending`.
2. **Dispatch**: The Go ingestion pipeline issues an asynchronous job request to the Python jobs service (via HTTP/gRPC or worker queue).
3. **Execution**: The Python worker processes the incident through extraction, classification, and similarity matching stages.
4. **Storage & Vectorization**: Extracted metadata and high-dimensional semantic embeddings are stored directly in PostgreSQL with `pgvector`.
5. **Review & Publication**: The Go server flags the report as `classified` and presents it to human operators in the templ/HTMX dashboard for verification before making it active in the public Explorer.
