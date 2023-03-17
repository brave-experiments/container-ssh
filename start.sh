#!/bin/sh -e

# OpenSSH server needs a runtime chroot tree for login to work
mkdir -p /run/sshd

exec /usr/sbin/sshd -d
