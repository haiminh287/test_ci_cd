# Stage 1: Build app
FROM python:3.10-slim AS builder

WORKDIR /app

COPY requirements.txt .

# Install to /root/.local/lib/...(thư viện) + /root/.local/bin(CLI tools)
RUN pip install --user --no-cache-dir -r requirements.txt 

# Stage 2: Run app
FROM python:3.10-slim
WORKDIR /app

COPY --from=builder /root/.local /root/.local
# COPY <source ( Currently the directory on the server (your device) )> <destination (Inside the current folder of Image - WORKDIR)>

COPY . .
# declare the port that the app will run on
EXPOSE 5000
CMD ["python", "main.py"]


