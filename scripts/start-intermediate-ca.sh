#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

#sleep 5

mkdir -p $FABRIC_CA_SERVER_HOME

cd $FABRIC_CA_SERVER_HOME

cp /config/ica-fabric-ca-server-config.yaml $FABRIC_CA_SERVER_HOME/fabric-ca-server-config.yaml

fabric-ca-server init -u $PARENT_URL

cp $FABRIC_CA_SERVER_HOME/ca-chain.pem $TARGET_CHAINFILE

fabric-ca-server start

#tail -f /dev/null
