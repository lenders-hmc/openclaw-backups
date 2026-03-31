#!/bin/bash

# Weekly backup script for OpenClaw workspace to GitHub

WORKSPACE_DIR="/home/zippy/.openclaw/workspace"
BACKUP_DIR="/tmp/openclaw-weekly-backup-$(date +%Y%m%d-%H%M%S)"
GITHUB_REPO="lenders-hmc/openclaw-backups"

echo "Starting weekly backup of OpenClaw workspace..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Copy workspace files to backup directory
cp -r "$WORKSPACE_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true

# Create a timestamp file
echo "$(date)" > "$BACKUP_DIR/backup-timestamp.txt"
echo "Weekly backup" > "$BACKUP_DIR/backup-type.txt"

# Initialize git in backup directory
cd "$BACKUP_DIR"
git init
git config user.email "zippy@ubuntuserverhp"
git config user.name "Zippy OpenClaw"
git add .
git commit -m "Weekly automated backup $(date)"

# Set up the remote using the gh CLI token
GITHUB_TOKEN=$(gh auth token)
git remote add origin "https://lenders-hmc:${GITHUB_TOKEN}@github.com/$GITHUB_REPO.git"

git checkout -b weekly-backup-$(date +%Y-%m-%d)
git push -u origin weekly-backup-$(date +%Y-%m-%d) --force

echo "Weekly backup completed successfully!"
echo "Files backed up to: https://github.com/$GITHUB_REPO in branch weekly-backup-$(date +%Y-%m-%d)"

# Clean up
rm -rf "$BACKUP_DIR"

echo "Weekly backup process finished at $(date)"