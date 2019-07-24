function setEnv {
  if [ $# -ne 3 ]; then
    echo "Usage: setEnv <ORG> <USER> <NUM>"
    exit 1
  fi

  if [ "$3" lt 0 -o "$3" gt 3]; then
    echo "wrong num: $3"
    exit 1
  fi
  
  if [ "$1" = "org1" ]; then
    export CORE_PEER_LOCALMSPID=$ORG1_MSPID
    export CORE_PEER_TLS_ROOTCERT_FILE=$ORG1_TLS_CA
    export CORE_PEER_ADDRESS=peer$3-$ORG1_PEER_HOST:7051
    echo "CORE_PEER_ADDRESS:$CORE_PEER_ADDRESS"

    if [ "$2" = "admin" ]; then
      export CORE_PEER_MSPCONFIGPATH=$ORG1_HOME/admin/msp
      export CORE_PEER_TLS_CLIENTCERT_FILE=$ORG1_HOME/admin/tls/client.crt
      export CORE_PEER_TLS_CLIENTKEY_FILE=$ORG1_HOME/admin/tls/client.key
    elif [ "$2" = "user" ]; then
      export CORE_PEER_MSPCONFIGPATH=$ORG1_HOME/user/msp
      export CORE_PEER_TLS_CLIENTCERT_FILE=$ORG1_HOME/user/tls/client.crt
      export CORE_PEER_TLS_CLIENTKEY_FILE=$ORG1_HOME/user/tls/client.key
    else
      echo "wrong user: $2"
      exit 1
    fi
  elif [ "$1" = "org2" ]; then
    export CORE_PEER_LOCALMSPID=$ORG2_MSPID
    export CORE_PEER_TLS_ROOTCERT_FILE=$ORG2_TLS_CA
    export CORE_PEER_ADDRESS=peer$3-$ORG2_PEER_HOST:7051
    echo "CORE_PEER_ADDRESS:$CORE_PEER_ADDRESS"

    if [ "$2" = "admin" ]; then
      export CORE_PEER_MSPCONFIGPATH=$ORG2_HOME/admin/msp
      export CORE_PEER_TLS_CLIENTCERT_FILE=$ORG2_HOME/admin/tls/client.crt
      export CORE_PEER_TLS_CLIENTKEY_FILE=$ORG2_HOME/admin/tls/client.key
    elif [ "$2" = "user" ]; then
      export CORE_PEER_MSPCONFIGPATH=$ORG2_HOME/user/msp
      export CORE_PEER_TLS_CLIENTCERT_FILE=$ORG2_HOME/user/tls/client.crt
      export CORE_PEER_TLS_CLIENTKEY_FILE=$ORG2_HOME/user/tls/client.key
    else
      echo "wrong user: $2"
      exit 1
    fi
  else
    echo "wrong org: $1"
    exit 1
  fi
}
