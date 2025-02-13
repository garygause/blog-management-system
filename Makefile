.PHONY: install test lint format up down clean

# Development Setup
install:
	poetry install

# Testing
test:
	poetry run pytest

# Code Quality
lint:
	poetry run flake8 backend ai cli
	poetry run mypy backend ai cli
	poetry run black --check backend ai cli
	poetry run isort --check-only backend ai cli

format:
	poetry run black backend ai cli
	poetry run isort backend ai cli

# Docker Commands
up:
	docker-compose up -d

down:
	docker-compose down

# Database
db-migrate:
	poetry run alembic upgrade head

db-rollback:
	poetry run alembic downgrade -1

# Cleanup
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name "*.egg" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 