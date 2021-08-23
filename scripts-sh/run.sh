#!/bin/bash
docker run -d \
  -it \
  --name api-ccfound \
  --mount type=bind,source="$(pwd)"/main,target=/main \
  mafio69/cc-backend:v0.01