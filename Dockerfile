FROM ubuntu:latest

RUN apt-get update && apt-get install openssh-server sudo -y
ADD start.sh /
EXPOSE 22

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 
RUN  echo 'test:test' | chpasswd

CMD ["/start.sh"]
