#!/usr/bin/env bash

docker run --rm -it -v $(pwd):/home/wine/.wine/drive_c/project madduci/docker-wine-msvc:17.8-2022 ""C:/project/build.bat""
