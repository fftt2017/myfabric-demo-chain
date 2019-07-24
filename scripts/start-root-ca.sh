#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

mkdir -p $FABRIC_CA_SERVER_HOME

cd $FABRIC_CA_SERVER_HOME

cp /config/rca-fabric-ca-server-config.yaml $FABRIC_CA_SERVER_HOME/fabric-ca-server-config.yaml

fabric-ca-server init

cp $FABRIC_CA_SERVER_HOME/ca-cert.pem $TARGET_CERTFILE

fabric-ca-server start

#tail -f /dev/null
