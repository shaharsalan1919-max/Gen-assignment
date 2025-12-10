# --- STAGE 1: Build Stage (Uses a larger image to install dependencies) ---
FROM node:20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker caching
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# --- STAGE 2: Production Stage (Uses a minimal image for the final runtime) ---
FROM node:20-alpine AS final

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
# This includes node_modules and the source code
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# Define the port the container will listen on (adjust if your project uses a different port)
EXPOSE 3000

# The command to run the application when the container starts
# Assumes your main application file is named index.js or server.js and is run via 'npm start'
CMD [ "npm", "start" ]