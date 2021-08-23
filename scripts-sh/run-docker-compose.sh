#!/bin/bash

cd ..
docker-compose down -v
# docker network create mf-net
# cp  -i .env_example .env
# cp  -i ./main/.env.-local ./main/.env.local
docker-compose up -d --build
