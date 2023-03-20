#!/bin/sh -e

# Start nitriding proxy
nitriding -fqdn example.com -extport 8443 -intport 8081 &

echo "Waiting for nitro to start up..."
sleep 1

# OpenSSH server needs a runtime chroot tree for login to work
mkdir -p /run/sshd

exec /usr/sbin/sshd -d
