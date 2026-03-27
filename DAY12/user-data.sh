
#!/bin/bash
apt-get update -y
apt-get install -y apache2

systemctl start apache2
systemctl enable apache2

echo "<h1>Hello, My name is terraform 30 day challenge zero downtime</h1>" > /var/www/html/index.html