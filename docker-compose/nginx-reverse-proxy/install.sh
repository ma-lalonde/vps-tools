#!/bin/bash
docker network create --attachable=true --driver=bridge --subnet=172.28.0.0/16 --gateway=172.28.0.1 --opt com.docker.network.bridge.name=docker_proxy0 network-nginx-proxy
docker-compose up -d