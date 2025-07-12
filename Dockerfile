# Use official slim Python image
FROM python:3.10-slim

# Avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install torch CPU-only manually to avoid 800MB+ GPU builds
RUN pip install torch==1.13.1+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html --no-cache-dir

# Copy only requirements.txt first to leverage Docker layer caching
COPY requirements.txt .

# Install Python dependencies with no cache
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of the code
COPY . .

# Expose API port
EXPOSE 10000

# Start the FastAPI app
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "10000"]
