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
configtxgen -profile DemoChannel -outputCreateChannelTx $CHANNEL_TX_FILE -channelID $APP_CHAIN_ID
if [ "$?" -ne 0 ]; then
    echo "Failed to generate orderer genesis block"
fi

ORG_ARRAY=($ORGS)
ANCHOR_TF_ARRAY=($ANCHOR_TX_FILES)
ORG_COUNT=${#ORG_ARRAY[@]}
echo "org count: $ORG_COUNT"
COUNT=0
while [[ "$COUNT" -lt "$ORG_COUNT" ]]; do
    ORG="${ORG_ARRAY[$COUNT]}"
    ANCHOR_TF="${ANCHOR_TF_ARRAY[$COUNT]}"
    echo "$COUNT: $ORG,$ANCHOR_TF"

    configtxgen -profile DemoChannel -outputAnchorPeersUpdate $ANCHOR_TF -channelID $APP_CHAIN_ID -asOrg $ORG

    COUNT=$((COUNT+1))
done
