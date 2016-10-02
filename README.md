Receives docker data volumes

# Introduction

This is designed to be used in conjuction with <https://github.com/tidyrailroad/send-data-volumes>.

The send-data-volumes program is run on the computer with the source data volumes and transfers them to another (destination)
computer.
The receive-data-volumes program can be run on the destination computer to put the received files into data volumes.

It will
1) delete data volumes that have been deleted on the source
2) create data volumes that have been created on the source
3) synchronize the content

# Recommended Usage

1) The SOURCE is a directory that contains subdirectories.
   Each subdirectory corresponds to a data volume.
   The name of the subdirectory is the name of the data volume.
   The contents of the subdirectory are the contents of the data volume.

2) Necessary for docker outside of docker (dood)  <http://container-solutions.com/running-docker-in-jenkins-in-docker/>
   1) The `--privileged` switch is mandatory.
      You will want to exercise caution with that because this switch gives the container root privileges on your machine.
   2) `--volume /var/run/docker.sock:/var/run/docker.sock` is mandatory.
      This container is actually using the host docker.
      The containers it creates (3), are properly sibling - not child - containers.

`docker run --interactive --tty --rm --env SOURCE=${PWD}/volumes --privileged --volume /var/run/docker.sock:/var/run/docker.sock:ro emorymerryman/receive-data-volumes:0.0.6`

# Discussion
  The only parameter that you must specify is SOURCE.
  This is because the container uses dood to figure out everything else by itself.

  1) It figures out which volumes do not have a corresponding subdirectory in ${SOURCE} and then it deletes those volumes.
  2) It creates volumes for all the subdirectories in ${SOURCE}
  3) It uses rsync to push the data in ${SOURCE} into the data volumes.

## Caution

  1) Because it deletes all volumes that do not correspond to subdirectories in ${SOURCE}, it should only be used when the
     docker is not otherwise being used.
     If there are any docker processes running, it will delete their volumes and get confused.
     * BEST PRACTICE * Stop all processes and restart the docker daemon before running this container.
  2) I have tested this.
     I would like to mount things RO.
     However when I do that, I do not have permission to read the content.
     When I mount things RW, I can verify the content.
     I am not sure about this.