#!/usr/bin/env bash

# March 1st 2024 Build
docker build -f AntelopeDocker --tag savanna-antelope:5.1.0-dev-240301 --ulimit nofile=1024:1024 .
