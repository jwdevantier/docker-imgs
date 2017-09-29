#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${DIR}"

export DOCKER_IP=`ip addr show docker0|grep 'inet\b'|tr -s ' '|cut -d ' ' -f3|cut -d '/' -f1`
exec docker-compose up