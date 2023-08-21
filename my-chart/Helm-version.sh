#!/bin/bash

# Define the chart directory and Chart.yaml path
CHART_DIR="."
CHART_YAML="${CHART_DIR}/Chart.yaml"

# Retrieve the latest version from Google Cloud Storage
LATEST_VERSION=$(gsutil ls gs://helmflask-bucket/ | grep -oP 'my-chart-\K\d+\.\d+\.\d+' | sort -Vr | head -n 1)

# Convert version components to integers
MAJOR=$(echo "${LATEST_VERSION}" | cut -d. -f1)
MINOR=$(echo "${LATEST_VERSION}" | cut -d. -f2)
PATCH=$(echo "${LATEST_VERSION}" | cut -d. -f3)

# Increment the version (0.0.1 style)
PATCH=$((PATCH + 1))

# Update the version in Chart.yaml
NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
sed -i.bak "s/^version: 0.1.0/version: ${NEW_VERSION}/" "${CHART_YAML}"
rm "${CHART_YAML}.bak"

# Navigate to chart directory, package the chart, and upload to Google Cloud Storage
helm package .  # Package the Helm chart
gsutil cp ./my-chart-${NEW_VERSION}.tgz gs://helmflask-bucket/  # Copy the chart package to Google Cloud Storage
helm repo index . --url https://storage.googleapis.com/helmflask-bucket/
gsutil cp index.yaml gs://helmflask-bucket/

# Display messages about the process
echo "Latest version in Google Cloud Storage: ${LATEST_VERSION}"
echo "Updated version in Chart.yaml to ${NEW_VERSION}"
echo "Packaged chart and uploaded to Google Cloud Storage"

