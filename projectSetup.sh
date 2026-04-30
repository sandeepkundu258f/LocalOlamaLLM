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

ollama pull mistral:7b
ollama pull gemma2:2b

echo "Setup complete! You can now run the app with 'python app.py'"