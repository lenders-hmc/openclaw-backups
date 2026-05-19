#!/bin/bash

# This script runs the OpenClaw workspace backup to GitHub

echo "Starting scheduled backup of OpenClaw workspace to GitHub at $(date)"

# Run the backup script
bash /home/zippy/.openclaw/workspace/backup-to-github.sh

echo "Scheduled backup completed at $(date)"