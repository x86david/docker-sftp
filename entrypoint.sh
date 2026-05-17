#!/bin/bash

# Ensure the chroot jail parent is strictly owned by root
chown root:root /home/${SFTP_USER}/sftp
chmod 755 /home/${SFTP_USER}/sftp

# Fix the permissions of the mounted volume folder inside the container
chown -R ${SFTP_USER}:${SFTP_USER} /home/${SFTP_USER}/sftp/files
chmod 755 /home/${SFTP_USER}/sftp/files

# Execute the original SSH daemon command passed by Docker
exec "$@"
