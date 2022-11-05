
# official pytorch + GPU image
FROM pytorch/pytorch

# install git
RUN apt-get -y update
RUN apt-get -y install git

#fix error  libGL.so.1: cannot open shared object file: No such file or directory
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y

# base libs
RUN pip install \
    scikit-learn \
    pandas \
    seaborn \
    jupyterlab \
    jupyterlab_widgets \
    "ipywidgets>=7,<8" \
    jupyter-dash


RUN git clone https://github.com/TencentARC/GFPGAN.git
RUN cd GFPGAN
WORKDIR GFPGAN

# Install basicsr - https://github.com/xinntao/BasicSR
# We use BasicSR for both training and inference
RUN pip install basicsr

# Install facexlib - https://github.com/xinntao/facexlib
# We use face detection and face restoration helper in the facexlib package
RUN pip install facexlib

RUN pwd
RUN pip install -r requirements.txt
RUN python setup.py develop

# If you want to enhance the background (non-face) regions with Real-ESRGAN,
# you also need to install the realesrgan package
RUN pip install realesrgan


# install wget and download GFPGAN weights
RUN apt-get install -y wget
RUN wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P experiments/pretrained_models

RUN mkdir ../project
WORKDIR /project