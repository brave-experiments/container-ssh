# Container SSH

Using the secure shell to run programmes in a secure enclave.

This is intended to be run on an AWS EC2 nitro instance with
the enclave feature enabled.

## Instructions

Log into the host instance and clone this repository.

Run the `config.sh` script to configure necessary dependencies.
Re-log or source `~/.profile` to pick up the updated path.

Run `make` to build the enclave image.

Run `make gvproxy` to start the public side of the network proxy.

Update `/etc/nitro_enclaves/allocator.yaml` to allow a 4000 MB allocation
to the enclave, followed by `sudo systemctl restart nitro-enclaves-allocator`.

Start the enclave application with `make run`.

In a separate terminal, log in to the enclave with password "ubuntu",
setting up tunnels for X11 and VNC:
```sh
ssh -X -L 5900:localhost:5900 -p 2223 ubuntu@${ec2-instance}
```

Then start the remote desktop and applications:
```sh
Xtigervnc -geometry 1920x1080 -localhost -SecurityTypes none &
DISPLAY=:0 i3 &
DISPLAY=:0 brave-browser
```

Connect to `vnc://localhost:5900` with a remote desktop client to interact
with the application.
