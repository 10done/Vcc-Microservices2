#!/bin/bash
# GCP Deployment Script - VM, MIG, Auto-scaling, Firewall, IAM
# Prerequisites: gcloud CLI installed and authenticated (gcloud auth login)

set -e

# ============ CONFIGURATION - Update these values ============
PROJECT_ID="${GCP_PROJECT_ID:-your-project-id}"
REGION="us-central1"
ZONE="us-central1-a"
INSTANCE_TEMPLATE="instance-template-20260301-070505"
INSTANCE_GROUP="instance-group-1"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="debian-12"
IMAGE_PROJECT="debian-cloud"
MIN_INSTANCES=1
MAX_INSTANCES=10
TARGET_CPU_UTILIZATION=60

# ============ 1. Set project ============
echo "Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID"

# ============ 2. Enable required APIs ============
echo "Enabling Compute Engine API..."
gcloud services enable compute.googleapis.com

# ============ 3. Create Instance Template ============
echo "Creating instance template: $INSTANCE_TEMPLATE..."
gcloud compute instance-templates create "$INSTANCE_TEMPLATE" \
  --region="$REGION" \
  --machine-type="$MACHINE_TYPE" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-balanced

# ============ 4. Create Managed Instance Group with Auto-scaling ============
echo "Creating Managed Instance Group: $INSTANCE_GROUP..."
gcloud compute instance-groups managed create "$INSTANCE_GROUP" \
  --base-instance-name="instance" \
  --template="$INSTANCE_TEMPLATE" \
  --size="$MIN_INSTANCES" \
  --region="$REGION" \
  --target-distribution-shape=balanced

echo "Configuring auto-scaling (min=$MIN_INSTANCES, max=$MAX_INSTANCES, target CPU=$TARGET_CPU_UTILIZATION%)..."
gcloud compute instance-groups managed set-autoscaling "$INSTANCE_GROUP" \
  --region="$REGION" \
  --min-num-replicas="$MIN_INSTANCES" \
  --max-num-replicas="$MAX_INSTANCES" \
  --target-cpu-utilization="$TARGET_CPU_UTILIZATION" \
  --cool-down-period=60

# ============ 5. Firewall rules (optional - defaults exist; uncomment to create custom) ============
# Allow HTTP
# gcloud compute firewall-rules create allow-http \
#   --allow=tcp:80 \
#   --target-tags=http-server \
#   --description="Allow HTTP traffic"

# Allow HTTPS
# gcloud compute firewall-rules create allow-https \
#   --allow=tcp:443 \
#   --target-tags=https-server \
#   --description="Allow HTTPS traffic"

echo ""
echo "============ Deployment complete ============"
echo "Instance template: $INSTANCE_TEMPLATE"
echo "Managed Instance Group: $INSTANCE_GROUP"
echo "Region: $REGION"
echo "Auto-scaling: min=$MIN_INSTANCES, max=$MAX_INSTANCES, target CPU=$TARGET_CPU_UTILIZATION%"
echo ""
echo "View in console: https://console.cloud.google.com/compute/instanceGroups?project=$PROJECT_ID"
