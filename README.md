# 🚀 FastAPI Kubernetes Starter

This is a sample FastAPI project prepared for development, testing, containerization, and deployment to a Kubernetes cluster using modern DevOps tools.

## 🧱 Project Structure

```
.
├── src/                    # Application source code
│   └── main.py
├── tests/                  # Pytest unit tests
├── Dockerfile              # Docker build definition
├── requirements.txt
├── .env                    # Environment variables
├── helm/                   # Helm chart for Kubernetes deployment
├── workflow/               # Argo Workflows YAML files
├── .github/workflows/      # GitHub CI/CD workflows
├── Makefile                # DevOps automation commands
└── README.md
```

## 🚀 Quick Start

### 1. Install dependencies

```bash
make install-dev
```

### 2. Run the application locally

```bash
uvicorn src.main:app --reload
```

### 3. Run tests

```bash
make test
```

### 4. Generate `requirements.txt`

```bash
make pipreqs
```

## Docker

### Build and run

```bash
docker build -t fastapi-app .
docker run -p 8000:8000 --env-file .env fastapi-app
```

## Kubernetes (Minikube)

### Prerequisites

Before you can deploy, make sure the following tools are installed:

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### Deploy with Helm

```bash
helm install fastapi-app helm/ --namespace fastapi --create-namespace
```

Liveness and readiness probes are configured in `values.yaml`.

## CI/CD

- **CI:** GitHub Actions for building, linting, and testing
- **CD:** Argo Workflows + Argo CD for automated deployment to the cluster

## Testing

Tests are written using `pytest` and run with:

```bash
make test
```

## Monitoring

Monitoring is enabled using:

- `kube-prometheus-stack` (Prometheus, Grafana, Alertmanager)
- Access dashboards with:
  ```bash
  minikube service prometheus -n monitoring
  minikube service grafana -n monitoring
  ```

## Pre-commit Hooks

This project uses `pre-commit`. Install with:

```bash
pre-commit install
```

Hooks include:
- Isort
- Helm lint
- Yaml check

## Makefile Commands

| Command             | Description                                   |
|---------------------|-----------------------------------------------|
| `make install-dev`  | Set up virtual environment & install dev deps |
| `make build`        | Build the Docker image                        |
| `make test`         | Run tests                                     |
| `make helm-deploy`  | Deploy the Helm chart to Kubernetes           |
| `make precommit`    | Run all pre-commit hooks locally              |
| `make help`         | List all commands              |


## Accessing ArgoCD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

- Open: https://localhost:8080
- Get the initial password:
  ```bash
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
  ```

