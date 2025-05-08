# Pi-hole Docker Single-Click Installer for macOS

This project provides the easiest way to install Pi-hole in Docker on your Mac — just double-click!

## Features
- **Single-click** double-clickable installer (`run-pihole.command`)
- **GUI password prompt** for your Pi-hole admin login
- **Automatic Docker check**
  - If Docker Desktop is not installed, the installer will show instructions to get it
- **Persistent config/data directories** (everything in your working folder)
- **Compatible with Pi-hole v6+** (uses proper password method)

## Usage
1. **Install Docker Desktop for Mac** (if you haven't: [Download here](https://www.docker.com/products/docker-desktop)).
2. Download or clone this repo.
3. Double-click `run-pihole.command` in Finder.
4. Enter a password when prompted.
5. Wait a moment for setup — you can visit [http://localhost/admin](http://localhost/admin) to use Pi-hole!

## Advanced
- Script automatically creates `etc-pihole` and `etc-dnsmasq.d` folders for config/data persistence.
- Updates/re-running the script will cleanly reset your admin password.

## Troubleshooting
- If Docker Desktop is not running, start it and re-run the script.
- If you want to reset everything, delete the `etc-pihole` and `etc-dnsmasq.d` folders first.

## Credits
- Built on [pi-hole/docker-pi-hole](https://github.com/pi-hole/docker-pi-hole)

## License
See main repo for license details.
