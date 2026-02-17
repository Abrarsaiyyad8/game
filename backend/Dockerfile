# Use official Node image
FROM node:20-alpine

# Set working directory inside container
WORKDIR /backend

# Copy package.json first (for caching)
COPY package.json .

# Install dependencies
RUN npm install

# Copy remaining files
COPY . .

# Expose backend port
EXPOSE 3000

# Start server
CMD ["npm", "start"]
