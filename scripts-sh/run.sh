#!/usr/bin/env bash

PORT=8070
IMAGE=mafio69/cc-backend:v0.03
NAME_CONTAINER=api-ccfound
cd  ..
sudo chmod 777 -R ./main
docker network ls  | grep  'mf-net' > ../config/testnetwork.txt
TEST="$(grep mf-net ../config/testnetwork.txt)"
[[ -z "$TEST" ]] && docker network create mf-net


if [[ "$(docker images -q $IMAGE 2> /dev/null)" != "" ]] ; then
  docker container rm -f $NAME_CONTAINER > /dev/null
  docker image rm -f $IMAGE > /dev/null
fi

docker image build  \
    -t $IMAGE . \
       && docker run -d \
    -it \
    --name "$DOCKER_NAME" \
    --env DB_LOGIN_PASS="$DB_LOGIN_PASS" \
    --env DB_LOGIN="$DB_LOGIN" \
    --env SOCKET="$SOCKET" \
    --env DB_URL="$DB_URL" \
    --env MAILER_DNS="${MAILER_DSN}" \
    --env EMAIL_PASSWORD="${EMAIL_PASS}" \
    --env EMAIL_HOST="$EMAIL_HOST" \
    --env GCLOUD_SQL="$GCLOUD_SQL" \
    --cidfile CID-"$DOCKER_NAME".txt \
    -p $WEB_PORT:8080 \
  --name api-ccfound"$NEW_UUID" \
  --mount type=bind,source="$(pwd)"/main,target=/main \
        -d --name $NAME_CONTAINER  $IMAGE \
       && CTR_ID=$(docker ps -q -f name=$NAME_CONTAINER) \
       && docker cp -a "$CTR_ID":main/vendor/ `pwd`/ \
       && docker cp -a "$CTR_ID":main/config/ `pwd`/ \
       && docker stop "$CTR_ID"
echo "$PWD"
chmod 777 ../vendory
echo The application will work on this address:  http://127.0.0.1:"$PORT"

