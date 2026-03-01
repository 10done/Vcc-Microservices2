# Vcc-Microservices2

GCP deployment scripts for VM instances, Managed Instance Group (MIG), auto-scaling, firewall, and IAM roles.

## Architecture

![Architecture Diagram](Architecture%20Diagram%20VCC2.png)

- **VM Setup:** Instance template (e2-medium, Debian 12) → Managed Instance Group → VMs in us-central1
- **Auto-scaling:** Cloud Monitoring (CPU) → Autoscaler (min 1, max 10, target 60% CPU) → scale in/out
- **Security:** IAM roles (Owner, Viewer, Editor) + firewall (default allow rules for http, ssh, icmp, internal)

## Prerequisites

1. [Google Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/install) installed
2. Authenticated: `gcloud auth login`
3. Your GCP project ID

## Usage

### 1. Deploy VM, MIG, and auto-scaling

```bash
export GCP_PROJECT_ID="your-project-id"
chmod +x deploy.sh
./deploy.sh
```

### 2. Grant IAM restricted access (optional)

```bash
export GCP_PROJECT_ID="your-project-id"
export VIEWER_EMAIL="user@example.com"
chmod +x iam-setup.sh
./iam-setup.sh
```

## Files

| File | Description |
|------|-------------|
| `deploy.sh` | Creates instance template, MIG, and configures CPU-based auto-scaling |
| `iam-setup.sh` | Grants Viewer role to a principal (restricted access) |
| `Architecture Diagram VCC2.png` | Architecture diagram |
| `architecture-diagram.html` | Interactive diagram (open in browser) |
| `architecture-diagram.mmd` | Mermaid source for the diagram |

## Configuration

Edit variables in `deploy.sh`: `PROJECT_ID`, `REGION`, `ZONE`, `MIN_INSTANCES`, `MAX_INSTANCES`, `TARGET_CPU_UTILIZATION`.
