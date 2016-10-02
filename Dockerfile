FROM alpine:3.4
RUN \
    apk update && \
    apk upgrade && \
    apk add docker && \
    true
ENTRYPOINT \
    docker volume ls -q | while read VOLUME; do [[ ! -d ~/volumes/${VOLUME} ]] && docker volume rm ${VOLUME}; done && \
    ls -1 ~/volumes/ | while read VOLUME; do docker volume create --name ${VOLUME}; done && \
    docker run --interactive --tty --rm --volume ${DOT_SSH}:/root/.ssh:ro $(docker volume ls -q | while read VOLUME; do echo " --volume ${SOURCE}:/source:ro--volume ${VOLUME}:/destination/${VOLUME}:rw "; done) emorymerryman/rsync:1.0.0 --verbose --archive --delete --progress /source/ /destination && \
    true
