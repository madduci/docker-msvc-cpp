#!/bin/bash
Xvfb :0 -screen 0 1024x768x24 -ac &
export DISPLAY=:0.0