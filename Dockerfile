FROM ubuntu:latest
LABEL maintainer "wataken44"

ENV DOCKER "YES"
ENV LANG C.UTF-8

RUN set -xe \
    && apt update \
    && apt dist-upgrade -y \
    && apt install --no-install-recommends -y openssh-server sudo\
    && apt autoclean -y \
    && apt autoremove -y

RUN set -xe \
    && groupadd ubuntu \
    && useradd -g ubuntu -G sudo -m -s /bin/bash ubuntu \
    && echo 'ubuntu:ubuntu' | chpasswd

RUN set -xe \
    && sed -i -e 's/#PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config \
    && sed -i -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN set -xe \
    && chown -R ubuntu:ubuntu /home/ubuntu 

EXPOSE 22
CMD service ssh start && tail -f /dev/null
