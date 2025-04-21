# Virtual environment settings
VENV_NAME=venv
PYTHON=$(VENV_NAME)/bin/python
PIP=$(VENV_NAME)/bin/pip
UVICORN=$(VENV_NAME)/bin/uvicorn
PIPREQS=$(VENV_NAME)/bin/pipreqs

# App and chart configuration
APP_NAME=fastapi-app
CHART_DIR=helm/fastapi-app
NAMESPACE=default
RELEASE_NAME=$(APP_NAME)
POD_NAME=$(shell kubectl get pods -n $(NAMESPACE) -l app=$(APP_NAME) -o jsonpath="{.items[0].metadata.name}")


# 🧱 Create a virtual environment
venv:
	python -m venv $(VENV_NAME)
	@echo "✅ Virtual environment created."

# 📦 Install dependencies from requirements.txt
install:
	$(PIP) install -r requirements.txt
	@echo "✅ Dependencies installed."

# ➕ Add a new package (usage: make add PACKAGE=requests)
add:
	$(PIP) install $(PACKAGE)
	$(PIP) freeze > requirements.txt
	@echo "✅ Package '$(PACKAGE)' added and requirements.txt updated."

# 🔄 Generate requirements.txt from current environment
freeze:
	$(PIP) freeze > requirements.txt
	@echo "✅ requirements.txt generated."

# 🧽 Generate minimal requirements.txt using pipreqs
pipreqs:
	$(PIPREQS) . --force
	@echo "✅ Minimal requirements.txt generated using pipreqs."

# 🚀 Run FastAPI app with uvicorn (development mode)
run:
	$(UVICORN) main:app --reload
	@echo "🚀 FastAPI is running at http://localhost:8000"

# 🧹 Clean project (remove venv and __pycache__)
clean:
	rm -rf $(VENV_NAME) __pycache__ .pytest_cache
	find . -type d -name "__pycache__" -exec rm -r {} +
	@echo "🧹 Project cleaned."

# Test python code with pytest
test:
	@echo "🧪 Running tests..."
	PYTHONPATH=src $(VENV_NAME)/bin/pytest tests -v --disable-warnings
	@echo "✅ Tests completed."

# Build Docker image for local Minikube
docker-build:
	eval "$$(minikube docker-env)" && docker build -t $(APP_NAME):latest .
	@echo "✅ Docker image built."

# Run Docker container
docker:
	docker run -d -p 8000:8000 $(APP_NAME):latest
	@echo "🚀 Docker container running at http://localhost:8000"

# Install Helm chart (initial deployment)
helm-install:
	helm install $(RELEASE_NAME) $(CHART_DIR) --namespace $(NAMESPACE)

# Upgrade Helm release (for changes in code or config)
helm-upgrade:
	helm upgrade $(RELEASE_NAME) $(CHART_DIR) --namespace $(NAMESPACE)

# Uninstall Helm release
helm-uninstall:
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

# Show logs from the running pod
logs:
	kubectl logs $(POD_NAME) --namespace $(NAMESPACE)

# Get current pod name
get-pod:
	kubectl get pods -n $(NAMESPACE) -l app=$(APP_NAME)

# Describe current pod (debugging)
describe-pod:
	kubectl describe pod $(POD_NAME) --namespace $(NAMESPACE)

# Get service info
get-service:
	kubectl get svc -n $(NAMESPACE)

# Open in browser using Minikube
open:
	minikube service $(APP_NAME)-service --namespace $(NAMESPACE)


# 🆘 Show available commands
help:
	@echo "🛠️ Available make commands:"
	@echo "  make venv          - Create virtual environment"
	@echo "  make install       - Install dependencies from requirements.txt"
	@echo "  make add PACKAGE=x - Install package x and update requirements.txt"
	@echo "  make freeze        - Generate requirements.txt using pip freeze"
	@echo "  make pipreqs       - Generate minimal requirements.txt using pipreqs"
	@echo "  make run           - Run FastAPI app (uvicorn with reload)"
	@echo "  make clean         - Remove virtualenv and __pycache__ folders"
	@echo "  make help          - Show this help message"
	@echo "  make test          - Run tests with pytest"
	@echo "  make docker        - Build and run Docker container"
	@echo "  make docker-build  - Build Docker image"
	@echo "  make helm-install  - Install Helm chart"
	@echo "  make helm-upgrade  - Upgrade Helm release"
	@echo "  make helm-uninstall- Uninstall Helm release"
	@echo "  make logs          - Show logs from the running pod"
	@echo "  make get-pod       - Get current pod name"
	@echo "  make describe-pod  - Describe current pod (debugging)"
	@echo "  make get-service   - Get service info"
	@echo "  make open          - Open service in browser using Minikube"