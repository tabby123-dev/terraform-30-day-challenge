#!/bin/bash

# Update system
yum update -y

# Install Apache (httpd)
yum install -y httpd

# Start and enable service
systemctl start httpd
systemctl enable httpd

# Create test page
echo "Hello from $(hostname)" > /var/www/html/index.html