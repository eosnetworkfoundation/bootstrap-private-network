#!/usr/bin/env bash

docker_overlay_fs_with_spaces=$(docker info | grep 'Docker Root Dir' | cut -d: -f2)
docker_overlay_fs=$(echo "$docker_overlay_fs_with_spaces" | xargs)
total_size=$(df -h ${docker_overlay_fs} | awk 'NR==2 {print $2}' | sed 's/Gi*//')
used_size=$(df -h ${docker_overlay_fs} | awk 'NR==2 {print $3}' | sed 's/Gi*//')
max_space_used=$((${total_size}-13-${total_size}*11/100))
if [ $used_size -gt $max_space_used ]; then
  echo "WARNING: may not have enough space in ${docker_overlay_fs}\!"
  echo "WARNING: estimate can not exceed ${max_space_used} space used"
  sleep 3
  echo "proceeding..."
fi

# March 1st 2024 Build
docker build -f AntelopeDocker --tag savanna-antelope:5.1.0-dev-240301 --ulimit nofile=1024:1024 .
