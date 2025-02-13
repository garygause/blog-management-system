# Backend Documentation

This section covers the backend architecture, API design, and implementation details.

## Architecture Overview

Our backend is built using:

- Node.js
- Express.js
- PostgreSQL
- TypeORM

## API Structure

```
backend/
├── src/
│ ├── controllers/
│ ├── models/
│ ├── routes/
│ ├── services/
│ ├── middleware/
│ └── utils/
```

## API Documentation

### Authentication

```typescript
POST / api / auth / login;
POST / api / auth / register;
POST / api / auth / logout;
GET / api / auth / me;
```

### Users

```typescript
typescript
GET /api/users
GET /api/users/:id
PUT /api/users/:id
DELETE /api/users/:id
```

## Database Schema

See our [Database Documentation](./database/README.md) for detailed schema information.

## Error Handling

We use standardized error responses:

```typescript
{
status: number,
message: string,
errors?: Array<{
field: string,
message: string
}>
}
```
