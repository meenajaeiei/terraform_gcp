provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}

# create vpc
resource "google_compute_network" "lab-pvc" {
  name                    = "lab-pvc"
  auto_create_subnetworks = false
}

# create a subnet resource
resource "google_compute_subnetwork" "terraform-subnet" {
  name          = "lab-pvc-asia-se-01"
  ip_cidr_range = "10.0.0.0/16"
  region        = "${var.region}"
  network       = "${google_compute_network.lab-pvc.name}"
}

#create firewall  rule
resource "google_compute_firewall" "terraform-firewall" {
  name    = "lab-fw-ssh"
  network = "${google_compute_network.lab-pvc.name}"

  allow {
    protocol = "tcp"
    ports    = ["22" ,"80" , "443" , "9090" , "9003"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "lab-fw-vpn" {
  name    = "lab-fw-vpn"
  network = "${google_compute_network.lab-pvc.name}"

  allow {
    protocol = "udp"
    ports    = ["1194"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# create instance
resource "google_compute_instance" "default" {
  count        = "${var.node_count}"
  name         = "${var.instance_name}-${var.image}-${count.index + 1}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  metadata = {
    ssh-keys = "${var.user_ssh}:${file("${var.pubkey_ssh}")}"
  }
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  metadata_startup_script = "${var.startup_script}"
  network_interface {
    subnetwork = "${google_compute_subnetwork.lab-subnet.name}"

    access_config {
      // Ephemeral IP
    }
  }
}
