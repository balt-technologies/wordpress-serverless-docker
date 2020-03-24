#!/bin/sh

cd /var/www/html

wp core config --dbhost="$DB_HOST" --dbname="$DB_DATABASE" --dbprefix="$DB_PREFIX" --dbuser="$DB_USERNAME" --dbpass="$DB_PASSWORD" --path=/var/www/html
wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_name="$WP_ADMIN_USERNAME" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_MAIL" --path=/var/www/html