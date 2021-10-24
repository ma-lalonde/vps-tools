#!/bin/bash
git clone https://github.com/frappe/frappe_docker.git
cp docker-compose.override.yml frappe_docker/docker-compose.override.yml
cp .env frappe_docker/.env
cd frappe_docker
docker-compose --project-name erpnext up -d