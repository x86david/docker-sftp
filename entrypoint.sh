#!/bin/bash
set -e

# Fallback values if environment variables are missing
SFTP_USER=${SFTP_USER:-david}
SFTP_PASS=${SFTP_PASS:-12345}
USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

# 1. Dynamically build group and user matching the Host laptop configuration
if ! getent group "$SFTP_USER" >/dev/null; then
    groupadd -g "$USER_GID" "$SFTP_USER"
fi

if ! getent passwd "$SFTP_USER" >/dev/null; then
    useradd -u "$USER_UID" -g "$USER_GID" -m -s /usr/sbin/nologin "$SFTP_USER"
    echo "$SFTP_USER:$SFTP_PASS" | chpasswd
fi

# 2. Strict OpenSSH Chroot security alignment
chown root:root /sftp
chmod 755 /sftp

# 3. Dynamic Write Zone layout matching the host UID
mkdir -p /sftp/files
chown -R "$USER_UID":"$USER_GID" /sftp/files
chmod 775 /sftp/files

# 4. Hand over control to the native OpenSSH Service process
exec /usr/sbin/sshd -D
