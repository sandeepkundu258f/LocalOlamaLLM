#!/bin/sh

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires sudo privileges. Re-running with sudo..."
  exec sudo "$0" "$@"
fi

echo "Removing Ollama from the system..."
sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm /etc/systemd/system/ollama.service

sudo rm -r $(which ollama | tr 'bin' 'lib')

sudo rm $(which ollama)

sudo userdel ollama
sudo groupdel ollama
sudo rm -r /usr/share/ollama

echo "Ollama has been removed from the system."