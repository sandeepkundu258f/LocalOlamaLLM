#!/bin/sh

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires sudo privileges. Re-running with sudo..."
  exec sudo "$0" "$@"
fi

echo "Setting up the project environment..."
python -m venv .venv
source .venv/bin/activate

echo "Installing required Python packages..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Downloading the embedding model..."
python downloadEmbeddingModel.py

echo "Setting permissions for the project files..."
chown -R $SUDO_USER:$SUDO_USER .venv
chown -R $SUDO_USER:$SUDO_USER models

echo "Installing Ollama and pulling models..."
curl -fsSL https://ollama.com/install.sh | sh

echo "Starting Ollama service and waiting for it to initialize..."
# Ensure the service is started
systemctl start ollama

# 5-second delay to give the daemon time to bind to the port
sleep 5

sudo -u $SUDO_USER ollama pull mistral:7b
sudo -u $SUDO_USER ollama pull gemma2:2b

echo "Setup complete! You can now run the app with 'python app.py'"