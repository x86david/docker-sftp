FROM debian:stable-slim

ARG SFTP_USER
ARG SFTP_PASS
ARG SFTP_UID # <--- Add this line

ENV SFTP_USER=${SFTP_USER}
ENV SFTP_PASS=${SFTP_PASS}

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd

# Create user with a SPECIFIC UID matching your host laptop
RUN useradd -m -u ${SFTP_UID} -d /home/${SFTP_USER}/sftp/files -s /usr/sbin/nologin ${SFTP_USER} && \
    echo "${SFTP_USER}:${SFTP_PASS}" | chpasswd

# Create chroot structure initially
RUN mkdir -p /home/${SFTP_USER}/sftp/files

# Configure SSHD for SFTP-only with optimized buffer and request parameters
RUN echo "Match User ${SFTP_USER}\n\
    ChrootDirectory /home/${SFTP_USER}/sftp\n\
    ForceCommand internal-sftp -R 64 -B 262144\n\
    AllowTcpForwarding no\n\
    X11Forwarding no" >> /etc/ssh/sshd_config

# Copy and set up the entrypoint script to fix mount permissions at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
