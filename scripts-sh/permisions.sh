#!/bin/bash

cd ..
sudo  chmod 777 -R "$PWD"/main
touch -c "$PWD"/main/var/log/local.log
tail -200 "$PWD"/main/var/log/local.log > "$PWD"/main/var/log/temp.log \
&& rm /"$PWD"/main/var/log/local.log \
&& cat "$PWD"/main/var/log/temp.log > "$PWD"/main/var/log/local.log \
&& rm "$PWD"/main/var/log/temp.log