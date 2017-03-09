#!/bin/bash


if [ `uname` != 'Linux' ] ; then
  docker run -p 8888:8888 -v"${PWD}":/opt/notebooks --rm -t -i maxcan-keras-theano
else
  if [ -z `which nvidia-docker` ] ; then
    echo "please install nvidia-docker as documented here https://github.com/NVIDIA/nvidia-docker/wiki/nvidia-docker";
    exit 1;
  fi;
  sudo nvidia-docker run -p 8888:8888 -v"${PWD}":/opt/notebooks --rm -t -i maxcan-keras-theano
fi

