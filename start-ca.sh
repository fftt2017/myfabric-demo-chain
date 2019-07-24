#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DIR=$(dirname "$0")
cd $DIR

org0/start.sh

org1/start.sh

org2/start.sh
