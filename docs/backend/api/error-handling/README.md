# API Error Handling

## Error Response Structure

### Standard Error Format

```typescript
interface ApiError {
  status: number; // HTTP status code
  code: string; // Internal error code
  message: string; // User-friendly message
  details?: object; // Additional error details
  timestamp: string; // Error occurrence time
  requestId?: string; // Request tracking ID
}
```

### Example Error Responses

```json
// 400 Bad Request
{
  "status": 400,
  "code": "VALIDATION_ERROR",
  "message": "Invalid input parameters",
  "details": {
    "email": "Must be a valid email address",
    "password": "Must be at least 8 characters"
  },
  "timestamp": "2024-03-20T10:30:45Z",
  "requestId": "req_123abc"
}

// 401 Unauthorized
{
  "status": 401,
  "code": "INVALID_TOKEN",
  "message": "Authentication token is invalid or expired",
  "timestamp": "2024-03-20T10:31:45Z",
  "requestId": "req_456def"
}
```

## Error Handling Middleware

```typescript
// middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';
import { ApiError } from '../types/errors';
import { logger } from '../utils/logger';

export const errorHandler = (
  error: Error | ApiError,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  // Generate unique request ID
  const requestId = req.headers['x-request-id'] || generateRequestId();

  // Log error details
  logger.error({
    requestId,
    error: error.message,
    stack: error.stack,
    path: req.path,
    method: req.method,
  });

  // Handle known API errors
  if (error instanceof ApiError) {
    return res.status(error.status).json({
      status: error.status,
      code: error.code,
      message: error.message,
      details: error.details,
      timestamp: new Date().toISOString(),
      requestId,
    });
  }

  // Handle unknown errors
  return res.status(500).json({
    status: 500,
    code: 'INTERNAL_SERVER_ERROR',
    message: 'An unexpected error occurred',
    timestamp: new Date().toISOString(),
    requestId,
  });
};
```

## Custom Error Classes

```typescript
// types/errors.ts
export class ApiError extends Error {
  constructor(
    public status: number,
    public code: string,
    message: string,
    public details?: object
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

export class ValidationError extends ApiError {
  constructor(details: object) {
    super(400, 'VALIDATION_ERROR', 'Invalid input parameters', details);
    this.name = 'ValidationError';
  }
}

export class AuthenticationError extends ApiError {
  constructor(message = 'Authentication failed') {
    super(401, 'AUTHENTICATION_ERROR', message);
    this.name = 'AuthenticationError';
  }
}

export class AuthorizationError extends ApiError {
  constructor(message = 'Insufficient permissions') {
    super(403, 'AUTHORIZATION_ERROR', message);
    this.name = 'AuthorizationError';
  }
}
```

## Error Handling Best Practices

1. Input Validation

   - Validate all input parameters
   - Use strong typing with TypeScript
   - Implement request schemas
   - Return detailed validation errors

2. Authentication/Authorization

   - Clear error messages for auth failures
   - Don't expose sensitive information
   - Log authentication attempts
   - Rate limit auth endpoints

3. Database Errors

   - Handle connection failures
   - Manage transaction rollbacks
   - Handle unique constraint violations
   - Log database errors securely

4. External Service Errors

   - Implement timeouts
   - Handle service unavailability
   - Provide fallback responses
   - Monitor external service health
