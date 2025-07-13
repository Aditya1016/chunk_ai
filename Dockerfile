# -------- Stage 1: Builder --------
FROM python:3.10-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Pre-download model into /app/models
RUN python -c "\
from sentence_transformers import SentenceTransformer; \
SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2', cache_folder='/app/models')"

# -------- Stage 2: Slim runtime --------
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Copy installed Python packages from builder
COPY --from=builder /usr/local /usr/local

# Copy model and app source code
COPY --from=builder /app/models /app/models
COPY . .

# Expose API port
EXPOSE 10000

# Start FastAPI app
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "10000"]
