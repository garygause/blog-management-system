# Project Structure

```
project_root/
├── .cursor/                      # Cursor IDE configuration
│   ├── rules/                    # Cursor rules
│   └── prompts/                  # Cursor prompts
│
├── .github/                      # GitHub configuration
│   └── workflows/                # GitHub Actions
│
├── ai/                           # AI Components
│   ├── agents/                   # LangChain Agents
│   │   ├── __init__.py
│   │   ├── base.py              # Base agent class
│   │   ├── content.py           # Content generation agent
│   │   ├── seo.py              # SEO analysis agent
│   │   ├── publishing.py        # Publishing agent
│   │   └── monitoring.py        # Performance monitoring agent
│   │
│   ├── workflows/               # LangGraph Workflows
│   │   ├── __init__.py
│   │   ├── blog_workflow.py     # Main blog creation workflow
│   │   └── states.py           # Workflow state definitions
│   │
│   └── prompts/                 # LangChain Prompts
│       ├── __init__.py
│       ├── content.py          # Content generation prompts
│       ├── seo.py             # SEO analysis prompts
│       └── templates/         # Prompt templates
│
├── backend/                     # FastAPI Backend
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py            # FastAPI application
│   │   ├── core/              # Core functionality
│   │   │   ├── config.py      # Configuration
│   │   │   └── security.py    # Security utilities
│   │   │
│   │   ├── api/               # API endpoints
│   │   │   ├── v1/
│   │   │   └── deps.py        # Dependencies
│   │   │
│   │   ├── models/            # Database models
│   │   ├── schemas/           # Pydantic schemas
│   │   └── services/          # Business logic
│   │
│   ├── tests/                 # Backend tests
│   │   ├── conftest.py
│   │   └── api/
│   │
│   └── alembic/               # Database migrations
│
├── frontend/                   # Next.js Frontend
│   ├── app/                   # Next.js 13+ App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── (auth)/           # Auth routes
│   │   ├── dashboard/        # Dashboard routes
│   │   └── posts/           # Blog post routes
│   │
│   ├── components/           # React components
│   │   ├── ui/              # UI components
│   │   └── forms/           # Form components
│   │
│   ├── lib/                 # Utilities and helpers
│   │   ├── api.ts          # API client
│   │   └── utils.ts        # Utility functions
│   │
│   └── tests/              # Frontend tests
│
├── cli/                    # CLI Tool
│   ├── __init__.py
│   ├── main.py            # Click CLI implementation
│   ├── commands/          # CLI commands
│   └── tests/             # CLI tests
│
├── infrastructure/         # Infrastructure as Code
│   ├── terraform/         # Terraform configurations
│   └── kubernetes/        # Kubernetes manifests
│
├── scripts/               # Development scripts
│   ├── setup.sh          # Setup script
│   └── seed.py           # Database seeding
│
├── docs/                  # Documentation
│   ├── api/              # API documentation
│   ├── architecture/     # Architecture docs
│   └── guides/          # User guides
│
├── .env.example          # Example environment variables
├── docker-compose.yml    # Docker Compose configuration
├── Dockerfile           # Docker configuration
├── Makefile            # Make commands
├── poetry.lock         # Poetry lock file
├── pyproject.toml      # Python project configuration
├── package.json        # Node.js dependencies
└── README.md           # Project README
```

## Key Components

### AI Module

- Implements LangChain agents and workflows
- Contains prompt templates and configurations
- Handles AI-powered content generation and analysis

### Backend Module

- FastAPI application with modular structure
- Database models and migrations
- API endpoints and business logic
- Authentication and authorization

### Frontend Module

- Next.js application with App Router
- React components and hooks
- API integration and state management
- User interface and interactions

### CLI Module

- Click-based command line interface
- Integration with AI and backend services
- Administrative and maintenance commands

### Infrastructure

- Terraform configurations for cloud resources
- Kubernetes manifests for container orchestration
- Docker configurations for local development

## Development Guidelines

1. Module Independence:

   - Each module should be independently deployable
   - Use clear interfaces between modules
   - Maintain separate dependency management

2. Configuration Management:

   - Use environment variables for configuration
   - Keep sensitive data out of version control
   - Use different configs for development/production

3. Testing Strategy:

   - Unit tests for individual components
   - Integration tests for module interactions
   - End-to-end tests for critical paths

4. Documentation:

   - Keep documentation close to code
   - Use type hints and docstrings
   - Maintain API documentation
   - Document architectural decisions

5. Version Control:
   - Follow conventional commits
   - Use feature branches
   - Maintain clean git history
