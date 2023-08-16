#!/bin/bash

# Define the chart directory and Chart.yaml path
CHART_DIR="."
CHART_YAML="${CHART_DIR}/Chart.yaml"

# Extract the current version from Chart.yaml
CURRENT_VERSION=$(grep '^version:' "${CHART_YAML}" | awk '{print $2}')

# Convert version components to integers
MAJOR=$(echo "${CURRENT_VERSION}" | cut -d. -f1)
MINOR=$(echo "${CURRENT_VERSION}" | cut -d. -f2)
PATCH=$(echo "${CURRENT_VERSION}" | cut -d. -f3)

# Increment the version (0.0.1 style)
PATCH=$((PATCH + 1))

# Update the version in Chart.yaml
NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
sed -i.bak "s/^version: ${CURRENT_VERSION}/version: ${NEW_VERSION}/" "${CHART_YAML}"
rm "${CHART_YAML}.bak"

echo "Updated version in Chart.yaml from ${CURRENT_VERSION} to ${NEW_VERSION}"

