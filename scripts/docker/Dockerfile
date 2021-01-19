FROM ubuntu:16.04

MAINTAINER ETSI STF 583

LABEL description="SFT583 Robot Framework Docker Image"

ENV TERM=xterm
ENV HOSTNAME docker-robot-STF583

ARG ssh_prv_key

RUN DEBIAN_FRONTEND=noninteractive apt update \
	&& apt install python3 git -y \
	&& apt install python3-pip -y \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
    && DEBIAN_FRONTEND=noninteractive apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "docker-robot-STF583" > /etc/hostname \
    && echo "root:etsi" | chpasswd

RUN useradd --create-home --shell /bin/bash --user-group etsi --groups sudo \
    && echo "etsi:etsi" | chpasswd \
    && adduser etsi sudo \
    && echo "etsi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN DEBIAN_FRONTEND=noninteractive \
        && mkdir -p /home/etsi/dev/robot \
        && cd /home/etsi/dev/robot 

#RUN pip3 install robotframework

ADD requirements.txt /home/etsi/dev/robot/
ADD extensions /home/etsi/dev/robot/extensions

RUN ls /home/etsi/dev/robot


RUN DEBIAN_FRONTED=noninteractive \
	cd /home/etsi/dev/ \
	mkdir -p build \
	&& git clone https://forge.etsi.org/rep/forge-tools/robot2doc.git \
	&& cd robot2doc \
	&& pip3 install -r requirements.txt \
	&& python3 -m pip install -e .

RUN DEBIAN_FRONTEND=noninteractive \
	&& cd /home/etsi/dev/robot \
	&& pip3 install -r requirements.txt


ADD . /home/etsi/dev/robot

RUN	chmod +x /home/etsi/dev/robot/scripts/*

CMD tail -f /dev/null


