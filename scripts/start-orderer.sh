#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

sleep 2

cp -r /orgs/org0/data/orderer/ /etc/hyperledger/

#tail -f /dev/null

# Start the orderer
env | grep ORDERER
orderer
