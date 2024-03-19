#!/usr/bin/env bash

docker run -d -it --name savanna-private-net -v ${HOME}:/docker-mount --entrypoint /bin/bash savanna-antelope:5.1.0-dev-240318
