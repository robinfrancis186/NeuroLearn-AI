# Deployment Guide 🚀

## Overview

This guide covers deployment strategies for NeuroLearn AI across different environments: local development, staging, and production. The platform supports containerized deployment with Docker and Kubernetes.

## Table of Contents

1. [Local Development](#local-development)
2. [Staging Environment](#staging-environment)
3. [Production Deployment](#production-deployment)
4. [Container Orchestration](#container-orchestration)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [Monitoring & Health Checks](#monitoring--health-checks)
7. [Backup & Recovery](#backup--recovery)
8. [Scaling Strategies](#scaling-strategies)

## Local Development

### Prerequisites

- **Flutter SDK**: >=3.0.0
- **Dart SDK**: >=3.0.0
- **Python**: 3.8+
- **Docker**: Latest version
- **Docker Compose**: v2.0+
- **Node.js**: 18+ (for tooling)

### Quick Start

1. **Clone Repository**
   ```bash
   git clone https://github.com/your-org/neurolearn-ai.git
   cd neurolearn-ai
   ```

2. **Start Infrastructure Services**
   ```bash
   docker-compose up -d postgres redis
   ```

3. **Install Frontend Dependencies**
   ```bash
   flutter pub get
   ```

4. **Install Backend Dependencies**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

5. **Set Environment Variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

6. **Run Database Migrations**
   ```bash
   cd backend
   python manage.py migrate
   ```

7. **Start Services**
   ```bash
   # Terminal 1: Backend
   cd backend
   python -m uvicorn app.main:app --reload --port 8000
   
   # Terminal 2: Frontend
   flutter run -d web-server --web-port=8087
   ```

### Development Docker Compose

```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  frontend-dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8087:8087"
    volumes:
      - .:/app
      - /app/build  # Exclude build directory
    environment:
      - FLUTTER_WEB_PORT=8087
    command: flutter run -d web-server --web-port=8087 --web-hostname=0.0.0.0
    
  backend-dev:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    ports:
      - "8000:8000"
    volumes:
      - ./backend:/app
    environment:
      - DATABASE_URL=postgresql://user:pass@postgres:5432/neurolearn_dev
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    command: uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
    
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: neurolearn_dev
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    ports:
      - "5432:5432"
    volumes:
      - postgres_dev_data:/var/lib/postgresql/data
      
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_dev_data:/data

volumes:
  postgres_dev_data:
  redis_dev_data:
```

### Local Testing Commands

```bash
# Run all tests
make test

# Run frontend tests
flutter test

# Run backend tests
cd backend && python -m pytest

# Run integration tests
flutter test integration_test/

# Run linting
flutter analyze
cd backend && python -m flake8

# Generate documentation
flutter doc
```

## Staging Environment

### Infrastructure Setup

#### AWS Infrastructure (Terraform)

```hcl
# infrastructure/staging/main.tf
provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "staging" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "neurolearn-staging-vpc"
    Environment = "staging"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "staging" {
  name = "neurolearn-staging"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Application Load Balancer
resource "aws_lb" "staging" {
  name               = "neurolearn-staging-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.public[*].id

  enable_deletion_protection = false
}

# RDS Instance
resource "aws_db_instance" "staging" {
  identifier     = "neurolearn-staging"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  
  db_name  = "neurolearn"
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.staging.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  
  tags = {
    Name        = "neurolearn-staging-db"
    Environment = "staging"
  }
}

# ElastiCache Redis
resource "aws_elasticache_subnet_group" "staging" {
  name       = "neurolearn-staging-cache-subnet"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_elasticache_cluster" "staging" {
  cluster_id           = "neurolearn-staging"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.staging.name
  security_group_ids   = [aws_security_group.redis.id]
}
```

#### ECS Task Definitions

```json
{
  "family": "neurolearn-frontend-staging",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskExecutionRole",
  "taskRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskRole",
  "containerDefinitions": [
    {
      "name": "frontend",
      "image": "your-registry/neurolearn-frontend:staging",
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "API_BASE_URL",
          "value": "https://api-staging.neurolearn-ai.com"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/neurolearn-frontend-staging",
          "awslogs-region": "us-west-2",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

### Deployment Scripts

```bash
#!/bin/bash
# deploy-staging.sh

set -e

echo "🚀 Deploying NeuroLearn AI to Staging..."

# Build and push images
echo "📦 Building images..."
docker build -t neurolearn-frontend:staging .
docker build -t neurolearn-backend:staging ./backend

# Tag and push to registry
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com"

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $REGISTRY

docker tag neurolearn-frontend:staging $REGISTRY/neurolearn-frontend:staging
docker tag neurolearn-backend:staging $REGISTRY/neurolearn-backend:staging

docker push $REGISTRY/neurolearn-frontend:staging
docker push $REGISTRY/neurolearn-backend:staging

# Deploy infrastructure
echo "🏗️ Deploying infrastructure..."
cd infrastructure/staging
terraform apply -auto-approve

# Update ECS services
echo "🔄 Updating ECS services..."
aws ecs update-service \
  --cluster neurolearn-staging \
  --service neurolearn-frontend-service \
  --force-new-deployment

aws ecs update-service \
  --cluster neurolearn-staging \
  --service neurolearn-backend-service \
  --force-new-deployment

# Run database migrations
echo "📊 Running database migrations..."
aws ecs run-task \
  --cluster neurolearn-staging \
  --task-definition neurolearn-migrate:latest \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-12345],securityGroups=[sg-12345],assignPublicIp=ENABLED}"

echo "✅ Staging deployment complete!"
echo "🌐 Frontend: https://staging.neurolearn-ai.com"
echo "🔗 API: https://api-staging.neurolearn-ai.com"
```

## Production Deployment

### Production Infrastructure

#### Kubernetes Deployment

```yaml
# k8s/production/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: neurolearn-prod
  labels:
    name: neurolearn-prod
    environment: production
```

```yaml
# k8s/production/frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: neurolearn-frontend
  namespace: neurolearn-prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: neurolearn-frontend
  template:
    metadata:
      labels:
        app: neurolearn-frontend
    spec:
      containers:
      - name: frontend
        image: your-registry/neurolearn-frontend:latest
        ports:
        - containerPort: 80
        env:
        - name: API_BASE_URL
          value: "https://api.neurolearn-ai.com"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: neurolearn-frontend-service
  namespace: neurolearn-prod
spec:
  selector:
    app: neurolearn-frontend
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

```yaml
# k8s/production/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: neurolearn-backend
  namespace: neurolearn-prod
spec:
  replicas: 5
  selector:
    matchLabels:
      app: neurolearn-backend
  template:
    metadata:
      labels:
        app: neurolearn-backend
    spec:
      containers:
      - name: backend
        image: your-registry/neurolearn-backend:latest
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: neurolearn-secrets
              key: database-url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: neurolearn-secrets
              key: redis-url
        - name: MISTRAL_API_KEY
          valueFrom:
            secretKeyRef:
              name: neurolearn-secrets
              key: mistral-api-key
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: neurolearn-backend-service
  namespace: neurolearn-prod
spec:
  selector:
    app: neurolearn-backend
  ports:
  - port: 8000
    targetPort: 8000
  type: ClusterIP
```

#### Ingress Configuration

```yaml
# k8s/production/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: neurolearn-ingress
  namespace: neurolearn-prod
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  tls:
  - hosts:
    - neurolearn-ai.com
    - api.neurolearn-ai.com
    secretName: neurolearn-tls
  rules:
  - host: neurolearn-ai.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: neurolearn-frontend-service
            port:
              number: 80
  - host: api.neurolearn-ai.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: neurolearn-backend-service
            port:
              number: 8000
```

#### Database Configuration

```yaml
# k8s/production/postgres.yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgres-cluster
  namespace: neurolearn-prod
spec:
  instances: 3
  primaryUpdateStrategy: unsupervised
  
  postgresql:
    parameters:
      max_connections: "200"
      shared_buffers: "256MB"
      effective_cache_size: "1GB"
      maintenance_work_mem: "64MB"
      checkpoint_completion_target: "0.7"
      wal_buffers: "16MB"
      default_statistics_target: "100"
      random_page_cost: "1.1"
      effective_io_concurrency: "200"
      
  bootstrap:
    initdb:
      database: neurolearn
      owner: neurolearn_user
      secret:
        name: postgres-credentials
        
  storage:
    size: 100Gi
    storageClass: fast-ssd
    
  monitoring:
    enabled: true
    
  backup:
    retentionPolicy: "30d"
    barmanObjectStore:
      destinationPath: "s3://neurolearn-backups/postgres"
      s3Credentials:
        accessKeyId:
          name: backup-credentials
          key: ACCESS_KEY_ID
        secretAccessKey:
          name: backup-credentials
          key: SECRET_ACCESS_KEY
      wal:
        retention: "5d"
      data:
        retention: "30d"
```

### Production Secrets Management

```yaml
# k8s/production/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: neurolearn-secrets
  namespace: neurolearn-prod
type: Opaque
stringData:
  database-url: "postgresql://user:password@postgres-cluster-rw:5432/neurolearn"
  redis-url: "redis://redis-cluster:6379"
  mistral-api-key: "your-mistral-api-key"
  openai-api-key: "your-openai-api-key"
  jwt-secret: "your-jwt-secret"
  encryption-key: "your-encryption-key"
```

### Production Deployment Script

```bash
#!/bin/bash
# deploy-production.sh

set -e

echo "🚀 Deploying NeuroLearn AI to Production..."

# Verify we're on the correct branch
if [[ $(git branch --show-current) != "main" ]]; then
  echo "❌ Must be on main branch for production deployment"
  exit 1
fi

# Verify all tests pass
echo "🧪 Running tests..."
flutter test
cd backend && python -m pytest
cd ..

# Build and tag images
echo "📦 Building production images..."
docker build -t neurolearn-frontend:$(git rev-parse HEAD) .
docker build -t neurolearn-backend:$(git rev-parse HEAD) ./backend

# Push to production registry
echo "📤 Pushing to production registry..."
COMMIT_SHA=$(git rev-parse HEAD)
REGISTRY="your-production-registry.com"

docker tag neurolearn-frontend:$COMMIT_SHA $REGISTRY/neurolearn-frontend:$COMMIT_SHA
docker tag neurolearn-backend:$COMMIT_SHA $REGISTRY/neurolearn-backend:$COMMIT_SHA
docker tag neurolearn-frontend:$COMMIT_SHA $REGISTRY/neurolearn-frontend:latest
docker tag neurolearn-backend:$COMMIT_SHA $REGISTRY/neurolearn-backend:latest

docker push $REGISTRY/neurolearn-frontend:$COMMIT_SHA
docker push $REGISTRY/neurolearn-backend:$COMMIT_SHA
docker push $REGISTRY/neurolearn-frontend:latest
docker push $REGISTRY/neurolearn-backend:latest

# Apply Kubernetes manifests
echo "☸️ Deploying to Kubernetes..."
kubectl apply -f k8s/production/

# Update deployments with new images
kubectl set image deployment/neurolearn-frontend -n neurolearn-prod \
  frontend=$REGISTRY/neurolearn-frontend:$COMMIT_SHA

kubectl set image deployment/neurolearn-backend -n neurolearn-prod \
  backend=$REGISTRY/neurolearn-backend:$COMMIT_SHA

# Wait for rollout
echo "⏳ Waiting for rollout to complete..."
kubectl rollout status deployment/neurolearn-frontend -n neurolearn-prod
kubectl rollout status deployment/neurolearn-backend -n neurolearn-prod

# Run database migrations
echo "📊 Running database migrations..."
kubectl create job --from=cronjob/db-migrate migrate-$(date +%s) -n neurolearn-prod

# Verify deployment
echo "✅ Verifying deployment..."
kubectl get pods -n neurolearn-prod
curl -f https://neurolearn-ai.com/health || {
  echo "❌ Health check failed"
  exit 1
}

echo "🎉 Production deployment successful!"
echo "🌐 Application: https://neurolearn-ai.com"
echo "📊 Monitoring: https://monitoring.neurolearn-ai.com"
```

## Container Orchestration

### Auto-scaling Configuration

```yaml
# k8s/production/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: neurolearn-backend-hpa
  namespace: neurolearn-prod
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: neurolearn-backend
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
      - type: Pods
        value: 4
        periodSeconds: 15
      selectPolicy: Max
```

### Cluster Auto-scaling

```yaml
# k8s/production/cluster-autoscaler.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cluster-autoscaler
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cluster-autoscaler
  template:
    metadata:
      labels:
        app: cluster-autoscaler
    spec:
      containers:
      - image: k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.0
        name: cluster-autoscaler
        resources:
          limits:
            cpu: 100m
            memory: 300Mi
          requests:
            cpu: 100m
            memory: 300Mi
        command:
        - ./cluster-autoscaler
        - --v=4
        - --stderrthreshold=info
        - --cloud-provider=aws
        - --skip-nodes-with-local-storage=false
        - --expander=least-waste
        - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/neurolearn-prod
        - --balance-similar-node-groups
        - --skip-nodes-with-system-pods=false
```

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy NeuroLearn AI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Run tests
      run: flutter test
      
    - name: Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
        
    - name: Install backend dependencies
      run: |
        cd backend
        pip install -r requirements.txt
        
    - name: Run backend tests
      run: |
        cd backend
        python -m pytest

  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    
    - name: Log in to Container Registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
        
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        
    - name: Build and push Frontend image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-frontend:latest,${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-frontend:${{ github.sha }}
        
    - name: Build and push Backend image
      uses: docker/build-push-action@v4
      with:
        context: ./backend
        push: true
        tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-backend:latest,${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-backend:${{ github.sha }}

  deploy-staging:
    needs: [test, build-and-push]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: staging
    steps:
    - uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-west-2
        
    - name: Deploy to staging
      run: |
        # Update ECS service with new image
        aws ecs update-service \
          --cluster neurolearn-staging \
          --service neurolearn-frontend-service \
          --force-new-deployment
          
        aws ecs update-service \
          --cluster neurolearn-staging \
          --service neurolearn-backend-service \
          --force-new-deployment

  deploy-production:
    needs: [test, build-and-push]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'latest'
        
    - name: Configure kubeconfig
      run: |
        echo "${{ secrets.KUBE_CONFIG }}" | base64 -d > kubeconfig
        export KUBECONFIG=kubeconfig
        
    - name: Deploy to production
      run: |
        # Apply Kubernetes manifests
        kubectl apply -f k8s/production/
        
        # Update deployment images
        kubectl set image deployment/neurolearn-frontend -n neurolearn-prod \
          frontend=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-frontend:${{ github.sha }}
          
        kubectl set image deployment/neurolearn-backend -n neurolearn-prod \
          backend=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-backend:${{ github.sha }}
          
        # Wait for rollout
        kubectl rollout status deployment/neurolearn-frontend -n neurolearn-prod
        kubectl rollout status deployment/neurolearn-backend -n neurolearn-prod
```

## Monitoring & Health Checks

### Application Health Endpoints

```dart
// Frontend health check
class HealthCheckHandler {
  static Future<Map<String, dynamic>> getHealthStatus() async {
    final checks = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'healthy',
      'checks': {}
    };
    
    // Check ML Kit availability
    try {
      final faceDetector = GoogleMlKit.vision.faceDetector();
      checks['checks']['ml_kit'] = 'available';
    } catch (e) {
      checks['checks']['ml_kit'] = 'unavailable';
      checks['status'] = 'degraded';
    }
    
    // Check local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('health_check', DateTime.now().toString());
      checks['checks']['local_storage'] = 'available';
    } catch (e) {
      checks['checks']['local_storage'] = 'unavailable';
      checks['status'] = 'degraded';
    }
    
    return checks;
  }
}
```

```python
# Backend health check
from fastapi import FastAPI, status
from fastapi.responses import JSONResponse
import asyncio
import asyncpg
import redis

@app.get("/health")
async def health_check():
    checks = {
        "timestamp": datetime.utcnow().isoformat(),
        "status": "healthy",
        "checks": {}
    }
    
    # Database check
    try:
        conn = await asyncpg.connect(DATABASE_URL)
        await conn.execute("SELECT 1")
        await conn.close()
        checks["checks"]["database"] = "connected"
    except Exception as e:
        checks["checks"]["database"] = f"error: {str(e)}"
        checks["status"] = "unhealthy"
    
    # Redis check
    try:
        r = redis.from_url(REDIS_URL)
        r.ping()
        checks["checks"]["redis"] = "connected"
    except Exception as e:
        checks["checks"]["redis"] = f"error: {str(e)}"
        checks["status"] = "degraded"
    
    # Mistral API check
    try:
        # Test API connectivity
        response = await mistral_client.health_check()
        checks["checks"]["mistral_api"] = "available"
    except Exception as e:
        checks["checks"]["mistral_api"] = f"error: {str(e)}"
        checks["status"] = "degraded"
    
    status_code = 200 if checks["status"] == "healthy" else 503
    return JSONResponse(content=checks, status_code=status_code)
```

### Prometheus Metrics

```yaml
# k8s/production/monitoring.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: neurolearn-metrics
  namespace: neurolearn-prod
spec:
  selector:
    matchLabels:
      app: neurolearn-backend
  endpoints:
  - port: metrics
    interval: 30s
    path: /metrics
---
apiVersion: v1
kind: Service
metadata:
  name: neurolearn-backend-metrics
  namespace: neurolearn-prod
  labels:
    app: neurolearn-backend
spec:
  ports:
  - name: metrics
    port: 9090
    targetPort: 9090
  selector:
    app: neurolearn-backend
```

## Backup & Recovery

### Database Backup Strategy

```bash
#!/bin/bash
# scripts/backup-database.sh

set -e

BACKUP_DIR="/backups/postgres"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="neurolearn_backup_${DATE}.sql"

# Create backup directory
mkdir -p $BACKUP_DIR

# Create database dump
pg_dump $DATABASE_URL > "${BACKUP_DIR}/${BACKUP_FILE}"

# Compress backup
gzip "${BACKUP_DIR}/${BACKUP_FILE}"

# Upload to S3
aws s3 cp "${BACKUP_DIR}/${BACKUP_FILE}.gz" "s3://neurolearn-backups/postgres/"

# Clean up local file
rm "${BACKUP_DIR}/${BACKUP_FILE}.gz"

# Keep only last 7 days of backups locally
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup completed: ${BACKUP_FILE}.gz"
```

### Disaster Recovery Procedure

```bash
#!/bin/bash
# scripts/disaster-recovery.sh

set -e

echo "🚨 Starting disaster recovery procedure..."

# 1. Restore database from latest backup
LATEST_BACKUP=$(aws s3 ls s3://neurolearn-backups/postgres/ | sort | tail -n 1 | awk '{print $4}')
echo "📊 Restoring database from: $LATEST_BACKUP"

# Download and restore backup
aws s3 cp "s3://neurolearn-backups/postgres/$LATEST_BACKUP" ./latest_backup.sql.gz
gunzip latest_backup.sql.gz
psql $DATABASE_URL < latest_backup.sql

# 2. Verify data integrity
echo "🔍 Verifying data integrity..."
psql $DATABASE_URL -c "SELECT COUNT(*) FROM students;"
psql $DATABASE_URL -c "SELECT COUNT(*) FROM emotion_states;"

# 3. Restart services
echo "🔄 Restarting services..."
kubectl rollout restart deployment/neurolearn-backend -n neurolearn-prod
kubectl rollout restart deployment/neurolearn-frontend -n neurolearn-prod

# 4. Wait for services to be ready
kubectl rollout status deployment/neurolearn-backend -n neurolearn-prod
kubectl rollout status deployment/neurolearn-frontend -n neurolearn-prod

# 5. Run health checks
echo "🏥 Running health checks..."
curl -f https://neurolearn-ai.com/health
curl -f https://api.neurolearn-ai.com/health

echo "✅ Disaster recovery completed successfully!"
```

## Scaling Strategies

### Traffic-Based Scaling

```yaml
# k8s/production/keda-scaler.yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: neurolearn-backend-scaler
  namespace: neurolearn-prod
spec:
  scaleTargetRef:
    name: neurolearn-backend
  minReplicaCount: 3
  maxReplicaCount: 50
  triggers:
  - type: prometheus
    metadata:
      serverAddress: http://prometheus:9090
      metricName: http_requests_per_second
      threshold: '100'
      query: sum(rate(http_requests_total{service="neurolearn-backend"}[1m]))
  - type: prometheus
    metadata:
      serverAddress: http://prometheus:9090
      metricName: cpu_usage_percentage
      threshold: '70'
      query: avg(rate(container_cpu_usage_seconds_total{pod=~"neurolearn-backend-.*"}[1m])) * 100
```

### Database Scaling

```yaml
# k8s/production/postgres-read-replicas.yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgres-read-replica
  namespace: neurolearn-prod
spec:
  instances: 2
  
  bootstrap:
    pg_basebackup:
      source: postgres-cluster
      
  externalClusters:
  - name: postgres-cluster
    connectionParameters:
      host: postgres-cluster-rw
      user: postgres
      dbname: neurolearn
    password:
      name: postgres-credentials
      key: password
      
  monitoring:
    enabled: true
    
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "2Gi"
      cpu: "1000m"
```

### Cost Optimization

```yaml
# k8s/production/pod-disruption-budget.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: neurolearn-backend-pdb
  namespace: neurolearn-prod
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: neurolearn-backend
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: neurolearn-frontend-pdb
  namespace: neurolearn-prod
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: neurolearn-frontend
```

---

*This deployment guide is maintained and updated regularly. Last updated: January 15, 2024* 