#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DIR=$(dirname "$0")
cd $DIR

sudo rm -rf ./data/*

if $(docker network list | grep -q myfabric-network);then
  echo 'myfabric-network exists'
else
  echo 'create docker network myfabric-network'
  docker network create myfabric-network
fi

#docker-compose -p tianfu-tv up -d

docker-compose up -d
