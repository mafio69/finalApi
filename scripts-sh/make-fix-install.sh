#!/bin/bash
docker ps -qf name=api-03
read ID_CONTAINER
docker exec "$ID_CONTAINER" bash -c /temp/fix.sh

exit 0