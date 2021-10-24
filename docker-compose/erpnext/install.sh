#!/bin/bash
git clone https://github.com/frappe/frappe_docker.git
cp -f docker-compose.yml frappe_docker/docker-compose.yml
cp -f .env frappe_docker/.env
cd frappe_docker
docker-compose up -d