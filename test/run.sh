#!/usr/bin/env bash

docker run --rm -it -v $(pwd):/home/wine/.wine/drive_c/project docker-wine-msvc:16.6-2019 "cd project && build.bat"