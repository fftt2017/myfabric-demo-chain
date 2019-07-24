#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

#tail -f /dev/null

cp -r $PEER_HOME/* /opt/gopath/src/github.com/hyperledger/fabric/peer/

env | grep CORE
peer node start
