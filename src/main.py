import os

from dotenv import load_dotenv
from fastapi import FastAPI

# Load variables from .env file
load_dotenv()

# Read variables from environment
app_host = os.getenv("APP_HOST", "127.0.0.1")
app_port = int(os.getenv("APP_PORT", 8000))
debug = os.getenv("DEBUG", "False").lower() == "true"
project_name = os.getenv("PROJECT_NAME", "MyApp")

# Initialize FastAPI app
app = FastAPI(title=project_name)


@app.get("/")
def greet():
    return {"message": f"Hello from {project_name} 👋", "debug_mode": debug}


@app.get("/health")
def health_check():
    return {"status": "ok"}
