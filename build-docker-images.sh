#!/bin/bash

# Execute a Python server serving the downloaded packages
docker-compose up -d

# Build base Docker Wine image
#docker build --no-cache -t docker-wine:4.0-stable -f base/Dockerfile.wine base/

# Build msvc Docker Image
docker build --no-cache -t docker-msvc:16.2-2019 -f msvc-cpp/Dockerfile.msvc msvc-cpp/

# Build extended Docker Image (with CMake, Wix and Conan)
docker build --no-cache -t docker-msvc-extended:16.2-2019 -f msvc-cpp-extended/Dockerfile.tools msvc-cpp-extended/

# Shutdown python server serving packages
docker-compose down -v