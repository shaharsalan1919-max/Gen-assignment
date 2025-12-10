# 📦 GitHub Container Registry (GHCR) Setup

## Your Docker Image URL

```
ghcr.io/muhammadtalha003/generative-ai-assignment:latest
```

## 🚀 Quick Commands

### Pull the Image
```bash
docker pull ghcr.io/muhammadtalha003/generative-ai-assignment:latest
```

### Run the Container
```bash
docker run -d -p 3001:3001 \
  -e GEMINI_API_KEY=your_api_key_here \
  --name ai-code-reviewer \
  ghcr.io/muhammadtalha003/generative-ai-assignment:latest
```

### With .env file
```bash
docker run -d -p 3001:3001 \
  --env-file .env \
  --name ai-code-reviewer \
  ghcr.io/muhammadtalha003/generative-ai-assignment:latest
```

## 📝 How It Works

### Automatic Publishing
- When you push to `main` branch, GitHub Actions automatically:
  1. Builds the Docker image
  2. Pushes to GitHub Container Registry (GHCR)
  3. Tags with `latest` and commit SHA

### No Additional Secrets Needed!
- GHCR uses the built-in `GITHUB_TOKEN`
- No need to configure Docker Hub credentials
- Automatic authentication in GitHub Actions

## 🔍 View Your Package

Visit your package at:
```
https://github.com/Muhammadtalha003/Generative-AI-assignment/pkgs/container/generative-ai-assignment
```

## 🔓 Making Package Public

By default, packages are private. To make it public:

1. Go to your GitHub repository
2. Click on "Packages" in the right sidebar
3. Click on your package name
4. Click "Package settings"
5. Scroll down to "Danger Zone"
6. Click "Change visibility" → "Public"

## 🐳 Available Tags

After the workflow runs, you'll have:
- `latest` - Latest build from main branch
- `main-<commit-sha>` - Specific commit version
- `<full-commit-sha>` - Full SHA tag

## 📊 CI/CD Workflow Status

Check the workflow status:
```
https://github.com/Muhammadtalha003/Generative-AI-assignment/actions
```

## 🔐 Authentication for Pulling Private Images

If your package is private, authenticate first:

```bash
# Create a Personal Access Token (PAT) with read:packages scope
# Then login:
echo $GHCR_TOKEN | docker login ghcr.io -u muhammadtalha003 --password-stdin

# Now you can pull
docker pull ghcr.io/muhammadtalha003/generative-ai-assignment:latest
```

## ✅ Verification

After the workflow completes, verify:

```bash
# Pull the image
docker pull ghcr.io/muhammadtalha003/generative-ai-assignment:latest

# Inspect the image
docker inspect ghcr.io/muhammadtalha003/generative-ai-assignment:latest

# Run and test
docker run -d -p 3001:3001 --env-file .env ghcr.io/muhammadtalha003/generative-ai-assignment:latest

# Test the API
curl -X POST http://localhost:3001/review \
  -H "Content-Type: application/json" \
  -d '{"code":"function test() { return true; }"}'
```

## 📋 Submission URL Format

For your assignment submission:
```
ghcr.io/muhammadtalha003/generative-ai-assignment:latest
```

## 🎯 Next Steps

1. ✅ Commit and push changes to trigger workflow
2. ✅ Wait for GitHub Actions to complete
3. ✅ Check Actions tab for workflow status
4. ✅ View package in GitHub Packages
5. ✅ Make package public (optional)
6. ✅ Test pulling and running the image
7. ✅ Submit the GHCR URL

---

**Repository**: https://github.com/Muhammadtalha003/Generative-AI-assignment
**GHCR URL**: ghcr.io/muhammadtalha003/generative-ai-assignment:latest
