provider "google" {
  project = "green-carrier-393306"
  region = "europe-central2"
  credentials = "green-carrier-393306-3e663174ea51.json"
}

resource "google_container_cluster" "test" {
  name = "test-cluster"
  location = "europe-central2"
  enable_autopilot = true
}

resource "google_container_cluster" "flask" {
  name = "flask-cluster"
  location = "europe-central2"
  enable_autopilot = true
}
