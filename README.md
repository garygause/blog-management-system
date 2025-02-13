# Blog Management System

A modern blog management system powered by AI to help create, manage, and optimize blog content.

## Prerequisites

- Python 3.11 or higher
- Docker and Docker Compose (optional, for containerized setup)
- Node.js 18+ (for frontend)
- PostgreSQL (if running locally)

## Quick Start

### Local Development Setup

1. Clone the repository:

```bash
git clone https://github.com/yourusername/blog-management-system.git
cd blog-management-system
```

2. Set up environment variables:

```bash
cp .env.example .env
```

Edit `.env` with your configuration values, including:

- API keys (OpenAI, Groq)
- Database credentials
- JWT secrets

3. Install dependencies:

```bash
# Install Python dependencies
poetry install

# Install frontend dependencies
cd frontend
npm install
```

4. Initialize the database:

```bash
make db-migrate
```

5. Start the development servers:

```bash
# Start backend
make up

# In a new terminal, start frontend
cd frontend
npm run dev
```

The application will be available at:

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Documentation: http://localhost:8000/docs

### Docker Setup

1. Build and start the containers:

```bash
docker-compose up -d
```

2. Initialize the database:

```bash
docker-compose exec backend poetry run alembic upgrade head
```

## Project Structure

```
project_root/
├── ai/                           # AI Components
├── backend/                      # FastAPI Backend
├── frontend/                     # Next.js Frontend
├── cli/                         # CLI Tools
└── infrastructure/              # Infrastructure Config
```

See [Project Structure](docs/project-structure/README.md) for detailed documentation.

## Development

### Common Commands

```bash
# Install dependencies
make install

# Run tests
make test

# Format code
make format

# Lint code
make lint

# Start services
make up

# Stop services
make down
```

### Adding Dependencies

```bash
# Add Python package
poetry add package-name

# Add dev dependency
poetry add --group dev package-name
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

1. First, let's create the main package directory:

```bash
mkdir blog_management_system
```

2. Create an empty `__init__.py` in the package directory:

```bash
touch blog_management_system/__init__.py
```
