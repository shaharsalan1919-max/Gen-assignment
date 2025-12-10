#!/bin/bash
# CI/CD Setup Script for GHCR Deployment

set -e

echo "════════════════════════════════════════════════════"
echo "🚀 CI/CD Setup & GHCR Deployment Script"
echo "════════════════════════════════════════════════════"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check prerequisites
check_requirements() {
    echo "${BLUE}📋 Checking prerequisites...${NC}"
    
    if ! command -v git &> /dev/null; then
        echo "${RED}✗ Git is not installed${NC}"
        exit 1
    fi
    echo "${GREEN}✓ Git found${NC}"
    
    if ! command -v docker &> /dev/null; then
        echo "${RED}✗ Docker is not installed${NC}"
        exit 1
    fi
    echo "${GREEN}✓ Docker found${NC}"
    
    echo "${GREEN}✓ All prerequisites met${NC}"
    echo ""
}

# Get GitHub credentials
get_github_info() {
    echo "${BLUE}📝 GitHub Configuration${NC}"
    
    USERNAME=$(git config user.name)
    if [ -z "$USERNAME" ]; then
        read -p "Enter your GitHub username: " GITHUB_USER
    else
        echo "Git user: $USERNAME"
        read -p "Is this your GitHub username? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            GITHUB_USER=$USERNAME
        else
            read -p "Enter your GitHub username: " GITHUB_USER
        fi
    fi
    
    echo ""
}

# Build Docker image
build_image() {
    echo "${BLUE}🐳 Building Docker Image${NC}"
    
    docker build -t ai-code-reviewer:latest .
    
    if [ $? -eq 0 ]; then
        echo "${GREEN}✓ Docker image built successfully${NC}"
    else
        echo "${RED}✗ Docker build failed${NC}"
        exit 1
    fi
    echo ""
}

# Test Docker image
test_image() {
    echo "${BLUE}🧪 Testing Docker Image${NC}"
    
    read -p "Do you want to test the image locally? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f ".env" ]; then
            echo "Running container with .env file..."
            docker run -d -p 3001:3001 --env-file .env --name test-app ai-code-reviewer:latest
        else
            echo "${YELLOW}⚠ No .env file found. Create one with GEMINI_API_KEY${NC}"
            read -p "Enter GEMINI_API_KEY: " API_KEY
            docker run -d -p 3001:3001 -e GEMINI_API_KEY=$API_KEY --name test-app ai-code-reviewer:latest
        fi
        
        echo "Waiting for container to start..."
        sleep 3
        
        if [ "$(docker ps -q -f name=test-app)" ]; then
            echo "${GREEN}✓ Container is running${NC}"
            echo "Testing endpoint: http://localhost:3001"
            
            sleep 2
            if curl -s http://localhost:3001 > /dev/null; then
                echo "${GREEN}✓ Application is responding${NC}"
            else
                echo "${YELLOW}⚠ Application not responding yet${NC}"
            fi
            
            read -p "Stop test container? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                docker stop test-app
                docker rm test-app
                echo "${GREEN}✓ Test container removed${NC}"
            fi
        else
            echo "${RED}✗ Container failed to start${NC}"
            docker logs test-app
        fi
    fi
    echo ""
}

# Setup GitHub Actions
setup_github_actions() {
    echo "${BLUE}🔧 GitHub Actions Configuration${NC}"
    
    echo "✓ CI/CD workflows are already configured in .github/workflows/"
    echo "  - ci-cd.yml (Main workflow)"
    echo "  - ci-cd-enhanced.yml (With security scanning)"
    echo ""
    
    read -p "Do you want to enable the enhanced workflow? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "To use the enhanced workflow:"
        echo "1. Go to .github/workflows/"
        echo "2. Rename or use ci-cd-enhanced.yml"
        echo "3. This includes security scanning and code quality checks"
    fi
    echo ""
}

# Display GHCR URL
display_ghcr_info() {
    echo "${BLUE}📦 Your GitHub Container Registry (GHCR)${NC}"
    
    # Get repo name from git
    REPO=$(basename -s .git $(git config --get remote.origin.url))
    
    GHCR_URL="ghcr.io/$GITHUB_USER/$REPO:latest"
    
    echo "${GREEN}Your Docker Image URL:${NC}"
    echo "${YELLOW}$GHCR_URL${NC}"
    echo ""
    
    echo "📊 Package Location:"
    GITHUB_REPO=$(git config --get remote.origin.url | sed 's/.*github.com\///' | sed 's/.git$//')
    echo "https://github.com/$GITHUB_REPO/pkgs/container/$(basename $REPO)"
    echo ""
    
    echo "🔗 Workflow Status:"
    echo "https://github.com/$GITHUB_REPO/actions"
    echo ""
}

# Create .env template
create_env_template() {
    echo "${BLUE}🔐 Environment Variables${NC}"
    
    if [ ! -f ".env" ]; then
        echo "Creating .env template..."
        cat > .env.example << EOF
# Google Gemini API Key
# Get it from: https://aistudio.google.com/app/apikeys
GEMINI_API_KEY=your_api_key_here

# Node environment
NODE_ENV=production

# Server port
PORT=3001
EOF
        
        echo "${GREEN}✓ Created .env.example (do not commit this)${NC}"
        echo "  Update .env with your actual GEMINI_API_KEY"
    else
        echo "${GREEN}✓ .env file exists${NC}"
    fi
    echo ""
}

# Final instructions
display_instructions() {
    echo "${BLUE}════════════════════════════════════════════════════${NC}"
    echo "${GREEN}✨ Setup Complete!${NC}"
    echo "${BLUE}════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo "📋 Next Steps:"
    echo ""
    echo "1. 📝 Commit Your Changes:"
    echo "   ${YELLOW}git add .${NC}"
    echo "   ${YELLOW}git commit -m \"Add CI/CD and Docker configuration\"${NC}"
    echo "   ${YELLOW}git push origin main${NC}"
    echo ""
    
    echo "2. 🚀 GitHub Actions Will:"
    echo "   - Build your Docker image"
    echo "   - Push to GHCR"
    echo "   - Create the image at: ${YELLOW}$GHCR_URL${NC}"
    echo ""
    
    echo "3. 📊 Monitor Progress:"
    echo "   - Go to GitHub repository → Actions"
    echo "   - Watch the 'Node.js Docker CI/CD' workflow"
    echo ""
    
    echo "4. 🐳 Use Your Image:"
    echo "   ${YELLOW}docker pull $GHCR_URL${NC}"
    echo "   ${YELLOW}docker run -d -p 3001:3001 --env-file .env --name app $GHCR_URL${NC}"
    echo ""
    
    echo "5. 📦 View Your Package:"
    GITHUB_REPO=$(git config --get remote.origin.url | sed 's/.*github.com\///' | sed 's/.git$//')
    REPO=$(basename -s .git $(git config --get remote.origin.url))
    echo "   https://github.com/$GITHUB_REPO/pkgs/container/$(basename $REPO)"
    echo ""
    
    echo "📚 Documentation:"
    echo "   - See: GHCR_DEPLOYMENT_GUIDE.md"
    echo "   - See: CI_CD_DOCUMENTATION.md"
    echo "   - See: DOCKER_CICD_GUIDE.md"
    echo ""
    
    echo "${BLUE}════════════════════════════════════════════════════${NC}"
}

# Main execution
main() {
    check_requirements
    get_github_info
    build_image
    test_image
    create_env_template
    setup_github_actions
    display_ghcr_info
    display_instructions
}

# Run main
main
