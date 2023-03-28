# Container SSH

Using the secure shell to run programmes in a secure enclave.

This is intended to be run on an AWS EC2 nitro instance with
the enclave feature enabled.

Log in, setting up tunnels for X11 and VNC:
```sh
ssh -X -L 5900:localhost:5900 -p 2223 ubuntu@${ec2-instance}
```

Then start the remote desktop and applications:
```sh
Xtigervnc -geometry 1920x1080 -localhost -SecurityTypes none &
DISPLAY=:0 i3 &
DISPLAY=:0 brave-browser
```
