# 🚀 Complete CI/CD Pipeline Documentation

## 📋 Overview

Your project has **two CI/CD workflows** configured:

1. **ci-cd.yml** - Main workflow (Simple & Fast)
   - Recommended for production
   - Builds and pushes to GHCR on every push to `main`
   - ~3-5 minutes per build

2. **ci-cd-enhanced.yml** - Enhanced workflow (Comprehensive)
   - Includes security scanning and code quality checks
   - Runs linting, vulnerability scanning, and image analysis
   - ~8-10 minutes per build
   - Optional: Enable by using `.github/workflows/ci-cd-enhanced.yml`

---

## 🔄 Main Workflow (ci-cd.yml)

### Trigger Events
- ✅ Push to `main` branch
- ✅ Manual trigger (workflow_dispatch)

### Pipeline Stages

```
Checkout Code
    ↓
Set up Docker Buildx
    ↓
Login to GHCR
    ↓
Build & Push Image
    ↓
Deployment Ready
```

### Jobs

#### 1️⃣ Build & Push to GHCR
- **Runs on**: ubuntu-latest
- **Steps**:
  - Checkout repository code
  - Set up Docker Buildx (advanced build features)
  - Login to GHCR using GITHUB_TOKEN
  - Build Docker image
  - Push to GHCR with multiple tags

**Output Tags**:
```
ghcr.io/shaharsalan1919-max/gen-assignment:latest
ghcr.io/shaharsalan1919-max/gen-assignment:<commit-sha>
```

#### 2️⃣ Deployment (Placeholder)
- **Runs after**: Build & Push succeeds
- **Purpose**: Ready for deployment hook

---

## 🔐 Enhanced Workflow (ci-cd-enhanced.yml)

### Additional Stages

```
Code Quality Checks
    ↓
Dockerfile Validation
    ↓
Build & Push Image
    ↓
Security Image Scanning
    ↓
Deployment Ready
```

### Jobs

#### 1️⃣ Code Quality Checks
- npm audit (dependency vulnerabilities)
- Snyk security scanning (optional)
- Runs independently

#### 2️⃣ Dockerfile Validation
- Hadolint analysis
- Security best practices check
- Performance optimization suggestions

#### 3️⃣ Build & Push
- Same as main workflow
- Only runs if both checks pass

#### 4️⃣ Image Security Scanning
- Trivy image vulnerability scan
- SARIF format results
- Uploaded to GitHub Security tab
- Only runs on push to main

#### 5️⃣ Deployment
- Detailed summary
- Ready for deployment

---

## 🔑 Environment Variables & Secrets

### Automatic (No Configuration Needed)

```
GITHUB_TOKEN - Built-in GitHub token for GHCR authentication
```

### Optional (For Enhanced Workflow)

```
SNYK_TOKEN - Optional, for Snyk security scanning
```

**How to add secrets**:

1. Go to GitHub repository → Settings
2. Click "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Add name and value
5. Save

---

## 📊 Image Tagging Strategy

### Tags Generated

| Tag | Use Case |
|-----|----------|
| `latest` | Always the newest build from main |
| `<commit-sha>` | Specific version by commit |
| `main` | Latest from main branch (enhanced workflow) |
| `main-<short-sha>` | Branch + short commit (enhanced workflow) |

### Example

After a push, you'd have:
```bash
ghcr.io/shaharsalan1919-max/gen-assignment:latest
ghcr.io/shaharsalan1919-max/gen-assignment:abc123def456
ghcr.io/shaharsalan1919-max/gen-assignment:main-abc123d
```

---

## 📦 GitHub Container Registry (GHCR)

### URL Format

```
ghcr.io/<username>/<repository-name>:<tag>
```

### Your URL

```
ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### Package Location

View your package:
```
https://github.com/shaharsalan1919-max/Gen-assignment/pkgs/container/gen-assignment
```

### Visibility Settings

**Default**: Private (only you can pull)

**To make public**:
1. Go to package settings
2. Click "Change visibility"
3. Select "Public"
4. Anyone can pull without authentication

---

## 🐳 Dockerfile Breakdown

### Image: node:18-alpine
- Lightweight (minimal attack surface)
- ~160MB vs 900MB+ for non-alpine
- Perfect for production containers

### Security Features
```dockerfile
# Non-root user (runs as nodejs, not root)
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

USER nodejs
```

### Health Check
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3001', ...)"
```

### Optimized Build
```dockerfile
# Layer caching: package.json copied first
COPY package*.json ./
RUN npm ci --only=production

# Application code after (changes here don't rebuild node_modules)
COPY . .
```

---

## 🚀 Using the Published Image

### 1. Pull from GHCR

```bash
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### 2. Run Container

```bash
# With environment variables
docker run -d \
  -p 3001:3001 \
  -e GEMINI_API_KEY=your_key \
  --name app \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest

# With .env file
docker run -d \
  -p 3001:3001 \
  --env-file .env \
  --name app \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest

# With resource limits (production)
docker run -d \
  -p 3001:3001 \
  --env-file .env \
  --memory="512m" \
  --cpus="1.5" \
  --restart=always \
  --name app \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### 3. Verify

