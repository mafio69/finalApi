#!/bin/bash
echo "Czy na pewno chcesz usunąć wszystkie pliki wynikowe docker-a  i wyczyścić cache docker-a (masz 15 sekund)?"
read -r -t 15 response


if [ "$response" != "y" ]; then
  echo "Odpuściłeś :-)"
  exit 0
fi

cd ..
docker stop $(docker ps -a -q)
docker container rm $(docker images -q)
docker rmi -f $(docker images -q)
docker volume rm $(docker volume ls -q)
docker builder prune -f -a
docker image prune -f -a
docker system prune -f -a
echo "Sam chciałeś, ubiłeś pliki i cache... :-)"