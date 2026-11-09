#!/bin/bash
set -e

yum update -y
yum install -y httpd

systemctl enable --now httpd

# Install MariaDB
yum install -y mariadb105-server

# Start MariaDB and enable it at boot
systemctl enable --now mariadb

# Generate a random database password
DB_PASSWORD=$(openssl rand -hex 24)

# Configure WordPress database
mysql -u root <<EOF
CREATE DATABASE wordpress;

CREATE USER 'wordpress'@'localhost'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON wordpress.*
TO 'wordpress'@'localhost';
EOF

# Install PHP and required extensions
yum install -y php php-mysqlnd php-gd php-xml php-mbstring

# Restart Apache to load PHP
systemctl restart httpd

# Download WordPress
cd /tmp
curl -fL -o latest.tar.gz https://wordpress.org/latest.tar.gz

# Extract WordPress files
tar -xzf latest.tar.gz

# Copy WordPress into Apache's web directory
cp -a wordpress/. /var/www/html/

# Configure WordPress database connection
cd /var/www/html

cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wordpress/" wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" wp-config.php

# Generate WordPress authentication keys and salts
curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/ \
  -o /tmp/wordpress-salts.php

# Replace the sample authentication keys and salts
sed -i \
  -e "/define( *'AUTH_KEY'/,/define( *'NONCE_SALT'/{
    /define( *'AUTH_KEY'/r /tmp/wordpress-salts.php
    d
  }" wp-config.php

# Remove temporary file
rm -f /tmp/wordpress-salts.php

# Set ownership and permissions
chown -R apache:apache /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# Restrict access to the configuration file
chown apache:apache wp-config.php
chmod 600 wp-config.php