provider "google" {
  version = "3.20.0"
  # instead of below line we can export variable like this 
  # export GOOGLE_CLOUD_KEYFILE_JSON={{path}}
  # export GOOGLE_CREDENTIALS
  # export GOOGLE_CLOUD_KEYFILE_JSON
  # export GCLOUD_KEYFILE_JSON
  credentials = file("service-account.json")
  project     = "terraform-with-gcp"
  region      = "us-central1"
  zone        = "us-central1-c"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance-${random_id.instance_id.hex}"
  machine_type = "f1-micro"

  metadata = {
    ssh-keys = "sakhtar:${file("~/.ssh/id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Startup script for vm instance
  metadata_startup_script = file("startup.sh")

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}


resource "google_compute_firewall" "terraform-firewall" {
  name    = "golang-app-firewall"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }
}

// A variable for extracting the external ip of the instance
output "ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}