# Getting Started

This guide will help you set up and run the project on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:

- Node.js (v14 or higher)
- npm or yarn
- Git
- Docker (optional, for containerized development)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-repo/project-name.git
   cd project-name
   ```

2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up environment variables:

   ```bash
   cp .env.example .env
   ```

4. Configure your environment variables in the `.env` file.

## Running the Application

### Development Mode

```bash
npm run dev
```

### Production Mode

```bash
npm run build
npm run start
```

## Next Steps

- Review the [Frontend Documentation](../frontend/README.md) to understand the component structure
- Check the [Backend Documentation](../backend/README.md) for API integration
- Read the [Development Workflow](../development-workflow/README.md) for contribution guidelines
