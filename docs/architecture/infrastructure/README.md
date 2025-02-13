# Infrastructure Setup

## Cloud Infrastructure

### AWS Architecture

```yaml
# infrastructure/terraform/main.tf
provider "aws" {
region = "us-west-2"
}

module "vpc" {
source = "./modules/vpc"

vpc_cidr = "10.0.0.0/16"
azs      = ["us-west-2a", "us-west-2b"]
}

module "eks" {
source = "./modules/eks"

cluster_name    = "production"
cluster_version = "1.24"
vpc_id         = module.vpc.vpc_id
subnet_ids     = module.vpc.private_subnets
}

module "rds" {
source = "./modules/rds"

identifier     = "production"
engine         = "postgres"
engine_version = "14.5"
instance_class = "db.t3.medium"
}
```

### Kubernetes Configuration

```yaml
# kubernetes/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-service
  template:
    metadata:
      labels:
        app: api-service
    spec:
      containers:
        - name: api
          image: api-service:1.0.0
          ports:
            - containerPort: 3000
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: database-credentials
                  key: url
          resources:
            requests:
              memory: '128Mi'
              cpu: '100m'
            limits:
              memory: '256Mi'
              cpu: '200m'
```

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/main.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      - name: Build and push Docker image
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
```

## Monitoring Setup

### Prometheus Configuration

```yaml
# monitoring/prometheus/config.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'api-service'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['api-service:3000']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

### Grafana Dashboard

```json
{
  "dashboard": {
    "id": null,
    "title": "API Service Dashboard",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{path}}"
          }
        ]
      },
      {
        "title": "Response Times",
        "type": "graph",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          }
        ]
      }
    ]
  }
}
```
