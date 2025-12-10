.PHONY: help build run stop clean logs shell test

# Default target
help:
	@echo "🤖 AI Code Reviewer - Docker Commands"
	@echo "======================================"
	@echo "make build       - Build Docker image"
	@echo "make run         - Run container"
	@echo "make stop        - Stop container"
	@echo "make restart     - Restart container"
	@echo "make logs        - View container logs"
	@echo "make shell       - Open shell in container"
	@echo "make clean       - Remove container and image"
	@echo "make compose-up  - Start with docker-compose"
	@echo "make compose-down- Stop docker-compose"
	@echo "make test        - Test the application"

# Build Docker image
build:
	@echo "🏗️  Building Docker image..."
	docker build -t ai-code-reviewer:latest .

# Run container
run:
	@echo "🚀 Starting container..."
	docker run -d \
		--name ai-code-reviewer \
		-p 3001:3001 \
		--env-file .env \
		ai-code-reviewer:latest
	@echo "✅ Container started at http://localhost:3001"

# Stop container
stop:
	@echo "⏹️  Stopping container..."
	docker stop ai-code-reviewer || true
	docker rm ai-code-reviewer || true

# Restart container
restart: stop run

# View logs
logs:
	docker logs -f ai-code-reviewer

# Open shell in container
shell:
	docker exec -it ai-code-reviewer sh

# Clean up
clean: stop
	@echo "🧹 Cleaning up..."
	docker rmi ai-code-reviewer:latest || true

# Docker Compose commands
compose-up:
	@echo "🚀 Starting with docker-compose..."
	docker-compose up -d
	@echo "✅ Services started"

compose-down:
	@echo "⏹️  Stopping docker-compose services..."
	docker-compose down

compose-logs:
	docker-compose logs -f

# Test application
test:
	@echo "🧪 Testing application..."
	curl -X POST http://localhost:3001/review \
		-H "Content-Type: application/json" \
		-d '{"code":"function test() { console.log(\"Hello\"); }"}' || echo "Container not running"

# Development mode
dev:
	npm install
	npm start
