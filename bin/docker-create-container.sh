#!/usr/bin/env bash

docker run -d -it --name savanna-private-net -v ${HOME}:/docker-mount --entrypoint /bin/bash savanna-antelope-transition:1.0.0-rc1
