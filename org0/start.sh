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

#docker-compose -p tianfu-tv up -d

docker-compose up -d
