#!/usr/bin/env bash

docker run --rm -v `pwd`:/go/bin:rw golang:1.9-stretch sh -c "go get github.com/tsg/gotpl"
