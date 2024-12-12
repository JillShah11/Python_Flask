provider "google" {
  project = "assignment2-443106"  # Replace with your Google Cloud Project ID
  region  = "us-central1"          # You can change the region if necessary
}

# Create VPC
resource "google_compute_network" "shah_vpc" {
  name                    = "shah-vpc"
  auto_create_subnetworks  = false
}

# Create Public Subnet
resource "google_compute_subnetwork" "shah_public_subnet" {
  name          = "shah-public-subnet"
  region        = "us-central1"
  network       = google_compute_network.shah_vpc.id
  ip_cidr_range = "10.0.1.0/24"
}

# Create Private Subnet
resource "google_compute_subnetwork" "shah_private_subnet" {
  name          = "shah-private-subnet"
  region        = "us-central1"
  network       = google_compute_network.shah_vpc.id
  ip_cidr_range = "10.0.2.0/24"
}

# Compute Engine Instance with Docker Container (simplified approach)
resource "google_compute_instance" "shah_instance" {
  name         = "shah-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"  # You can change the zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.shah_public_subnet.id
    access_config {}  # Assign a public IP
  }

  tags = ["http-server"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
    docker run -d -p 5000:5000 gcr.io/assignment2-443106/flask-app:v1  # Use your correct image URL
  EOF
}

# Firewall Rule to Allow HTTP Traffic on Port 5000
resource "google_compute_firewall" "shah_firewall" {
  name    = "shah-allow-http"
  network = google_compute_network.shah_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["5000","22","80","443"]
  }

  # Reference the tags of the instance to specify the source for the firewall rule
  source_tags = ["http-server"]
  target_tags = ["http-server"]
}

# Output the Public IP of the Instance
output "instance_public_ip" {
  value       = google_compute_instance.shah_instance.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Flask instance"
}
