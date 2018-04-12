#!/usr/bin/env bash

# Runs the tests allowing arguments. Removes the container after run.
docker-compose run --rm website rspec $@
