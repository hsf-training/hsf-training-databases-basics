sudo groupadd docker || true
sudo usermod -aG docker codespace
sudo chown root:docker /var/run/docker.sock
