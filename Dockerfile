# Use official slim Python image
FROM python:3.10-slim

# Avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker layer cache
COPY requirements.txt .

# Upgrade pip
RUN pip install --upgrade pip

# Install Python dependencies (CPU-only torch, no-cache)
RUN pip install --no-cache-dir -r requirements.txt

# Copy all source code
COPY . .

# Expose API port (optional)
EXPOSE 10000

# Start command — replace with your actual entrypoint if needed
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "10000"]
