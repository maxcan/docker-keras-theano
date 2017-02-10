#!/bin/bash

sudo docker run -p 8888:8888 -v"${PWD}":/opt/notebooks --rm -t -i maxcan-keras-theano


