
FROM python:3.11-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Install build dependencies required to compile pyswisseph and Python wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev \
    pkg-config \
    ca-certificates \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN python -m pip install --upgrade pip setuptools wheel && \
    python -m pip install --no-cache-dir -r requirements.txt

# Copy the app (use COPY . . if you want full context)
COPY app.py ./

EXPOSE 7777

CMD ["python", "app.py"]

