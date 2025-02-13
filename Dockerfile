# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# ENV for poetry https://python-poetry.org/docs/configuration/#using-environment-variables
# make poetry create the virtual environment in the project's root, it gets named `.venv`
# and do not ask any interactive question
ENV POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=1

# Prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python -

# Copy project files
COPY pyproject.toml poetry.lock README.md ./
COPY api api/
COPY blog_management_system blog_management_system/
COPY cli cli/

# Install dependencies
RUN poetry install 

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# Expose port
EXPOSE 8000

# Run the application
CMD ["poetry", "run", "uvicorn", "api.app.main:app", "--host", "0.0.0.0", "--port", "8000"] 