FROM alpine:3.4
RUN \
    apk update && \
    apk upgrade && \
    apk add docker && \
    true
ENTRYPOINT \
    docker volume ls -q | while read VOLUME; do [[ ! -d /source/${VOLUME} ]] && docker volume rm ${VOLUME}; done && \
    ls -1 /source | while read VOLUME; do docker volume create --name ${VOLUME}; done && \
    docker run --interactive --tty --rm --volume ${SOURCE}:/source:ro $(docker volume ls -q | while read VOLUME; do echo " --volume ${VOLUME}:/destination:rw "; done) emorymerryman/rsync:1.0.0 --verbose --archive --delete --progress /source/ /destination && \
    true
