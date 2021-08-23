#!/bin/bash

cd ..
docker-compose down -v
docker builder prune
docker-compose up --always-recreate-deps --renew-anon-volumes --remove-orphans --force-recreate -d --build