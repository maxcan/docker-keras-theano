FROM continuumio/anaconda

RUN conda install -y bcolz
RUN conda upgrade -y --all

# install and configure theano
ENV HOME_DIR="/root"
ENV TMP_DIR="/tmp"
RUN mkdir -p $HOME_DIR
RUN mkdir -p $TMP_DIR
WORKDIR $HOME_DIR
ADD assets/* $HOME_DIR/
RUN pip install theano
RUN pip install keras

WORKDIR $TMP_DIR

# # install cudnn libraries
RUN wget --quiet "http://platform.ai/files/cudnn.tgz" -O "cudnn.tgz"
RUN tar -zxf cudnn.tgz
WORKDIR $TMP_DIR/cuda
# cd cuda
RUN mkdir -p /usr/local/cuda/include
RUN mkdir -p /usr/local/cuda/lib64
RUN cp lib64/* /usr/local/cuda/lib64/
RUN cp include/* /usr/local/cuda/include/
# 
# # configure jupyter and prompt for password
WORKDIR $HOME_DIR
ENV NB_CONF=$HOME_DIR/.jupyter/jupyter_notebook_config.py
RUN jupyter notebook --generate-config
ARG JUPYTER_PASS
RUN python -c "from notebook.auth import passwd; print(\"c.NotebookApp.password = u'\" + passwd(\"$JUPYTER_PASS\") + \"'\")" >> $NB_CONF

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
CMD ["/opt/conda/bin/jupyter", "notebook",  "--notebook-dir=/opt/notebooks", "--ip='*'", "--port=8888", "--no-browser"]

