# --- Stage 1: Builder Stage ---
# Use a specific version of Node.js for consistency
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first to leverage Docker caching for dependencies
COPY package*.json ./

# Install dependencies, prioritizing production dependencies if applicable
RUN npm install

# Copy all source code
COPY . .

# Run the build command (e.g., if using React/Vue/TypeScript)
# If your project is a pure backend server, you might skip this line or use 'npm run build'
# RUN npm run build 


# --- Stage 2: Production Stage (Final, Lightweight Image) ---
FROM node:20-alpine AS production

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
# This includes node_modules and the application code
COPY --from=builder /app/node_modules ./node_modules
# Copy only the compiled code/final files if you used 'npm run build' above
COPY --from=builder /app ./

# If you need to copy specific output folders (e.g., a 'dist' folder for compiled assets), 
# replace the line above with specific COPY commands.

# Expose the port your Node.js application runs on (e.g., 3000, 8080)
EXPOSE 3000 

# Define the command to start the application (adjust 'server.js' to your entry point)
CMD ["node", "index.js"]