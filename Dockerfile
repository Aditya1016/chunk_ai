# Use official Python image
FROM python:3.10-slim

# Avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install torch (CPU only)
RUN pip install --upgrade pip
RUN pip install torch==1.13.1+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html

# Copy code
COPY . .

# Install Python deps
RUN pip install -r requirements.txt

# Expose port
EXPOSE 10000

# Run the app
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "10000"]