```bash
# Check running containers
docker ps | grep app

# View logs
docker logs app

# Test endpoint
curl http://localhost:3001

# Check health
docker inspect app --format='{{.State.Health.Status}}'
```

---

## 📊 Monitor Builds

### GitHub Actions Dashboard

1. Go to repository → "Actions" tab
2. See all workflow runs
3. Click on a run to see details
4. View logs for each job

**Direct URL**:
```
https://github.com/shaharsalan1919-max/Gen-assignment/actions
```

### Real-time Monitoring

- Build logs stream live
- Each step shows duration
- Failed steps highlighted in red
- Download artifacts (if any)

---

## 🔄 Workflow Triggers

### Automatic Triggers

```yaml
on:
  push:
    branches: [ main ]  # Trigger on main branch push
  workflow_dispatch:    # Manual trigger button
```

### Manual Trigger

1. Go to GitHub repository → "Actions" tab
2. Select "Node.js Docker CI/CD"
3. Click "Run workflow"
4. Select branch (main)
5. Click "Run workflow"

**Use cases**:
- Rebuild without code changes
- Deploy a specific version
- Test workflow manually

---

## 🔐 Security Best Practices Implemented

✅ **In Dockerfile**:
- Non-root user (nodejs)
- Minimal base image (Alpine)
- npm ci for deterministic installs
- Health checks for availability

✅ **In Workflows**:
- GITHUB_TOKEN (scoped, rotates automatically)
- No hardcoded credentials
- Vulnerability scanning (enhanced workflow)
- Read-only repository permissions

✅ **Recommended**:
- Keep GEMINI_API_KEY in GitHub Secrets
- Enable branch protection rules
- Require status checks before merge
- Regular dependency updates (Dependabot)
- Periodic image rebuilds for OS patches

---

## 🆘 Troubleshooting

### Build Fails - "Docker Build Failed"

**Solution**:
1. Check GitHub Actions logs for error message
2. Run locally: `docker build -t test:latest .`
3. Fix issue
4. Push again to trigger workflow

### Image Won't Start

**Check logs**:
```bash
docker logs app
```

**Common issues**:
- Missing GEMINI_API_KEY env var
- Port 3001 already in use
- Permission denied (non-root user issue)

**Solution**:
```bash
docker run -d \
  --env-file .env \
  -p 3001:3001 \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### Push to GHCR Fails

**Check**:
- GITHUB_TOKEN has `packages: write` permission ✓ (configured)
- Repository is public or you have access to push
- Branch is `main` (triggers workflow)

### Private Image - Authentication Error

**Solution**:
```bash
# Create Personal Access Token with read:packages scope

echo "ghp_YOUR_TOKEN" | docker login ghcr.io \
  -u shaharsalan1919-max \
  --password-stdin

# Now pull
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

---

## 📈 Performance Optimization

### Build Caching

The workflow uses GitHub Actions cache:
```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

**Benefits**:
- 2-3x faster builds after first build
- Caches all Docker layers
- Automatic cleanup after 7 days

### Layer Optimization in Dockerfile

```dockerfile
# Layer 1: Base image (cacheable)
FROM node:18-alpine

# Layer 2: Dependencies (caches if package.json unchanged)
COPY package*.json ./
RUN npm ci --only=production

# Layer 3: Code (rebuilds if code changes)
COPY . .
```

**Result**: Small code changes don't rebuild node_modules

---

## 🔄 Continuous Deployment (CD)

### Ready for Deployment Platforms

Your image is compatible with:

- **Docker**: Any Docker-capable server
- **Kubernetes**: Deploy as pod
- **AWS ECS**: Push to ECR first, or use GitHub Actions
- **Azure Container Instances**
- **Google Cloud Run**
- **DigitalOcean App Platform**
- **Heroku Container Registry** (free tier ended)

### Example: Deploy to Production

```bash
# On your server:
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest
docker stop app || true
docker rm app || true
docker run -d \
  -p 3001:3001 \
  --env-file /path/to/.env \
  --restart=always \
  --name app \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

---

## 📚 Files Reference

| File | Purpose |
|------|---------|
| `.github/workflows/ci-cd.yml` | Main production workflow |
| `.github/workflows/ci-cd-enhanced.yml` | Enhanced with security checks |
| `Dockerfile` | Container image definition |
| `docker-compose.yml` | Multi-container orchestration |
| `package.json` | Node.js dependencies |
| `.env` | Environment variables (not in repo) |

---

## ✨ Quick Reference

### Build Status
```
https://github.com/shaharsalan1919-max/Gen-assignment/actions
```

### Image Package
```
https://github.com/shaharsalan1919-max/Gen-assignment/pkgs/container/gen-assignment
```

### Pull Command
```bash
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### Run Command
```bash
docker run -d -p 3001:3001 --env-file .env ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

---

**Last Updated**: December 10, 2025

For more information, see:
- `GHCR_DEPLOYMENT_GUIDE.md` - Deployment instructions
- `DOCKER_CICD_GUIDE.md` - Docker setup guide
- `IMPLEMENTATION_SUMMARY.md` - Project overview
