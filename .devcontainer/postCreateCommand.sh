#!/bin/bash
set -ex

# wait for docker to be ready
#wait_for_docker() {
#  while true; do
#    docker ps > /dev/null 2>&1 && break
#    sleep 1
#  done
#  echo "Docker is ready."
#}
# wait_for_docker

# Docker can take a couple seconds to come up. Wait for it to be ready before
# proceeding with bootstrap. https://github.com/devcontainers/features/issues/977#issuecomment-2148230117
iterations=10
while ! docker ps &>/dev/null; do
  if [[ $iterations -eq 0 ]]; then
    echo "Timeout waiting for the Docker daemon to start."
    exit 1
  fi

  iterations=$((iterations - 1))
  echo 'Docker is not ready. Waiting 10 seconds and trying again.'
  sleep 10
done

# This file is called in three scenarios:
# 1. fresh creation of devcontainer
# 2. rebuild
# 3. full rebuild

# download images beforehand, optional
ddev debug download-images

# avoid errors on rebuilds
ddev poweroff

# show ddev version
ddev -v

# start ddev project automatically
# ddev start -y

# further automated install / setup steps, e.g. 
# ddev composer install 
# See e.g. https://github.com/mandrasch/ddev-craftcms-vite/blob/main/.devcontainer/postCreateCommand.sh
