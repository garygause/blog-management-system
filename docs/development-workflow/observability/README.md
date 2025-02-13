# Logging and Observability

## Logging Strategy

### Log Levels and Usage

```typescript
// utils/logger.ts
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  defaultMeta: { service: 'api-service' },
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

// Usage examples
logger.error('Database connection failed', {
  error: err.message,
  stack: err.stack,
  context: {
    operation: 'connect',
    database: 'users',
  },
});

logger.info('User action completed', {
  userId: user.id,
  action: 'profile_update',
  changes: ['email', 'avatar'],
});
```

### Structured Logging

```typescript
// types/logging.ts
interface LogEntry {
  timestamp: string;
  level: 'error' | 'warn' | 'info' | 'debug';
  message: string;
  context: Record<string, unknown>;
  requestId?: string;
  userId?: string;
  traceId?: string;
}

// middleware/requestLogger.ts
export const requestLogger = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const startTime = Date.now();
  const requestId = req.headers['x-request-id'] || uuid();

  // Log request
  logger.info('Incoming request', {
    requestId,
    method: req.method,
    path: req.path,
    query: req.query,
    headers: pickHeaders(req.headers),
    ip: req.ip,
  });

  // Log response
  res.on('finish', () => {
    const duration = Date.now() - startTime;
    logger.info('Request completed', {
      requestId,
      statusCode: res.statusCode,
      duration,
      contentLength: res.get('Content-Length'),
    });
  });

  next();
};
```

## Metrics Collection

### Application Metrics

```typescript
// metrics/applicationMetrics.ts
import { Registry, Counter, Histogram } from 'prom-client';

const register = new Registry();

export const httpRequestsTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'path', 'status'],
  registers: [register],
});

export const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'path'],
  buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10],
  registers: [register],
});

// Middleware usage
app.use((req, res, next) => {
  const start = process.hrtime();

  res.on('finish', () => {
    const duration = process.hrtime(start);
    const durationSeconds = duration[0] + duration[1] / 1e9;

    httpRequestsTotal.inc({
      method: req.method,
      path: req.route?.path || 'unknown',
      status: res.statusCode,
    });

    httpRequestDuration.observe(
      { method: req.method, path: req.route?.path || 'unknown' },
      durationSeconds
    );
  });

  next();
});
```

### Business Metrics

```typescript
// metrics/businessMetrics.ts
export const userSignups = new Counter({
  name: 'user_signups_total',
  help: 'Total number of user signups',
  labelNames: ['source'],
});

export const orderValue = new Histogram({
  name: 'order_value_dollars',
  help: 'Distribution of order values',
  buckets: [10, 50, 100, 500, 1000, 5000],
});

// Usage in business logic
async function createUser(userData: UserDTO) {
  const user = await userService.create(userData);
  userSignups.inc({ source: userData.source });
  return user;
}
```

## Tracing

### OpenTelemetry Setup

```typescript
// tracing/tracer.ts
import { NodeTracerProvider } from '@opentelemetry/node';
import { SimpleSpanProcessor } from '@opentelemetry/tracing';
import { JaegerExporter } from '@opentelemetry/exporter-jaeger';

const provider = new NodeTracerProvider();
const exporter = new JaegerExporter({
  endpoint: 'http://jaeger:14268/api/traces',
});

provider.addSpanProcessor(new SimpleSpanProcessor(exporter));
provider.register();

const tracer = provider.getTracer('api-service');

// Usage in application code
async function processOrder(orderId: string) {
  const span = tracer.startSpan('process_order');

  try {
    span.setAttribute('order_id', orderId);

    const order = await orderService.get(orderId);
    span.addEvent('order_retrieved');

    await paymentService.process(order);
    span.addEvent('payment_processed');

    return order;
  } catch (error) {
    span.recordException(error);
    throw error;
  } finally {
    span.end();
  }
}
```

## Alerting Configuration

```typescript
// monitoring/alerts.ts
export const alertRules = {
  highErrorRate: {
    alert: 'HighErrorRate',
    expr: 'rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05',
    for: '5m',
    labels: {
      severity: 'critical',
    },
    annotations: {
      summary: 'High HTTP error rate',
      description: 'Error rate is above 5% for the last 5 minutes',
    },
  },
  slowResponses: {
    alert: 'SlowResponses',
    expr: 'histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2',
    for: '5m',
    labels: {
      severity: 'warning',
    },
    annotations: {
      summary: 'Slow HTTP responses',
      description: '95th percentile of response time is above 2 seconds',
    },
  },
};
```
