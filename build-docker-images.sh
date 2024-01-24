#!/usr/bin/env bash

# Re-Build base Docker Wine image
docker build  --no-cache  -t madduci/docker-wine:9-stable -f base/Dockerfile base/

# Build extended Docker Image (with CMake, Wix and Conan)
docker build --no-cache -t madduci/docker-wine-msvc:17.8-2022 -f msvc-cpp/Dockerfile .