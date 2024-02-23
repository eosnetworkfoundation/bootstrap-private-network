#!/usr/bin/env bash

docker build -f AntelopeDocker --tag savanna-antelope:5.1.0-dev-1a --ulimit nofile=1024:1024 .
