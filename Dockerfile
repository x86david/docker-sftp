FROM docker.io/library/debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    mkdir -p /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# Hardcode security policies safely inside the global configuration file
RUN mkdir -p /sftp && \
    echo "Match Group david,1000,sftp\n\
    ChrootDirectory /sftp\n\
    ForceCommand internal-sftp\n\
    AllowTcpForwarding no\n\
    X11Forwarding no" >> /etc/ssh/sshd_config

# Import and hook the dynamic initialization sequence
COPY entrypoint.sh /entrypoint.sh
EXPOSE 22

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
