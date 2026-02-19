# Use lightweight Node image (MUCH smaller)
FROM node:20-alpine

# Create app directory
WORKDIR /backend

# Copy only dependency files first (better caching)
COPY package.json package-lock.json* ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy remaining source code
COPY . .

# Expose backend port
EXPOSE 3000

# Start application
CMD ["node", "server.js"]
