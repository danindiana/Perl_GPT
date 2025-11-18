# Docker Deployment Guide

Complete guide for running Perl_GPT in Docker containers.

## Table of Contents

- [Quick Start](#quick-start)
- [Building Images](#building-images)
- [Running Containers](#running-containers)
- [Docker Compose](#docker-compose)
- [Volume Management](#volume-management)
- [Environment Variables](#environment-variables)
- [Common Use Cases](#common-use-cases)
- [Troubleshooting](#troubleshooting)

## Quick Start

### Prerequisites

- Docker 20.10+
- Docker Compose 2.0+ (optional but recommended)
- At least 2GB free disk space

### Fastest Way to Get Started

```bash
# 1. Build the image
docker-compose build

# 2. Start the container
docker-compose up -d perlgpt

# 3. Run a utility
docker-compose exec perlgpt perl tools/file_scanner.pl

# 4. View logs
docker-compose logs -f perlgpt
```

## Building Images

### Build Production Image

```bash
# Build with default settings
docker build -t perlgpt:latest .

# Build with custom tags
docker build -t perlgpt:1.0.0 -t perlgpt:latest .

# Build with build arguments
docker build --build-arg PERL_VERSION=5.38 -t perlgpt:latest .
```

### Build Development Image

```bash
# Build the development image (includes extra tools)
docker build --target builder -t perlgpt:dev .

# Or use docker-compose
docker-compose build perlgpt-dev
```

### Multi-Architecture Build

```bash
# Build for multiple platforms
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t perlgpt:latest \
    .
```

## Running Containers

### Basic Container Usage

```bash
# Run interactively
docker run -it --rm perlgpt:latest /bin/bash

# Run specific command
docker run --rm perlgpt:latest perl tools/file_scanner.pl

# Run with volume mount
docker run --rm \
    -v $(pwd)/data:/app/data \
    perlgpt:latest \
    perl entropy_cleaner/clean_by_entropy.pl
```

### Container with Persistent Data

```bash
# Create named volumes
docker volume create perlgpt-data
docker volume create perlgpt-logs

# Run with volumes
docker run -d \
    --name perlgpt-main \
    -v perlgpt-data:/app/data \
    -v perlgpt-logs:/app/logs \
    perlgpt:latest
```

### Development Container

```bash
# Run development container with source mounted
docker run -it --rm \
    -v $(pwd):/app \
    -v $(pwd)/data:/app/data \
    perlgpt:dev \
    /bin/bash
```

## Docker Compose

### Available Services

The `docker-compose.yml` defines several services:

1. **perlgpt** - Main production service
2. **perlgpt-dev** - Development environment
3. **perlgpt-worker** - Batch processing worker
4. **perlgpt-test** - Testing environment

### Basic Commands

```bash
# Start main service
docker-compose up -d perlgpt

# Start development environment
docker-compose up -d perlgpt-dev

# Run tests
docker-compose --profile test run perlgpt-test

# Run worker for batch processing
docker-compose --profile worker up perlgpt-worker

# View logs
docker-compose logs -f perlgpt

# Stop all services
docker-compose down

# Remove volumes (WARNING: deletes data)
docker-compose down -v
```

### Executing Commands

```bash
# Execute command in running container
docker-compose exec perlgpt perl tools/file_scanner.pl

# Run one-off command
docker-compose run --rm perlgpt perl examples/entropy_analysis.pl

# Access shell
docker-compose exec perlgpt /bin/bash

# Run as root (for debugging)
docker-compose exec -u root perlgpt /bin/bash
```

## Volume Management

### Data Directories

The container uses these directories:

- `/app/data` - Input/output data
- `/app/logs` - Log files
- `/app` - Application code (read-only in production)

### Creating Volumes

```bash
# Create volumes before first run
docker volume create perlgpt-data
docker volume create perlgpt-logs

# Inspect volumes
docker volume inspect perlgpt-data

# List all volumes
docker volume ls | grep perlgpt
```

### Backing Up Data

```bash
# Backup data volume
docker run --rm \
    -v perlgpt-data:/data \
    -v $(pwd)/backups:/backup \
    alpine \
    tar czf /backup/data-$(date +%Y%m%d).tar.gz -C /data .

# Restore data volume
docker run --rm \
    -v perlgpt-data:/data \
    -v $(pwd)/backups:/backup \
    alpine \
    tar xzf /backup/data-YYYYMMDD.tar.gz -C /data
```

## Environment Variables

### Available Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PERL_ENV` | `production` | Environment: production/development/test |
| `TZ` | `UTC` | Timezone setting |
| `WORKER_ID` | - | Worker identifier for batch processing |

### Setting Environment Variables

```bash
# Via docker run
docker run -e PERL_ENV=development perlgpt:latest

# Via docker-compose
# Edit docker-compose.yml environment section

# Via .env file
echo "PERL_ENV=production" > .env
docker-compose up -d
```

## Common Use Cases

### 1. File Scanning

```bash
# Interactive file scanning
docker-compose run --rm perlgpt perl tools/file_scanner.pl

# With mounted directory
docker run --rm \
    -v /path/to/search:/app/data/input \
    perlgpt:latest \
    perl tools/file_scanner.pl
```

### 2. Entropy Analysis

```bash
# Analyze files in data directory
docker-compose exec perlgpt perl entropy_cleaner/clean_by_entropy.pl

# Run example
docker-compose exec perlgpt perl examples/entropy_analysis.pl
```

### 3. JSONL Conversion

```bash
# Convert text files to JSONL
docker run --rm \
    -v $(pwd)/input:/app/data/input \
    -v $(pwd)/output:/app/data/output \
    perlgpt:latest \
    perl jsonl_convertor/txt_jsonl_convert.pl
```

### 4. Academic Metadata Extraction

```bash
# Extract arXiv/DOI metadata
docker-compose exec perlgpt perl arxiv_doi_grabber/metadata_extractor.pl
```

### 5. Running Tests

```bash
# Run full test suite
docker-compose --profile test run --rm perlgpt-test

# Run specific tests
docker-compose run --rm perlgpt make test

# Run with coverage
docker-compose run --rm perlgpt make coverage
```

### 6. Development Workflow

```bash
# Start development container
docker-compose up -d perlgpt-dev

# Access shell
docker-compose exec perlgpt-dev /bin/bash

# Make changes locally (auto-mounted)
# Test changes
docker-compose exec perlgpt-dev make test

# Run Perl::Critic
docker-compose exec perlgpt-dev make critic
```

## Image Management

### Viewing Images

```bash
# List Perl_GPT images
docker images | grep perlgpt

# Check image size
docker images perlgpt:latest --format "{{.Size}}"

# Inspect image
docker inspect perlgpt:latest
```

### Cleaning Up

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove everything (CAUTION!)
docker system prune -a

# Remove specific image
docker rmi perlgpt:latest
```

## Performance Tuning

### Resource Limits

```bash
# Limit CPU and memory
docker run \
    --cpus="1.5" \
    --memory="1g" \
    --memory-swap="2g" \
    perlgpt:latest

# Check resource usage
docker stats perlgpt-main
```

### Build Cache

```bash
# Build without cache
docker build --no-cache -t perlgpt:latest .

# Clean build cache
docker builder prune
```

## Troubleshooting

### Common Issues

#### Container Won't Start

```bash
# Check logs
docker-compose logs perlgpt

# Inspect container
docker inspect perlgpt-main

# Check if ports are in use
docker ps -a
```

#### Permission Issues

```bash
# Run as root to fix permissions
docker-compose exec -u root perlgpt chown -R perlgpt:perlgpt /app/data

# Check user
docker-compose exec perlgpt whoami
```

#### Dependency Issues

```bash
# Rebuild image with no cache
docker-compose build --no-cache perlgpt

# Check installed modules
docker-compose exec perlgpt perl -V
```

#### Volume Not Mounting

```bash
# Check volume exists
docker volume ls

# Inspect volume
docker volume inspect perlgpt-data

# Check mount points
docker inspect perlgpt-main | grep -A 10 Mounts
```

### Debug Mode

```bash
# Run with debug output
docker run -it --rm perlgpt:latest perl -d:Trace script.pl

# Enable verbose logging
docker-compose exec perlgpt perl -w tools/file_scanner.pl

# Shell into running container
docker-compose exec perlgpt /bin/bash
```

### Health Checks

```bash
# Check container health
docker inspect perlgpt-main --format='{{.State.Health.Status}}'

# View health check logs
docker inspect perlgpt-main --format='{{json .State.Health}}' | jq
```

## Best Practices

### Security

1. **Run as non-root** (already configured)
2. **Use read-only volumes** for application code
3. **Scan images** for vulnerabilities:
   ```bash
   docker scan perlgpt:latest
   ```
4. **Keep base images updated**:
   ```bash
   docker pull perl:5.38-slim
   docker-compose build --pull
   ```

### Data Management

1. **Use named volumes** for persistence
2. **Regular backups** of data volumes
3. **Separate data** from application code
4. **Mount specific directories** instead of entire filesystem

### Development

1. **Use dev image** for development
2. **Mount source code** as volume
3. **Rebuild on dependency changes**
4. **Run tests** before committing

### Production

1. **Use specific tags** (not `latest`)
2. **Set resource limits**
3. **Configure restart policies**
4. **Monitor resource usage**
5. **Implement logging strategy**

## CI/CD Integration

### GitHub Actions Example

```yaml
- name: Build Docker image
  run: docker build -t perlgpt:${{ github.sha }} .

- name: Run tests in container
  run: docker run --rm perlgpt:${{ github.sha }} make test

- name: Push to registry
  run: |
    docker tag perlgpt:${{ github.sha }} username/perlgpt:latest
    docker push username/perlgpt:latest
```

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Main README](../README.md)

---

**Last Updated**: November 2025
**Repository**: [Perl_GPT](https://github.com/danindiana/Perl_GPT)
