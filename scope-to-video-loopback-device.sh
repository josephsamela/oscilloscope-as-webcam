#!/bin/bash

# setup loopback video device
sudo modprobe v4l2loopback
v4l2loopback-ctl set-fps 24 /dev/video1 

# Grab screen and forward to /dev/video1
while true; do
    mogrify -format jpg | \
    echo ':display:data?' | \
    netcat -q 0 192.168.0.10 5555 | \
    tail -c +12 | \
    ffmpeg -re -i pipe: -f v4l2 -vcodec rawvideo -pix_fmt yuv420p /dev/video1
done
