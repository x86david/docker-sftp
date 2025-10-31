FROM debian:stable-slim

ARG SFTP_USER
ARG SFTP_PASS

ENV SFTP_USER=${SFTP_USER}
ENV SFTP_PASS=${SFTP_PASS}

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd

# Create user and set password
RUN useradd -m -d /home/${SFTP_USER}/sftp/files -s /usr/sbin/nologin ${SFTP_USER} && \
    echo "${SFTP_USER}:${SFTP_PASS}" | chpasswd

# Create chroot structure
RUN mkdir -p /home/${SFTP_USER}/sftp/files && \
    chown root:root /home/${SFTP_USER}/sftp && \
    chmod 755 /home/${SFTP_USER}/sftp && \
    chown ${SFTP_USER}:${SFTP_USER} /home/${SFTP_USER}/sftp/files

# Configure SSHD for SFTP-only
RUN echo "Match User ${SFTP_USER}\n\
    ChrootDirectory /home/${SFTP_USER}/sftp\n\
    ForceCommand internal-sftp\n\
    AllowTcpForwarding no\n\
    X11Forwarding no" >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
