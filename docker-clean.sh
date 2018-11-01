#!/bin/bash

docker_compose_ps_array=( $(docker-compose ps -q) )
docker_compose_ps_array_size=${#docker_compose_ps_array[@]}

if [ ${docker_compose_ps_array_size} -gt "0" ]; then
    docker-compose down --remove-orph 2>/dev/null & wait;
fi

docker_compose_images_array=( $(docker-compose images -q) )
docker_compose_images_array_size=${#docker_compose_images_array[@]}

if [ ${docker_compose_images_array_size} -gt "0" ]; then
    docker-compose down --remove-orph 2>/dev/null & wait;
fi

docker_ps_array=( $(docker ps -a -q) )
docker_ps_array_size=${#docker_ps_array[@]}

if [ ${docker_ps_array_size} -gt "0" ]; then
    docker rm -f $(docker ps -q) 2>/dev/null & wait && docker rm -f $(docker ps -a -q) 2>/dev/null & wait;
fi

docker_images_array=( $(docker images -a -q) )
docker_images_array_size=${#docker_images_array[@]}

if [ ${docker_images_array_size} -gt "0" ]; then
    docker rmi -f $(docker images -q) 2>/dev/null & wait && docker rmi -f $(docker images -a -q) 2>/dev/null & wait;
fi

if [ "$1" == "all" ]; then
    docker volume rm $(docker volume ls -q) 2>/dev/null & wait;
fi
