# CLI Documentation

## Overview

The CLI tool provides commands for managing blog content, SEO analysis, and content publishing.

### Installation

```bash
# Install using Poetry
poetry install

# Install in development mode
make install-dev
```

## Commands

### Blog Management

```bash
# Create new blog post
blog create --topic "AI Trends" --keywords "machine learning,artificial intelligence"

# List blog posts
blog list --status draft

# Edit blog post
blog edit --id 123 --content-file updated_post.md

# Publish blog post
blog publish --id 123 --platform wordpress
```

### SEO Tools

```bash
# Analyze content
blog seo analyze --id 123

# Generate keywords
blog seo keywords --topic "Machine Learning"

# Get SEO report
blog seo report --id 123 --format json
```

### Performance Monitoring

```bash
# Get analytics
blog analytics --id 123 --timeframe 30d

# Generate performance report
blog report --id 123 --metrics "views,engagement,conversions"
```

## Makefile Commands

```makefile
# Makefile
.PHONY: install test lint run

install:
    poetry install

test:
    poetry run pytest

lint:
    poetry run flake8
    poetry run black .

run:
    poetry run uvicorn app.main:app --reload
```

## Configuration

```bash
# Set up configuration
blog config set api-key "your-api-key"
blog config set default-platform "medium"

# View configuration
blog config list
```
