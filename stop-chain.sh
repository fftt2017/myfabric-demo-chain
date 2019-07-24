#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

#set -e

DIR=$(dirname "$0")
cd $DIR

peer-cli/stop.sh

org2-peer/stop.sh

org1-peer/stop.sh

org0-orderer/stop.sh

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
#docker image rm $(docker image list | grep dev-* | awk '{print $1}')

