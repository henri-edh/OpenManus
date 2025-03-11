# Use Python 3.12 as base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for Playwright
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy project files
COPY . .

# Install Python dependencies using UV
RUN /root/.cargo/bin/uv pip install --prerelease=allow -r requirements.txt

# Install Playwright browsers
RUN playwright install --with-deps chromium

# Create config directory and copy example config
RUN mkdir -p /app/config
COPY config/config.example.toml /app/config/config.toml

# Create workspace directory
RUN mkdir -p /app/workspace

# Expose port if needed (adjust according to your needs)
EXPOSE 8000

# Command to run the application
CMD ["python", "main.py"]