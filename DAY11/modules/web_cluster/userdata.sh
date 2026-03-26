#!/bin/bash
apt-get update -y
apt-get install -y apache2

systemctl start apache2
systemctl enable apache2

#!/bin/bash
echo "<h1>Hello, My name is ${launch_template_name} terraform 30 day challenge by Tabby</h1>" > /var/www/html/index.html