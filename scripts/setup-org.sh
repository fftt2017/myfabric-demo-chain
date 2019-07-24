#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

sleep 3

CSR_NAMES='C=CN,ST=Si Chuan,L=Cheng Du,O=My Fabric Demo'

mkdir -p $ICA_ADMIN_HOME

export FABRIC_CA_CLIENT_HOME=$ICA_ADMIN_HOME
export FABRIC_CA_CLIENT_TLS_CERTFILES=$ICA_FILE

fabric-ca-client enroll -u https://$ICA_USER_PASS@$ICA_HOST:7054 --csr.names "${CSR_NAMES}"

# handle org admin
fabric-ca-client register -d --id.name $ADMIN_NAME --id.secret $ADMIN_PASS --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" --id.affiliation $ORG

fabric-ca-client enroll -d --enrollment.profile tls -u https://$ADMIN_NAME:$ADMIN_PASS@$ICA_HOST:7054 -M /tmp/tls --csr.names "${CSR_NAMES}"
TLSDIR=$ORG_ADMIN_HOME/tls
mkdir -p $TLSDIR
cp /tmp/tls/keystore/* $TLSDIR/client.key
cp /tmp/tls/signcerts/* $TLSDIR/client.crt
rm -rf /tmp/tls

MSPDIR=$ORG_ADMIN_HOME/msp
mkdir -p $MSPDIR
fabric-ca-client enroll -d -u https://$ADMIN_NAME:$ADMIN_PASS@$ICA_HOST:7054 -M $MSPDIR --csr.names "${CSR_NAMES}"

mkdir $MSPDIR/admincerts
cp $ORG_ADMIN_HOME/msp/signcerts/* $MSPDIR/admincerts

# handle org msp
mkdir -p $ORG_MSP_DIR
fabric-ca-client getcacert -d -u https://$ICA_HOST:7054 -M $ORG_MSP_DIR

mkdir $ORG_MSP_DIR/tlscacerts
cp $ORG_MSP_DIR/cacerts/* $ORG_MSP_DIR/tlscacerts
mkdir $ORG_MSP_DIR/tlsintermediatecerts
cp $ORG_MSP_DIR/intermediatecerts/* $ORG_MSP_DIR/tlsintermediatecerts

mkdir $ORG_MSP_DIR/admincerts
cp $ORG_ADMIN_HOME/msp/signcerts/* $ORG_MSP_DIR/admincerts

# handle org orderer
if [ -n "$ORDERER_HOME" ]; then

    export FABRIC_CA_CLIENT_HOME=$ICA_ADMIN_HOME
    fabric-ca-client register -d --id.name $ORDERER_NAME --id.secret $ORDERER_PASS --id.type orderer --id.affiliation $ORG
    fabric-ca-client enroll -d --enrollment.profile tls -u https://$ORDERER_NAME:$ORDERER_PASS@$ICA_HOST:7054 -M /tmp/tls --csr.hosts $ORDERER_HOST --csr.names "${CSR_NAMES}"
    TLSDIR=$ORDERER_HOME/tls
    mkdir -p $TLSDIR
    cp /tmp/tls/keystore/* $TLSDIR/server.key
    cp /tmp/tls/signcerts/* $TLSDIR/server.crt
    rm -rf /tmp/tls	

    MSPDIR=$ORDERER_HOME/msp
    mkdir -p $MSPDIR
    fabric-ca-client enroll -d -u https://$ORDERER_NAME:$ORDERER_PASS@$ICA_HOST:7054 -M $MSPDIR --csr.names "${CSR_NAMES}"

    mkdir $MSPDIR/tlscacerts
    cp $MSPDIR/cacerts/* $MSPDIR/tlscacerts
    mkdir $MSPDIR/tlsintermediatecerts
    cp $MSPDIR/intermediatecerts/* $MSPDIR/tlsintermediatecerts

    mkdir $MSPDIR/admincerts
    cp $ORG_ADMIN_HOME/msp/signcerts/* $MSPDIR/admincerts

fi

# handle org peer
if [ -n "$PEER_HOMES" ]; then
    PEER_HOME_ARRAY=($PEER_HOMES)
    PEER_NAME_ARRAY=($PEER_NAMES)
    PEER_PASS_ARRAY=($PEER_PASSES)
    PEER_HOST_ARRAY=($PEER_HOSTS)
    PEER_COUNT=${#PEER_HOME_ARRAY[@]}
    echo "peer count: $PEER_COUNT"
    COUNT=0
    while [[ "$COUNT" -lt "$PEER_COUNT" ]]; do
        PEER_HOME="${PEER_HOME_ARRAY[$COUNT]}"
        PEER_NAME="${PEER_NAME_ARRAY[$COUNT]}"
        PEER_PASS="${PEER_PASS_ARRAY[$COUNT]}"
        PEER_HOST="${PEER_HOST_ARRAY[$COUNT]}"
        echo "peer$COUNT: $PEER_HOME,$PEER_NAME,$PEER_PASS,$PEER_HOST"

        export FABRIC_CA_CLIENT_HOME=$ICA_ADMIN_HOME
        fabric-ca-client register -d --id.name $PEER_NAME --id.secret $PEER_PASS --id.type peer --id.affiliation $ORG

        fabric-ca-client enroll -d --enrollment.profile tls -u https://$PEER_NAME:$PEER_PASS@$ICA_HOST:7054 -M /tmp/tls --csr.hosts $PEER_HOST --csr.names "${CSR_NAMES}"
        TLSDIR=$PEER_HOME/tls
        mkdir -p $TLSDIR
        cp /tmp/tls/keystore/* $TLSDIR/server.key
        cp /tmp/tls/signcerts/* $TLSDIR/server.crt
        rm -rf /tmp/tls

        fabric-ca-client enroll -d --enrollment.profile tls -u https://$PEER_NAME:$PEER_PASS@$ICA_HOST:7054 -M /tmp/tls --csr.hosts $PEER_HOST --csr.names "${CSR_NAMES}"
        TLSDIR=$PEER_HOME/tls
        mkdir -p $TLSDIR
        cp /tmp/tls/keystore/* $TLSDIR/client.key
        cp /tmp/tls/signcerts/* $TLSDIR/client.crt
        rm -rf /tmp/tls

        fabric-ca-client enroll -d --enrollment.profile tls -u https://$PEER_NAME:$PEER_PASS@$ICA_HOST:7054 -M /tmp/tls --csr.hosts $PEER_HOST --csr.names "${CSR_NAMES}"
        cp /tmp/tls/keystore/* $TLSDIR/cli-client.key
        cp /tmp/tls/signcerts/* $TLSDIR/cli-client.crt
        rm -rf /tmp/tls

        MSPDIR=$PEER_HOME/msp
        mkdir -p $MSPDIR
        fabric-ca-client enroll -d -u https://$PEER_NAME:$PEER_PASS@$ICA_HOST:7054 -M $MSPDIR --csr.names "${CSR_NAMES}"

        mkdir $MSPDIR/tlscacerts
        cp $MSPDIR/cacerts/* $MSPDIR/tlscacerts
        mkdir $MSPDIR/tlsintermediatecerts
        cp $MSPDIR/intermediatecerts/* $MSPDIR/tlsintermediatecerts

        mkdir $MSPDIR/admincerts
        cp $ORG_ADMIN_HOME/msp/signcerts/* $MSPDIR/admincerts

        COUNT=$((COUNT+1))
    done
fi

# handle org user
if [ -n "$ORG_USER_HOME" ]; then
    export FABRIC_CA_CLIENT_HOME=$ICA_ADMIN_HOME
    fabric-ca-client register -d --id.name $USER_NAME --id.secret $USER_PASS --id.affiliation $ORG
     
    fabric-ca-client enroll -d --enrollment.profile tls -u https://$USER_NAME:$USER_PASS@$ICA_HOST:7054 -M /tmp/tls --csr.names "${CSR_NAMES}"
    TLSDIR=$ORG_USER_HOME/tls
    mkdir -p $TLSDIR
    cp /tmp/tls/keystore/* $TLSDIR/client.key
    cp /tmp/tls/signcerts/* $TLSDIR/client.crt
    rm -rf /tmp/tls

    MSPDIR=$ORG_USER_HOME/msp
    mkdir -p $MSPDIR
    fabric-ca-client enroll -d -u https://$USER_NAME:$USER_PASS@$ICA_HOST:7054 -M $MSPDIR --csr.names "${CSR_NAMES}"

    mkdir -p $MSPDIR/admincerts
    cp $ORG_ADMIN_HOME/msp/signcerts/* $MSPDIR/admincerts
fi

#tail -f /dev/null
