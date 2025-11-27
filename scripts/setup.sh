#!/bin/bash

set -e

echo "=== HAProxy + Nginx Setup Script ==="

# Update system
echo "Updating system packages..."
sudo apt update

# Install HAProxy and Nginx
echo "Installing HAProxy and Nginx..."
sudo apt install -y haproxy nginx

# Create web content directories
echo "Creating web content directories..."
sudo mkdir -p /var/www/backend1
sudo mkdir -p /var/www/backend2

# Create index.html for backend1
sudo tee /var/www/backend1/index.html > /dev/null << 'HTML1'
<!DOCTYPE html>
<html>
<head>
    <title>Backend Server 1</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #e8f4f8; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        .server-info { background: #3498db; color: white; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Backend Server 1</h1>
        <div class="server-info">
            <p><strong>Server:</strong> Nginx Backend 1</p>
            <p><strong>Port:</strong> 8888</p>
            <p><strong>Load Balancer:</strong> HAProxy</p>
        </div>
        <p>This request was handled by <strong>Backend Server 1</strong> through HAProxy load balancer.</p>
        <p>Time: $(date)</p>
    </div>
</body>
</html>
HTML1

# Create index.html for backend2
sudo tee /var/www/backend2/index.html > /dev/null << 'HTML2'
<!DOCTYPE html>
<html>
<head>
    <title>Backend Server 2</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f8e8e8; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #c0392b; }
        .server-info { background: #e74c3c; color: white; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔥 Backend Server 2</h1>
        <div class="server-info">
            <p><strong>Server:</strong> Nginx Backend 2</p>
            <p><strong>Port:</strong> 9999</p>
            <p><strong>Load Balancer:</strong> HAProxy</p>
        </div>
        <p>This request was handled by <strong>Backend Server 2</strong> through HAProxy load balancer.</p>
        <p>Time: $(date)</p>
    </div>
</body>
</html>
HTML2

# Set proper permissions
echo "Setting permissions..."
sudo chown -R www-data:www-data /var/www/backend1
sudo chown -R www-data:www-data /var/www/backend2

# Backup original HAProxy config
echo "Backing up original HAProxy configuration..."
sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.backup

# Copy our HAProxy configuration
echo "Configuring HAProxy..."
sudo cp configs/haproxy.cfg /etc/haproxy/haproxy.cfg

# Create Nginx configs for backends
echo "Configuring Nginx backends..."
sudo cp configs/nginx-backend1.conf /etc/nginx/sites-available/backend1
sudo cp configs/nginx-backend2.conf /etc/nginx/sites-available/backend2

# Enable Nginx sites
sudo ln -sf /etc/nginx/sites-available/backend1 /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/backend2 /etc/nginx/sites-enabled/

# Disable default Nginx site
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Start services
echo "Starting and enabling services..."
sudo systemctl enable haproxy
sudo systemctl enable nginx
sudo systemctl restart haproxy
sudo systemctl restart nginx

echo "=== Setup completed successfully! ==="
echo ""
echo "Access points:"
echo "  - HAProxy Stats: http://localhost:888/stats"
echo "  - Load Balancer: http://localhost:8088"
echo "  - Backend 1: http://localhost:8888"
echo "  - Backend 2: http://localhost:9999"
echo "  - TCP Balance: telnet localhost 1325"
echo ""
echo "To test load balancing, run: curl http://localhost:8088"
