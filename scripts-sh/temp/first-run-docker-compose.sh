sudo chmod 777 -R ./main
# git clone git@bitbucket.org:ccfound/symfonyapi.git $1
cp  -i .env_example .env
cp  -i ./main/.env.-local ./main/.env.local
docker-compose build

docker-compose up
docker compose exec /main/composer install
docker exec -d debian_bash cd /main && composer require
tail -200  /home/mariusz/PhpstormProjects/symfonyapi/main/var/log/local.log > /home/mariusz/PhpstormProjects/symfonyapi/main/var/log/temp.log \
&& rm /home/mariusz/PhpstormProjects/symfonyapi/main/var/log/local.log \
&& echo /home/mariusz/PhpstormProjects/symfonyapi/main/var/log/temp.log > /home/mariusz/PhpstormProjects/symfonyapi/main/var/log/local.log \
&& rm /home/mariusz/PhpstormProjects/symfonyapi/main/var/log/temp.log