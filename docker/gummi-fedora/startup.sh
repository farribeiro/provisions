#!/bin/bash

export LANG="pt_BR.UTF-8"

if [ -n "${XAUTHORITY}" ] && [ -n "${HOST_HOSTNAME}" ]
then
  if [ "${HOSTNAME}" != "${HOST_HOSTNAME}" ]
  then
    [ -f ${XAUTHORITY} ] || touch ${XAUTHORITY}
    xauth add ${HOSTNAME}/unix${DISPLAY} . \
    $(xauth -f /tmp/.docker.xauth list ${HOST_HOSTNAME}/unix${DISPLAY} | awk '{ print $NF }')
  else
    cp /tmp/.docker.xauth ${XAUTHORITY}
  fi
fi

gummi
