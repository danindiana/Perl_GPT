# Perl_GPT Dockerfile
# Multi-stage build for optimized container size

# Stage 1: Build environment
FROM perl:5.38-slim as builder

LABEL maintainer="danindiana <https://github.com/danindiana>"
LABEL description="Perl_GPT - AI-generated Perl utilities for text processing and data analysis"
LABEL version="1.0.0"

# Set working directory
WORKDIR /build

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libexpat1-dev \
    zlib1g-dev \
    libxml2-dev \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install cpanminus
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Copy dependency files
COPY cpanfile ./

# Install Perl dependencies
RUN cpanm --notest --installdeps .

# Install development and testing dependencies
RUN cpanm --notest \
    Test::More \
    Test::Exception \
    Test::Deep \
    Perl::Critic \
    Perl::Tidy

# Stage 2: Runtime environment
FROM perl:5.38-slim

LABEL maintainer="danindiana <https://github.com/danindiana>"

# Set working directory
WORKDIR /app

# Install runtime system dependencies (minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libexpat1 \
    zlib1g \
    libxml2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy Perl modules from builder
COPY --from=builder /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application files
COPY . /app/

# Create directories for data processing
RUN mkdir -p /app/data/input /app/data/output /app/logs

# Set up environment variables
ENV PERL5LIB=/usr/local/lib/perl5/site_perl:$PERL5LIB
ENV PATH=/app/tools:/app:$PATH

# Make scripts executable
RUN chmod +x /app/tools/*.pl \
    && chmod +x /app/examples/*.pl \
    && chmod +x /app/install.sh \
    && find /app -type d -exec chmod 755 {} \; \
    && find /app -name "*.pl" -type f -exec chmod +x {} \;

# Create non-root user for security
RUN useradd -m -u 1000 -s /bin/bash perlgpt \
    && chown -R perlgpt:perlgpt /app

# Switch to non-root user
USER perlgpt

# Set default command to show help
CMD ["make", "help"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD perl -e 'exit 0'

# Expose volume for data
VOLUME ["/app/data"]

# Documentation
LABEL org.opencontainers.image.title="Perl_GPT"
LABEL org.opencontainers.image.description="AI-generated Perl utilities for text processing, data analysis, and automation"
LABEL org.opencontainers.image.url="https://github.com/danindiana/Perl_GPT"
LABEL org.opencontainers.image.source="https://github.com/danindiana/Perl_GPT"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.authors="danindiana"
