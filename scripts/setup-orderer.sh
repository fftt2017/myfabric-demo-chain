#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

which configtxgen
if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
fi

cp /config/configtx.yaml $FABRIC_CFG_PATH/configtx.yaml

# Note: For some unknown reason (at least for now) the block file can't be
# named orderer.genesis.block or the orderer will fail to launch!
configtxgen -profile DemoOrdererGenesis -outputBlock $GENESIS_BLOCK_FILE -channelID $SYSTEM_CHAIN_ID
if [ "$?" -ne 0 ]; then
    echo "Failed to generate orderer genesis block"
fi
