#!/bin/bash 


ZSTATUS='/sbin/zpool status'

if [[ $(echo $ZSTATUS | -ic -e "degraded" -e "fault") -ne 0  ]]; then 
  echo -e "ZPOOL problem!"
fi
