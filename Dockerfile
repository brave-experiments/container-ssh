FROM ubuntu:latest

RUN apt-get update && apt-get install openssh-server sudo -y
ADD start.sh /
EXPOSE 22

COPY nitriding/cmd/nitriding /bin

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd

# Minimal remote desktop
RUN apt-get install -y x11-apps tigervnc-standalone-server i3

# Web browser
ADD https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg /usr/share/keyrings/
RUN chmod 644 /usr/share/keyrings/brave-browser-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-release.list
RUN apt-get update && apt-get install -y brave-browser

# Remove package metadata to reduce image size
RUN apt-get clean

CMD ["/start.sh"]
