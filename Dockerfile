FROM ubuntu:latest
MAINTAINER jaka.kokosar@gmail.com

WORKDIR /root/

    # install Dependencies
RUN apt-get update && apt-get install -y \ 
    python3-pyqt4 \
    python3-pip \
    libssl-dev \ 
    libffi-dev \
    openssh-client \
    git && \
    # install Orange
    pip3 install --no-binary orange3 orange3 && \
    git clone -b update_scripts --single-branch https://github.com/JakaKokosar/orange-bio.git && \
    cd orange-bio && \
    pip3 install -e . && \
    # Authorize SSH Host
    mkdir -p /root/.ssh/ && \
    chmod 600 /root/.ssh/ && \
    ssh-keyscan orange.biolab.si > /root/.ssh/known_hosts && \
    # clean
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* 

# move files to the image
COPY ssh/ /root/.ssh/
COPY updater/ /root/

ENTRYPOINT ./run_updates.sh && bash
