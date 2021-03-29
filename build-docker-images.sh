#!/usr/bin/env bash

# Expose the downloaded packages to Docker
for F in vagrant/packages/*.zip; do
    ln -f "$F" msvc-cpp/
done

# Re-Build base Docker Wine image
docker build  --no-cache  -t madduci/docker-wine:6-stable -f base/Dockerfile base/

# Build extended Docker Image (with CMake, Wix and Conan)
docker build --no-cache -t docker-wine-msvc:16.9-2019 -f msvc-cpp/Dockerfile msvc-cpp/

# Drop the exposed packages (they still remain in vagrant/packages)
rm msvc-cpp/*.zip
