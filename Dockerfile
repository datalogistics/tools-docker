FROM python:3.6-stretch

MAINTAINER Ezra Kissel <ezkissel@indiana.edu>

RUN apt-get update
RUN apt-get -y install sudo cmake gcc python-setuptools python-pip

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/dlt && \
    echo "dlt:x:${uid}:${gid}:WILDFIRE-DLN,,,:/home/dlt:/bin/bash" >> /etc/passwd && \
    echo "dlt:x:${uid}:" >> /etc/group && \
    echo "dlt ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dlt && \
    chmod 0440 /etc/sudoers.d/dlt && \
    chown ${uid}:${gid} -R /home/dlt && \
    chown ${uid}:${gid} -R /opt

USER dlt
ENV HOME /home/dlt
WORKDIR $HOME

RUN git clone -b develop https://github.com/periscope-ps/unisrt
RUN git clone -b master https://github.com/periscope-ps/lace
RUN git clone -b develop https://github.com/datalogistics/libdlt

ADD build.sh .
RUN bash ./build.sh

RUN mkdir $HOME/.periscope
ADD depots $HOME/.depots
ADD .rtcache $HOME/.periscope/.rtcache/
ADD .cache $HOME/.periscope/.cache/

ADD doc.txt .
CMD cat doc.txt
