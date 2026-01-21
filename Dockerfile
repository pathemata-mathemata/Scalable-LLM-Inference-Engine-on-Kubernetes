FROM python:3.10-slim

RUN apt-get update && apt-get install -y     gcc     g++     make     && rm -rf /var/lib/apt/lists/*

RUN pip install "llama-cpp-python[server]"

WORKDIR /app
EXPOSE 8000
CMD ["python3", "-m", "llama_cpp.server", "--model", "/app/models/model.gguf", "--host", "0.0.0.0", "--port", "8000"]
