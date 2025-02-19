**This project contains the necessary files to deploy a Flask application on Google Cloud Platform (GCP) using Terraform and a CI/CD pipeline.**
GCP Deployment


Project Structure

.
├── Dockerfile          # Defines the containerized Flask application
├── buildspec.yml       # Build and deployment instructions for CI/CD
├── flask-app.py        # Flask application source code
├── main.tf             # Terraform configuration for deploying GCP infrastructure
├── requirements.txt    # Dependencies for the Flask application
└── README.md           # Project documentation

Prerequisites

Ensure you have the following installed:

Google Cloud SDK

Terraform

Docker

Git

Deployment Steps

**1. Clone the Repository**

git clone <repository_url>
cd <repository_name>

**2. Build and Push Docker Image to Google Container Registry (GCR)**

gcloud auth configure-docker

docker build -t gcr.io/<your-project-id>/flask-app .
docker push gcr.io/<your-project-id>/flask-app

**3. Deploy Infrastructure using Terraform**

terraform init
terraform apply -auto-approve

**4. Verify Deployment**

Once deployed, you can verify the application using the Load Balancer URL provided by Terraform output.

**CI/CD with Cloud Build**

This project includes a buildspec.yml file that automates the build and deployment process using Google Cloud Build and Cloud Deploy.

**Cleanup**

To remove all deployed resources:
terraform destroy -auto-approve
