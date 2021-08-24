#!/bin/bash

NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
DOCKER_NAME=cc-backend-last-step-"$NEW_UUID"
SOCKET=/cloudsql/ccfound-vpc-host-dev:europe-west3:dev-sql-mf
DB_LOGIN_PASS=4567
DB_LOGIN=root
MAILER_DSN='smtp://6340f21044aba9:a613d114d259d6@smtp.mailtrap.io:2525?encryption=tls&auth_mode=login'
GCLOUD_SQL=35.198.160.86
EMAIL_PASSWORD=test
EMAIL_HOST=mailtrap
cd ..
rm CID*.txt
cp .env_example .env
docker run -d \
    -it \
    --name "$DOCKER_NAME" \
    --env DB_LOGIN_PASS="$DB_LOGIN_PASS" \
    --env DB_LOGIN="$DB_LOGIN" \
    --env SOCKET="$SOCKET" \
    --env MAILER_DNS="${MAILER_DNS}" \
    --env EMAIL_PASSWORD="$EMAIL_PASSWORD" \
    --env EMAIL_HOST="$EMAIL_HOST" \
    --env GCLOUD_SQL="$GCLOUD_SQL" \
    --cidfile CID-"$DOCKER_NAME".txt \
    -p 8010:8080 \
  --name api-ccfound"$NEW_UUID" \
  --mount type=bind,source="$(pwd)"/main,target=/main \
  mafio69/cc-backend:v0.02