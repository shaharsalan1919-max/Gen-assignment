# Docker & CI/CD Setup Guide

## 🐳 Docker Setup

### Prerequisites
- Docker installed on your machine
- Docker Hub account (for pushing images)

### Build Docker Image Locally
```bash
docker build -t ai-code-reviewer:latest .
```

### Run Docker Container
```bash
# Create .env file first with your GEMINI_API_KEY
docker run -d -p 3001:3001 --env-file .env --name ai-code-reviewer ai-code-reviewer:latest
```

### Using Docker Compose
```bash
# Start the application
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

### Docker Commands Cheat Sheet
```bash
# List running containers
docker ps

# Stop a container
docker stop ai-code-reviewer

# Remove a container
docker rm ai-code-reviewer

# View container logs
docker logs ai-code-reviewer

# Execute commands in container
docker exec -it ai-code-reviewer sh
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows

We have two CI/CD workflows configured:

#### 1. **ci-cd.yml** - Basic Docker Build & Push
- Triggers on push to `main` branch
- Builds Docker image
- Pushes to Docker Hub
- Simple deployment simulation

#### 2. **ci-cd-complete.yml** - Complete CI/CD Pipeline
- **Testing & Linting**: Runs tests and code quality checks
- **Security Scanning**: npm audit and Snyk vulnerability scanning
- **Docker Build**: Multi-platform build (amd64, arm64)
- **Image Scanning**: Trivy security scan
- **Deployment**: Automated deployment (placeholder)

### Required GitHub Secrets

Add these secrets in your GitHub repository:
1. Go to `Settings` → `Secrets and variables` → `Actions`
2. Add the following secrets:

```
DOCKER_USERNAME=your-docker-hub-username
DOCKER_PASSWORD=your-docker-hub-password (or access token)
SNYK_TOKEN=your-snyk-token (optional, for security scanning)
```

### Workflow Triggers

- **Push to main/develop**: Runs full pipeline
- **Pull Request**: Runs tests and quality checks only
- **Manual**: Can be triggered from Actions tab

## 🚀 Deployment Options

### Option 1: Docker Run (Simple)
```bash
docker pull your-username/ai-code-reviewer:latest
docker run -d -p 3001:3001 -e GEMINI_API_KEY=your-key your-username/ai-code-reviewer:latest
```

### Option 2: Docker Compose (Recommended)
```bash
# Clone repository
git clone https://github.com/your-username/your-repo.git
cd your-repo

# Create .env file
echo "GEMINI_API_KEY=your-key" > .env
echo "PORT=3001" >> .env

# Start with docker-compose
docker-compose up -d
```

### Option 3: Cloud Deployment

#### AWS ECS
```bash
# Push image to ECR
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
docker tag ai-code-reviewer:latest aws_account_id.dkr.ecr.region.amazonaws.com/ai-code-reviewer:latest
docker push aws_account_id.dkr.ecr.region.amazonaws.com/ai-code-reviewer:latest
```

#### Azure Container Instances
```bash
az container create \
  --resource-group myResourceGroup \
  --name ai-code-reviewer \
  --image your-username/ai-code-reviewer:latest \
  --ports 3001 \
  --environment-variables GEMINI_API_KEY=your-key
```

#### Google Cloud Run
```bash
gcloud run deploy ai-code-reviewer \
  --image your-username/ai-code-reviewer:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GEMINI_API_KEY=your-key
```

## 🔧 Environment Variables

Required environment variables:
```env
GEMINI_API_KEY=your-google-gemini-api-key
PORT=3001
NODE_ENV=production
```

## 📊 Monitoring & Health Checks

The Docker container includes health checks:
```bash
# Check container health
docker inspect --format='{{json .State.Health}}' ai-code-reviewer

# View health check logs
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' ai-code-reviewer
```

## 🛡️ Security Best Practices

1. **Never commit .env files**: Added to .gitignore and .dockerignore
2. **Use secrets management**: GitHub Secrets, AWS Secrets Manager, etc.
3. **Scan images**: Trivy and Snyk scans in CI/CD
4. **Run as non-root**: Container runs as nodejs user
5. **Multi-stage builds**: Using alpine images for smaller size
6. **Regular updates**: Keep dependencies updated

## 🐛 Troubleshooting

### Container won't start
```bash
# Check logs
docker logs ai-code-reviewer

# Check if port is in use
netstat -ano | findstr :3001  # Windows
lsof -i :3001                 # Linux/Mac
```

### Build fails
```bash
# Clear Docker cache
docker builder prune

# Rebuild without cache
docker build --no-cache -t ai-code-reviewer:latest .
```

### CI/CD Pipeline fails
- Check GitHub Secrets are configured correctly
- Review workflow logs in Actions tab
- Ensure Docker Hub credentials are valid

## 📝 Next Steps

1. ✅ Configure GitHub Secrets
2. ✅ Push code to trigger CI/CD pipeline
3. ✅ Monitor workflow in GitHub Actions
4. ✅ Test deployed Docker image
5. ⚙️ Configure production deployment target
6. 📊 Set up monitoring and logging
7. 🔔 Add Slack/Discord notifications for deployments
