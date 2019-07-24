#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DIR=$(dirname "$0")
cd $DIR

org0-orderer/start.sh

org1-peer/start.sh

org2-peer/start.sh

peer-cli/start.sh
