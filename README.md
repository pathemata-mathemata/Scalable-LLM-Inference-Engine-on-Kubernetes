cat <<'EOF' > README.md
# Scalable LLM Inference Engine on Kubernetes

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

A cloud-native infrastructure project for deploying, orchestrating, and serving quantized Large Language Models (LLMs) in a production-like environment.

## 🚀 Project Overview
This project demonstrates a containerized solution for serving **Meta-Llama-3-8B** using **Kubernetes** for orchestration and **Docker** for containerization. It solves the challenge of hosting large model artifacts by leveraging persistent volume claims and exposing an OpenAI-compatible REST API via a LoadBalancer service.

## ⚙️ Quick Start

### 1. Setup & Download Model
```bash
# Clone the repo
git clone [https://github.com/pathemata-mathemata/Scalable-LLM-Inference-Engine-on-Kubernetes.git](https://github.com/pathemata-mathemata/Scalable-LLM-Inference-Engine-on-Kubernetes.git)
cd Scalable-LLM-Inference-Engine-on-Kubernetes
mkdir models

# Download Llama-3-8B-Quantized (approx 5.7GB)
curl -L -o models/model.gguf "[https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-GGUF.Q4_K_M.gguf?download=true](https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-GGUF.Q4_K_M.gguf?download=true)"

# --- Step 1: Build the Image inside Minikube ---
minikube start
eval $(minikube docker-env)
docker build -t my-llama-server:v1 .

# --- Step 2: Start the Persistent Volume Bridge ---
# IMPORTANT: This command will HANG. You must open a new terminal after running this!
echo "Starting mount... Please open a new terminal for the next steps."
minikube mount $(pwd)/models:/data/models

# Apply the Kubernetes manifests
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Watch the pod status until it says 'Running'
kubectl get pods --watch

# Get the service URL
minikube service llama-service --url

# Run a test inference (Replace URL with yours)
curl -X POST [http://127.0.0.1:12345/v1/chat/completions](http://127.0.0.1:12345/v1/chat/completions) \
-H "Content-Type: application/json" \
-d '{
  "messages": [
    { "role": "system", "content": "You are a helpful AI infrastructure assistant." },
    { "role": "user", "content": "Explain the benefit of Kubernetes for ML models." }
  ]
}'

🛠️ Architecture
Orchestration: Kubernetes (Minikube)

Containerization: Docker

Inference Engine: llama-cpp-python (OpenAI compatible server)

Model: Meta-Llama-3-8B-Instruct (4-bit Quantized GGUF)