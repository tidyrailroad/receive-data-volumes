FROM alpine:3.4
RUN \
    apk update && \
    apk upgrade && \
    apk add openssh && \
    apk add rsync && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    mkdir -p /var/run/sshd && \
    true
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
