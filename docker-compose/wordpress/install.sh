#!/bin/bash

source .env
sed 's/YOUR_SITE_HERE/${SITE}/'

docker-compose up -d
