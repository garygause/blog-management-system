# Environment Setup Guide

## Development Environment

### Required Software Versions

- Node.js: v16.x or higher
- npm: v8.x or higher
- Git: v2.x or higher
- Docker: v20.x or higher
- Docker Compose: v2.x

### IDE Setup

1. VS Code Recommended Extensions

   - ESLint
   - Prettier
   - GitLens
   - Docker
   - Jest Runner
   - TypeScript Extension Pack

2. IDE Configuration

   ```json
   {
     "editor.formatOnSave": true,
     "editor.codeActionsOnSave": {
       "source.fixAll.eslint": true
     },
     "typescript.updateImportsOnFileMove.enabled": "always",
     "javascript.updateImportsOnFileMove.enabled": "always"
   }
   ```

### Local Development

1. Database Setup

   ```bash
   # Start PostgreSQL container
   docker-compose up -d db

   # Run migrations
   npm run migrate:dev

   # Seed initial data
   npm run seed:dev
   ```

2. Environment Variables

   ```env
   # Required Variables
   DATABASE_URL=postgresql://user:password@localhost:5432/dbname
   JWT_SECRET=your-secret-key
   API_URL=http://localhost:3000/api

   # Optional Variables
   LOG_LEVEL=debug
   ENABLE_SWAGGER=true
   CORS_ORIGIN=http://localhost:3000
   ```

3. Development Server

   ```bash
   # Install dependencies
   npm install

   # Start development server
   npm run dev

   # Start with debugging
   npm run dev:debug
   ```

## Troubleshooting

### Common Issues

1. Database Connection

   - Check PostgreSQL service is running
   - Verify connection string
   - Confirm port availability

2. Node.js Issues

   - Clear node_modules and package-lock.json
   - Rebuild dependencies
   - Check Node.js version compatibility

3. Docker Issues

   - Reset Docker daemon
   - Clear Docker cache
   - Check resource allocation
