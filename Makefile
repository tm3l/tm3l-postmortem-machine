.PHONY: all build build-server build-jobs build-explorer test test-server test-jobs test-explorer docker-up docker-down clean

all: build

build: build-server build-jobs build-explorer

build-server:
	@echo "==> Building Go server..."
	cd server && go build -v -o ../bin/server ./cmd/server

build-jobs:
	@echo "==> Building Python jobs package..."
	cd jobs && python -m pip install -e .

build-explorer:
	@echo "==> Building React explorer..."
	cd explorer && npm install && npm run build

test: test-server test-jobs test-explorer

test-server:
	@echo "==> Running Go server tests..."
	cd server && go test -v ./...

test-jobs:
	@echo "==> Running Python tests..."
	cd jobs && pytest

test-explorer:
	@echo "==> Running React explorer tests / typechecks..."
	cd explorer && npm test --if-present

docker-up:
	@echo "==> Starting containers..."
	docker compose up --build -d

docker-down:
	@echo "==> Stopping containers..."
	docker compose down

clean:
	@echo "==> Cleaning build artifacts..."
	rm -rf bin/ explorer/dist/
