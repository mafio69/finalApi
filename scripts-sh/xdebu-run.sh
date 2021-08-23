#!/bin/bash

docker cp "$PWD"/../config/xdebug-on.ini api-backend:/usr/local/etc/php/conf.d/xdebug.ini
echo 'Done'
exit 0;

