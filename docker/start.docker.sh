#!/bin/bash

image_name="devenv-test"

docker build -t "$image_name" .

docker run --rm "$image_name"



