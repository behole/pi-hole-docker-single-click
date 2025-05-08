#!/bin/bash

# Pi-hole Single-Click Docker Installer for macOS
# This script prompts the user for an admin password and starts Pi-hole via Docker

# Check that Docker is installed
if ! command -v docker &> /dev/null; then
  osascript -e 'Tell application "System Events" to display dialog "Docker is NOT installed. Please install Docker Desktop for Mac from https://www.docker.com/products/docker-desktop and try again." buttons {"OK"}'
  exit 1
fi

# Prompt for the admin password using AppleScript
default_pw="admin"
PIHOLE_PASS=$(osascript -e 'Tell application "System Events" to display dialog "Enter Pi-hole admin password:" default answer "'"$default_pw"'" with hidden answer buttons {"OK"} default button 1' -e 'text returned of result')

# Create working directories
mkdir -p etc-pihole etc-dnsmasq.d

# Set environment variable for Pi-hole password
env_file=".pihole_env"
echo "WEBPASSWORD=$PIHOLE_PASS" > $env_file

echo "Launching Pi-hole Docker container..."
docker run -d \
  --name pihole \
  -p 53:53/tcp -p 53:53/udp -p 80:80 -p 443:443 \
  -v "$(pwd)/etc-pihole:/etc/pihole" \
  -v "$(pwd)/etc-dnsmasq.d:/etc/dnsmasq.d" \
  --restart=unless-stopped \
  --env-file $env_file \
  pihole/pihole

# Wait for Pi-hole container to be healthy before setting password

# Wait up to 60 seconds for container to be healthy
attempts=0
while [ $attempts -lt 30 ]; do
  health=$(docker inspect --format='{{.State.Health.Status}}' pihole 2>/dev/null)
  if [[ "$health" == "healthy" ]]; then
    break
  fi
  sleep 2
  attempts=$((attempts+1))
done

# Explicitly set the password using the new compatible Pi-hole v6+ method
if docker ps | grep -q pihole; then
  docker exec pihole pihole setpassword "$PIHOLE_PASS"
fi

echo "Pi-hole is deploying. You can access it (when ready) at: http://localhost/admin"
