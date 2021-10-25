#!/bin/bash
git clone https://github.com/frappe/frappe_docker.git
cp -f docker-compose-erpnext.yml frappe_docker/installation/docker-compose-erpnext.yml
cp -f docker-compose-networks.yml frappe_docker/installation/docker-compose-networks.yml
cp -f .env frappe_docker/.env
cd frappe_docker
docker-compose up -d