#!/bin/sh
echo "Running Magento 2 setup script..."
/src/bin/magento setup:install \
  --db-host=$M2SETUP_DB_HOST \
  --db-name=$M2SETUP_DB_NAME \
  --db-user=$M2SETUP_DB_USER \
  --db-password=$M2SETUP_DB_PASSWORD \
  --base-url=$M2SETUP_BASE_URL \
  --admin-firstname=$M2SETUP_ADMIN_FIRSTNAME \
  --admin-lastname=$M2SETUP_ADMIN_LASTNAME \
  --admin-email=$M2SETUP_ADMIN_EMAIL \
  --admin-user=$M2SETUP_ADMIN_USER \
  --admin-password=$M2SETUP_ADMIN_PASSWORD \
  $M2SETUP_USE_SAMPLE_DATA_STRING

echo "Reindexing all indexes..."
/src/bin/magento indexer:reindex

echo "Deploying static view files..."
/src/bin/magento setup:static-content:deploy

echo "Applying ownership & proper permissions..."
sed -i 's/0770/0775/g' /src/vendor/magento/framework/Filesystem/DriverInterface.php
sed -i 's/0660/0664/g' /src/vendor/magento/framework/Filesystem/DriverInterface.php
find pub -type f -exec chmod 664 {} \;
find pub -type d -exec chmod 775 {} \;
find /src/var/generation -type d -exec chmod g+s {} \;

echo "The setup script has completed execution."
