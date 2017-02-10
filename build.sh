#!/bin/bash

sudo docker build  --build-arg JUPYTER_PASS=$1 -t maxcan-keras-theano .

# c.NotebookApp.password = u'sha1:b84d13e7db63:afe47b88a83eb078975eb202242b8bcf04186a40'
