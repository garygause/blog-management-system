# Security Implementation Guide

## Authentication Implementation

### JWT Configuration

```typescript
// config/jwt.ts
import jwt from 'jsonwebtoken';
import { config } from './config';

export const jwtConfig = {
  secret: config.JWT_SECRET,
  accessTokenExpiry: '15m',
  refreshTokenExpiry: '7d',
  algorithm: 'HS256' as const,
};

export const generateTokens = (userId: string) => {
  const accessToken = jwt.sign({ userId }, jwtConfig.secret, {
    expiresIn: jwtConfig.accessTokenExpiry,
    algorithm: jwtConfig.algorithm,
  });

  const refreshToken = jwt.sign({ userId }, jwtConfig.secret, {
    expiresIn: jwtConfig.refreshTokenExpiry,
    algorithm: jwtConfig.algorithm,
  });

  return { accessToken, refreshToken };
};
```

### Password Handling

```typescript
// utils/password.ts
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

export const hashPassword = async (password: string): Promise<string> => {
  return bcrypt.hash(password, SALT_ROUNDS);
};

export const verifyPassword = async (
  password: string,
  hash: string
): Promise<boolean> => {
  return bcrypt.compare(password, hash);
};
```

## Security Middleware

### CORS Configuration

```typescript
// middleware/cors.ts
import cors from 'cors';
import { config } from '../config';

export const corsOptions: cors.CorsOptions = {
  origin: config.ALLOWED_ORIGINS,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  exposedHeaders: ['Content-Range', 'X-Content-Range'],
  credentials: true,
  maxAge: 600, // 10 minutes
};
```

### Rate Limiting

```typescript
// middleware/rateLimit.ts
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';
import { redis } from '../services/redis';

export const authLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: 'rate_limit_auth:',
  }),
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts, please try again later',
});

export const apiLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: 'rate_limit_api:',
  }),
  windowMs: 60 * 1000, // 1 minute
  max: 100, // 100 requests per minute
});
```

## Security Headers

```typescript
// middleware/securityHeaders.ts
import helmet from 'helmet';

export const securityHeaders = helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'", 'https://api.example.com'],
    },
  },
  crossOriginEmbedderPolicy: true,
  crossOriginOpenerPolicy: true,
  crossOriginResourcePolicy: { policy: 'same-site' },
  dnsPrefetchControl: true,
  frameguard: { action: 'deny' },
  hidePoweredBy: true,
  hsts: true,
  ieNoOpen: true,
  noSniff: true,
  referrerPolicy: { policy: 'strict-origin-when-cross-origin' },
  xssFilter: true,
});
```

## Input Validation

```typescript
// middleware/validate.ts
import { Request, Response, NextFunction } from 'express';
import { Schema } from 'joi';
import { ValidationError } from '../types/errors';

export const validate = (schema: Schema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const { error } = schema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true,
    });

    if (error) {
      const details = error.details.reduce((acc, detail) => {
        acc[detail.path[0]] = detail.message;
        return acc;
      }, {});

      throw new ValidationError(details);
    }

    next();
  };
};
```

## Security Best Practices

1. Data Protection

   - Encrypt sensitive data at rest
   - Use TLS for data in transit
   - Implement proper key management
   - Regular security audits

2. Session Management

   - Secure session configuration
   - Session timeout policies
   - Session fixation protection
   - Concurrent session control

3. Access Control

   - Role-based access control
   - Resource-level permissions
   - API endpoint protection
   - Regular access reviews
