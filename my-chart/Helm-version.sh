#!/bin/bash

# Define the chart directory and Chart.yaml path
CHART_DIR="."
CHART_YAML="${CHART_DIR}/Chart.yaml"

# Extract the current version from Chart.yaml
CURRENT_VERSION=$(grep '^version:' "${CHART_YAML}" | awk '{print $2}')

# Increment the version (you can adjust this logic as needed)
NEW_VERSION=$((CURRENT_VERSION + 1))

# Update the version in Chart.yaml
sed -i.bak "s/^version: ${CURRENT_VERSION}/version: ${NEW_VERSION}/" "${CHART_YAML}"
rm "${CHART_YAML}.bak"

echo "Updated version in Chart.yaml from ${CURRENT_VERSION} to ${NEW_VERSION}"
