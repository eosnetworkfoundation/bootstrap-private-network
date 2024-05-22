#!/usr/bin/env bash

docker run -d -it --name gpo-private-net -v ${HOME}:/docker-mount --entrypoint /bin/bash savanna-antelope:GH-182-gpo
