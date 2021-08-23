docker stop $(docker ps -a -q)
docker container rm $(docker images -q)
docker rmi -f $(docker images -q)
docker volume rm $(docker volume ls -q)
docker builder prune
docker image prune
docker system prune