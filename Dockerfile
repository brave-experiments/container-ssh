FROM ubuntu:latest

RUN apt-get update && apt-get install openssh-server sudo -y
ADD start.sh /
EXPOSE 22

COPY nitriding/cmd/nitriding /bin

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd

RUN apt-get install -y x11-utils tigervnc-standalone-server i3
RUN apt-get install -y chromium-browser

CMD ["/start.sh"]
