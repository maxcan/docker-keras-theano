# FROM continuumio/anaconda
# FROM ubuntu:16.04
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
ENV HOME_DIR="/root"
ENV TMP_DIR="/tmp"
RUN mkdir -p $HOME_DIR
RUN mkdir -p $TMP_DIR

WORKDIR $TMP_DIR
RUN apt-get update
# RUN apt-get --assume-yes upgrade
RUN apt-get --assume-yes install build-essential gcc g++ make binutils
RUN apt-get --assume-yes install software-properties-common
RUN apt-get --assume-yes install curl wget
# 
# # download and install GPU drivers
# ARG CUDA_VERS=8.0.61-1
#           #http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
# RUN curl "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_${CUDA_VERS}_amd64.deb" -o "cuda-repo-ubuntu1604_${CUDA_VERS}_amd64.deb"
# 
# RUN dpkg -i cuda-repo-ubuntu1604_${CUDA_VERS}_amd64.deb
# RUN apt update
# RUN apt install -y cuda
# RUN modprobe nvidia
#$ RUN nvidia-smi

RUN wget --quiet "https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh" -O "Anaconda2-4.2.0-Linux-x86_64.sh"
RUN bash "Anaconda2-4.2.0-Linux-x86_64.sh" -b

RUN echo "export PATH=\$PATH:$HOME_DIR/anaconda2/bin" >> $HOME_DIR/.bashrc

ENV CONDA $HOME_DIR/anaconda2/bin/conda

RUN $CONDA install -y bcolz
RUN $CONDA upgrade -y --all

# install and configure theano
WORKDIR $HOME_DIR
ADD assets/.theanorc $HOME_DIR/.theanorc
RUN mkdir -p $HOME_DIR/.keras
ADD assets/.keras/keras.json $HOME_DIR/.keras/keras.json
RUN $HOME_DIR/anaconda2/bin/pip install theano
RUN $HOME_DIR/anaconda2/bin/pip install keras

WORKDIR $TMP_DIR

# # install cudnn libraries
# RUN wget --quiet "http://platform.ai/files/cudnn.tgz" -O "cudnn.tgz"
# RUN tar -zxf cudnn.tgz
# WORKDIR $TMP_DIR/cuda
# # cd cuda
# RUN mkdir -p /usr/local/cuda/include
# RUN mkdir -p /usr/local/cuda/lib64
# RUN cp lib64/* /usr/local/cuda/lib64/
# RUN cp include/* /usr/local/cuda/include/
# 
# # configure jupyter and prompt for password
WORKDIR $HOME_DIR
ENV NB_CONF=$HOME_DIR/.jupyter/jupyter_notebook_config.py
RUN $HOME_DIR/anaconda2/bin/jupyter notebook --generate-config
ARG JUPYTER_PASS
RUN $HOME_DIR/anaconda2/bin/python -c "from notebook.auth import passwd; print(\"c.NotebookApp.password = u'\" + passwd(\"$JUPYTER_PASS\") + \"'\")" >> $NB_CONF

# echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '*'" >> $NB_CONF
# c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py
# 
# # clone the fast.ai course repo and prompt to start notebook
# cd ~
# git clone https://github.com/fastai/courses.git
# echo "\"jupyter notebook\" will start Jupyter on port 8888"
# echo "If you get an error instead, try restarting your session so your $PATH is updated"
WORKDIR $HOME_DIR
CMD $HOME_DIR/anaconda2/bin/jupyter notebook --notebook-dir=/opt/notebooks --port=8888 --no-browser
 

