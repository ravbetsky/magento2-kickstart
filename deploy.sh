#!/bin/sh
echo "Starting deploy..."

if [ ! -d src/ ]; then
  mkdir src/
fi

mkdir src/project
git clone git@bitbucket.org:peexlweb/isostore.git src/project

mv src/project/composer.json src/

if [ -f src/app/etc/config.php ] || [ -f src/app/etc/env.php ]; then
  composer update --working-dir=src
  else
  composer install --working-dir=src
  chmod +x src/bin/magento
  cp install.sh src/
  echo "Magento source copied into src/ Run a container and then run setup script - sh install.sh"
fi

rsync -av src/project/ src/
rm -rf src/project/

git --git-dir=src/.git --work-tree=src reset --hard origin/master
git --git-dir=src/.git --work-tree=src checkout master
git --git-dir=src/.git --work-tree=src pull

echo "Deploy finished!"
