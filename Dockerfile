# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

## Dependencies installation
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile

## Copy source code and configuration files
COPY . .

## Build TypeScript project
RUN pnpm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

## Production only dependencies installation
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile --prod

# Copy compiled files from build stage
COPY --from=builder /app/build ./build

# Expose port (default 8080)
EXPOSE 8080

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080

# Run as non-root user
USER node
CMD ["node", "build/server.js"]
