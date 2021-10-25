#!/bin/bash
git clone https://github.com/frappe/frappe_docker.git
cp -f docker-compose-erpnext.override.yml frappe_docker/installation/docker-compose-erpnext.yml
cp -f docker-compose-networks.override.yml frappe_docker/installation/docker-compose-networks.yml
cp -f .env frappe_docker/.env
cd frappe_docker
docker-compose -f installation/docker-compose-common.yml -f installation/docker-compose-erpnext.yml -f installation/docker-compose-networks.yml up -d