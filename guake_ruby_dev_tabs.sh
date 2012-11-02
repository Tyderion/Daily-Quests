#!/bin/bash
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
guake &
sleep 2
guake --rename-tab="Rails Server" --execute-command="cd $DIR && rails s" &
sleep 2
guake --new-tab=2 --rename-tab="Spork" --execute-command="cd $DIR && spork" &
sleep 2
guake --new-tab=3 --rename-tab="Rails Console" --execute-command="cd $DIR && rails c" &
sleep 2
guake --new-tab=4 --rename-tab="Rails Terminal" --execute-command="cd $DIR && clear" &

sublime

