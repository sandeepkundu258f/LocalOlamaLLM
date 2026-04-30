sudo systemctl edit ollama.service

# add these, if you have potato pc (old or no GPU)
[Service]
Environment="OLLAMA_NO_GPU=1"
Environment="CUDA_VISIBLE_DEVICES=-1"

# Reload the manager configuration
sudo systemctl daemon-reload

# Restart the actual service
sudo systemctl restart ollama