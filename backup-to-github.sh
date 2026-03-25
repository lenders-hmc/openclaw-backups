#!/bin/bash

# Backup script for OpenClaw workspace to GitHub

WORKSPACE_DIR="/home/zippy/.openclaw/workspace"
BACKUP_DIR="/tmp/openclaw-backup-$(date +%Y%m%d-%H%M%S)"
GITHUB_REPO="lenders-hmc/openclaw-backups" # You can change this to your preferred repo name

echo "Starting backup of OpenClaw workspace..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Copy workspace files to backup directory
cp -r "$WORKSPACE_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true

# Create a timestamp file
echo "$(date)" > "$BACKUP_DIR/backup-timestamp.txt"

# Check if the GitHub repo exists, if not create it
if ! gh repo view "$GITHUB_REPO" > /dev/null 2>&1; then
    echo "Creating GitHub repository: $GITHUB_REPO"
    gh repo create "$GITHUB_REPO" --public --description "Automated backups of OpenClaw workspace" --confirm
fi

# Initialize git in backup directory
cd "$BACKUP_DIR"
git init
git config user.email "zippy@ubuntuserverhp"
git config user.name "Zippy OpenClaw"
git add .
git commit -m "Automated backup $(date)"

# Set up the remote using the gh CLI token
git remote add origin "https://lenders-hmc:${GITHUB_TOKEN}@github.com/$GITHUB_REPO.git"

# If GITHUB_TOKEN is not set, use gh to generate a temporary token
if [ -z "$GITHUB_TOKEN" ]; then
  GITHUB_TOKEN=$(gh auth token)
  git remote set-url origin "https://lenders-hmc:${GITHUB_TOKEN}@github.com/$GITHUB_REPO.git"
fi

git branch -M main
git push -u origin main --force

echo "Backup completed successfully!"
echo "Files backed up to: https://github.com/$GITHUB_REPO"

# Clean up
rm -rf "$BACKUP_DIR"

echo "Backup process finished at $(date)"