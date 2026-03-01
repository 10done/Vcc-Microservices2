#!/bin/bash
# IAM Setup - Grant restricted access
# Run after deploy.sh. Update PRINCIPAL_EMAIL for the user to receive Viewer role.

set -e

PROJECT_ID="${GCP_PROJECT_ID:-your-project-id}"

# User to grant restricted (Viewer) access
PRINCIPAL_EMAIL="${VIEWER_EMAIL:-user@example.com}"

echo "Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID"

echo "Granting Viewer role to $PRINCIPAL_EMAIL..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$PRINCIPAL_EMAIL" \
  --role="roles/viewer"

echo "IAM setup complete. $PRINCIPAL_EMAIL has Viewer (read-only) access."
