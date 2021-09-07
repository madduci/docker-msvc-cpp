#!/usr/bin/env bash

# Execute a Python server serving the downloaded packages
docker-compose up -d

# Re-Build base Docker Wine image
docker build  --no-cache  -t madduci/docker-wine:6-stable -f base/Dockerfile base/

# Build extended Docker Image (with CMake, Wix and Conan)
docker build --no-cache -t madduci/docker-wine-msvc:16.11-2019 -f msvc-cpp/Dockerfile msvc-cpp/

# Shutdown python server serving packages
docker-compose down -v
