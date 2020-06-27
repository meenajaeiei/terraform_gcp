variable "gcp_project" {
  description = "Name of GCP project"
  default = "opsta-training"
}
variable "region" {
  default = "asia-southeast1"
}
variable "zone" {
  default = "asia-southeast1-a"
}
variable "machine_type" {
  description = "GCP machine type"
  default = "n1-standard-1"
}
variable "instance_name" {
  description = "GCP instance name"
  # type = "list"
  default = "terraform-vm"
}
variable "image" {
  description = "GCP Image name"
  default = "centos-7"
}

variable "user_ssh" {
  description = "user use for sign-in"
  default = "centos7"
}

variable "pubkey_ssh" {
  description = "directory file of pubkey use for sign-in"
  default = "./id_rsa.pub"
}

variable "startup_script" {
  description = "A startup script passed as metadata"
  default = "touch /tmp/default_startup_script"
}
variable "node_count" {
  default = "1"
}
