# 🚀 GHCR Deployment & CI/CD Complete Setup

## 📦 Your Published Docker Image

```
ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

---

## ✅ What's Configured

### CI/CD Pipeline (.github/workflows/ci-cd.yml)
- ✅ **Automatic Trigger**: On every push to `main` branch
- ✅ **Docker Build**: Builds Docker image using Buildx
- ✅ **GHCR Push**: Pushes to GitHub Container Registry
- ✅ **Tagging**: 
  - `latest` - Always points to the most recent build
  - `<commit-sha>` - Specific version by commit
- ✅ **Authentication**: Uses built-in `GITHUB_TOKEN` (no secrets needed!)
- ✅ **Caching**: GitHub Actions cache for faster builds
- ✅ **Deployment**: CD step ready for deployment hooks

### Dockerfile (Production Ready)
- ✅ Node.js 18 Alpine (lightweight)
- ✅ Non-root user (security best practice)
- ✅ Health checks enabled
- ✅ Optimized layer caching
- ✅ Production-only dependencies

### Docker Compose
- ✅ Development & Production ready
- ✅ Auto-restart on failure
- ✅ Health checks configured
- ✅ Network isolation

---

## 🚀 Quick Start Guide

### 1. Pull the Image from GHCR

```bash
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### 2. Run the Container

```bash
# With environment variables
docker run -d \
  -p 3001:3001 \
  -e GEMINI_API_KEY=your_api_key_here \
  --name ai-code-reviewer \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest

# Or with .env file
docker run -d \
  -p 3001:3001 \
  --env-file .env \
  --name ai-code-reviewer \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### 3. Verify Container is Running

```bash
# Check status
docker ps | grep ai-code-reviewer

# View logs
docker logs -f ai-code-reviewer

# Test health
curl http://localhost:3001
```

---

## 🔑 Authentication (If Package is Private)

### Create Personal Access Token (PAT)

1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Click "Generate new token"
3. Select scopes: `read:packages`
4. Copy the token

### Login to GHCR

```bash
echo "YOUR_GITHUB_TOKEN" | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

Example:
```bash
echo "ghp_xxxxxxxxxxxxx" | docker login ghcr.io -u shaharsalan1919-max --password-stdin
```

---

## 📊 Monitor CI/CD Pipeline

### View Workflow Runs

1. Go to your GitHub repository
2. Click "Actions" tab
3. Monitor build progress in real-time

**Direct Link:**
```
https://github.com/shaharsalan1919-max/Gen-assignment/actions
```

### Workflow Output Includes

- Build status ✓/✗
- Docker image layers built
- Image size and tags
- Push confirmation to GHCR

---

## 📦 View Your Published Package

```
https://github.com/shaharsalan1919-max/Gen-assignment/pkgs/container/gen-assignment
```

### Make Package Public (Optional)

1. Navigate to the package URL above
2. Click "Package settings" (gear icon)
3. Scroll to "Danger Zone"
4. Click "Change visibility" → "Public"
5. This allows anyone to pull without authentication

---

## 🔄 Deployment Workflow

### Automatic Deployment Process

```
Your Code → Push to main → GitHub Actions Triggered
    ↓
Docker Build → Image Built
    ↓
Push to GHCR → Image Published
    ↓
CD Step → Ready for Deployment
```

### Manual Workflow Trigger

If you want to rebuild without code changes:

1. Go to "Actions" tab
2. Select "Node.js Docker CI/CD"
3. Click "Run workflow"
4. Select branch (main)
5. Click "Run workflow"

---

## 🐳 Docker Compose Alternative

For local development or server deployment:

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f ai-code-reviewer

# Stop services
docker-compose down

# Rebuild image
docker-compose up -d --build
```

---

## 📋 Available Image Tags

After successful builds, you can use:

```bash
# Latest stable build
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest

# Specific commit
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:abc123def456
```

---

## 🧪 Testing Before Deployment

```bash
# Build locally
docker build -t test-image:latest .

# Run locally
docker run -d -p 3001:3001 --env-file .env --name test test-image:latest

# Test endpoint
curl http://localhost:3001

# Clean up
docker stop test
docker rm test
```

---

## ⚙️ Environment Variables Required

The application requires:

```
GEMINI_API_KEY=your_google_gemini_api_key
NODE_ENV=production (optional, defaults to production in Docker)
PORT=3001 (optional, default 3001)
```

Create `.env` file:

```bash
GEMINI_API_KEY=your_actual_key_here
```

---

## 🔐 Security Best Practices

✅ **Implemented:**
- Non-root user in container
- Health checks for availability
- Environment variables for secrets (not hardcoded)
- Alpine Linux (minimal attack surface)
- npm ci for deterministic installs

✅ **Recommendations:**
- Keep GEMINI_API_KEY in GitHub Secrets for production deployments
- Use private image if containing sensitive code
- Enable Dependabot for dependency updates
- Regularly rebuild images for security patches

---

## 📈 Scaling & Production

### For Production Deployment

```bash
# Pull latest
docker pull ghcr.io/shaharsalan1919-max/gen-assignment:latest

# Run with resource limits
docker run -d \
  -p 3001:3001 \
  --memory="512m" \
  --cpus="1" \
  -e GEMINI_API_KEY=your_key \
  --name ai-code-reviewer \
  --restart=always \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

### Multiple Instances (Load Balancing)

```bash
# Start 3 instances
for i in {1..3}; do
  docker run -d \
    -p "300$i:3001" \
    --env-file .env \
    --name ai-code-reviewer-$i \
    --restart=always \
    ghcr.io/shaharsalan1919-max/gen-assignment:latest
done

# Access via: localhost:3001, localhost:3002, localhost:3003
```

---

## 🆘 Troubleshooting

### Image Won't Build

```bash
# Check Dockerfile syntax
docker build --no-cache -t test:latest .

# Check logs in GitHub Actions
```

### Container Won't Start

```bash
# Check logs
docker logs ai-code-reviewer

# Verify environment
docker run -it --rm ghcr.io/shaharsalan1919-max/gen-assignment:latest env
```

### GEMINI_API_KEY Error

```bash
# Make sure .env file exists and is passed to container
docker run -d \
  --env-file .env \
  --name test \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest

# Or pass directly
docker run -d \
  -e GEMINI_API_KEY=your_key \
  --name test \
  ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

---

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

## ✨ Summary

Your CI/CD pipeline is **fully configured** and ready to use:

1. ✅ Push code to `main` branch
2. ✅ GitHub Actions automatically triggers
3. ✅ Docker image is built and tested
4. ✅ Image is pushed to GHCR with tags
5. ✅ Ready for deployment on any Docker-capable server

**Your GHCR Image URL:**
```
ghcr.io/shaharsalan1919-max/gen-assignment:latest
```

**Repository Package:**
```
https://github.com/shaharsalan1919-max/Gen-assignment/pkgs/container/gen-assignment
```

---

Last Updated: December 10, 2025
