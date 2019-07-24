#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

sleep 2

source $(dirname "$0")/base.sh

setEnv "org1" "admin" 1
peer channel create -c $CHANNEL_ID -f $CHANNEL_TX_FILE -o $ORDERER_HOST:7050 --tls --cafile $ORDERER_TLS_CA --clientauth --keyfile $CORE_PEER_TLS_CLIENTKEY_FILE --certfile $CORE_PEER_TLS_CLIENTCERT_FILE
peer channel join -b $CHANNEL_ID.block 

setEnv "org1" "admin" 2
peer channel join -b $CHANNEL_ID.block

setEnv "org2" "admin" 1
peer channel join -b $CHANNEL_ID.block

setEnv "org2" "admin" 2
peer channel join -b $CHANNEL_ID.block

setEnv "org1" "admin" 1
peer channel update -c $CHANNEL_ID -f $ORG1_ANCHOR_TX_FILE -o $ORDERER_HOST:7050 --tls --cafile $ORDERER_TLS_CA --clientauth --keyfile $CORE_PEER_TLS_CLIENTKEY_FILE --certfile $CORE_PEER_TLS_CLIENTCERT_FILE

setEnv "org2" "admin" 1
peer channel update -c $CHANNEL_ID -f $ORG2_ANCHOR_TX_FILE -o $ORDERER_HOST:7050 --tls --cafile $ORDERER_TLS_CA --clientauth --keyfile $CORE_PEER_TLS_CLIENTKEY_FILE --certfile $CORE_PEER_TLS_CLIENTCERT_FILE

setEnv "org1" "admin" 1
peer chaincode install -n mycc -v 1.0 -p abac/go
peer chaincode instantiate -C $CHANNEL_ID -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR('org1MSP.member','org2MSP.member')" -o $ORDERER_HOST:7050 --tls --cafile $ORDERER_TLS_CA --clientauth --keyfile $CORE_PEER_TLS_CLIENTKEY_FILE --certfile $CORE_PEER_TLS_CLIENTCERT_FILE

sleep 10

setEnv "org1" "user" 1
peer chaincode query -C $CHANNEL_ID -n mycc -c '{"Args":["query","a"]}'

sleep 1

setEnv "org2" "admin" 1
peer chaincode install -n mycc -v 1.0 -p abac/go

setEnv "org1" "user" 1
peer chaincode invoke -C $CHANNEL_ID -n mycc -c '{"Args":["invoke","a","b","10"]}' -o $ORDERER_HOST:7050 --tls --cafile $ORDERER_TLS_CA --clientauth --keyfile $CORE_PEER_TLS_CLIENTKEY_FILE --certfile $CORE_PEER_TLS_CLIENTCERT_FILE
sleep 2
peer chaincode query -C $CHANNEL_ID -n mycc -c '{"Args":["query","a"]}'




