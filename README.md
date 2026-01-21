# Scalable LLM Inference Engine on Kubernetes

Containerized, Kubernetes-based serving for a quantized LLM

## Overview
This project demonstrates serving Meta-Llama-3-8B (quantized GGUF) using:
- Kubernetes (Minikube) for orchestration
- Docker for containerization
- llama-cpp-python for inference and OpenAI-compatible endpoints
- A persistent volume mount for model artifacts

## Architecture
- Orchestration: Kubernetes (Minikube)
- Containerization: Docker
- Inference server: llama-cpp-python (OpenAI-compatible)
- Model: Meta-Llama-3-8B-Instruct (4-bit quantized GGUF)

## Prerequisites
- Docker
- Minikube + kubectl
- curl

## Quick Start

### 1) Clone and prepare the model directory
```bash
git clone https://github.com/pathemata-mathemata/Scalable-LLM-Inference-Engine-on-Kubernetes.git
cd Scalable-LLM-Inference-Engine-on-Kubernetes
mkdir -p models
```

### 2) Download a quantized GGUF model
```bash
curl -L -o models/model.gguf \
  "https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-GGUF.Q4_K_M.gguf?download=true"
```

### 3) Build the image in Minikube
```bash
minikube start
eval "$(minikube docker-env)"
docker build -t my-llama-server:v1 .
```

### 4) Mount the model directory into Minikube
This command will keep running. Open a new terminal for the next steps.
```bash
minikube mount "$(pwd)/models:/data/models"
```

### 5) Deploy to Kubernetes
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get pods --watch
```

### 6) Get the service URL and test inference
```bash
minikube service llama-service --url
```

Replace the URL in the request below with the one returned by Minikube.
```bash
curl -X POST http://127.0.0.1:12345/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      { "role": "system", "content": "You are a helpful AI infrastructure assistant." },
      { "role": "user", "content": "Explain the benefit of Kubernetes for ML models." }
    ]
  }'
```

## Notes
- The `minikube mount` command must remain running to keep the model volume available.
- If you change the model file name, update the path expected by the server in the image or manifests.

## Troubleshooting
- Pod stuck in `ImagePullBackOff`: rebuild the image in Minikube and ensure `eval "$(minikube docker-env)"` is active.
- Pod stuck in `CrashLoopBackOff`: check container logs with `kubectl logs deployment/llama-deployment`.
- Service not reachable: confirm the LoadBalancer URL from `minikube service llama-service --url`.
