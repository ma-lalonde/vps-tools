#!/bin/bash

source .env
sed -i "s/YOUR_SITE_HERE/${SITE}/" web/nginx.conf

docker-compose up --build -d

