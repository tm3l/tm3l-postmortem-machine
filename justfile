# TM3L Postmortem Machine — Polyglot Task Runner

set shell := ["bash", "-c"]

default:
	@just --list

up:
	./scripts/up.sh

down:
	./scripts/down.sh

restart:
	./scripts/restart.sh

logs:
	docker compose logs -f

health:
	./scripts/healthcheck.sh

preflight:
	./scripts/preflight.sh

gen-secrets:
	./scripts/generate-secrets.sh

test: test-server test-jobs test-explorer
	@echo "All Postmortem Machine test suites passed successfully."

test-server:
	@echo "==> Running Go Server tests..."
	cd server && go test -race -coverprofile=coverage.out ./...

test-jobs:
	@echo "==> Running Python NLP tests..."
	cd jobs && pytest

test-explorer:
	@echo "==> Building React Explorer..."
	cd explorer && npm run build

lint: lint-server lint-jobs lint-explorer
	@echo "All Postmortem Machine lint checks passed."

lint-server:
	@echo "==> Linting Go Server..."
	cd server && go vet ./...

lint-jobs:
	@echo "==> Linting Python Jobs..."
	cd jobs && ruff check .

lint-explorer:
	@echo "==> Typechecking Explorer UI..."
	cd explorer && npx tsc -b --noEmit

build:
	@echo "==> Building Go Server..."
	cd server && go build -o bin/server cmd/server/main.go
	@echo "==> Building Explorer UI..."
	cd explorer && npm run build
