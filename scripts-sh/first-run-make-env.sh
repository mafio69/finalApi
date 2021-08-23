#!/bin/bash

IMAGE=mafio69/api-ccfound
NAME_CONTAINER=api-ccfound
cd  ..
sudo chmod 777 -R ./main
docker-compose down -v
docker network ls  | grep  'mf-net' > ./config/testnetwork.txt
TEST="$(grep mf-net ./config/testnetwork.txt)"
[[ -z "$TEST" ]] && docker network create mf-net
[[ ! -z "$TEST" ]] && echo '[y/N] default n (no) (decker env)'
cp  -i .env_example .env
[[ ! -z "$TEST" ]] && echo '[y/N] default n (no) (symfony env)'
cp  -i ./main/.env.-local ./main/.env.local
WEB_PORT="$(grep WEB_PORT .env)"
PORT=${WEB_PORT##*=}

echo The application will work on this address:  http://127.0.0.1:"$PORT"

if [[ "$(docker images -q $IMAGE 2> /dev/null)" != "" ]] ; then
  docker container rm -f $NAME_CONTAINER > /dev/null
  docker image rm -f $IMAGE > /dev/null
fi

docker image build -t $IMAGE . \
       && docker run -p 8090:8080/tcp -d --name $NAME_CONTAINER  $IMAGE \
       && CTR_ID=$(docker ps -q -f name=$NAME_CONTAINER) \
       && docker cp -a "$CTR_ID":main/vendor/ `pwd`/main/ \
       && docker cp -a "$CTR_ID":main/config/ `pwd`/main/ \
       && docker stop "$CTR_ID"
chmod 777 ./main/vendory
bash -c 'sleep && docker-compose build --parallel'
echo The application will work on this address:  http://127.0.0.1:"$PORT"
bash -c 'sleep 5 && docker-compose up'
