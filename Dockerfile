FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd

# Create user and set password
RUN useradd -m -d /home/david/sftp/files -s /usr/sbin/nologin david && \
    echo "david:12345" | chpasswd

# Create chroot structure
RUN mkdir -p /home/david/sftp/files && \
    chown root:root /home/david/sftp && \
    chmod 755 /home/david/sftp && \
    chown david:david /home/david/sftp/files

# Configure SSHD for SFTP-only
RUN echo "Match User david\n\
    ChrootDirectory /home/david/sftp\n\
    ForceCommand internal-sftp\n\
    AllowTcpForwarding no\n\
    X11Forwarding no" >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
