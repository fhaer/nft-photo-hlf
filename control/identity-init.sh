export FABRIC_CFG_PATH=$PWD/config/
export CORE_PEER_TLS_ENABLED=true

ID=$1

cd network

if [ "$1" -gt 0 ] && [ "$1" -lt 100 ]; then
        ORG_NAME=org$ID
        ORG_ID=$ORG_NAME.example.com
        PEER_ID=peer0.$ORG_ID
        MSP_ID=Org${ID}MSP
        CA_NAME=ca-org$ID
        CA_DIR=org$ID
        HOST=localhost
        CA_HOST=$HOST
        if [ "$ID" -eq 1 ]; then
         NAME=minter
         USER=minter@$ORG_ID
         MSP_USER=$USER
         SEC=3286542e2b
         PORT=7051
         CA_PORT=7054
        else
         NAME=recipient
         USER=recipient@$ORG_ID
         MSP_USER=recipient@$ORG_ID
         SEC=30a6e62824
         PORT=9051
         CA_PORT=8054
        fi
else
        exit
fi

export CORE_PEER_LOCALMSPID=$MSP_ID
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/$ORG_ID/peers/$PEER_ID/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/$ORG_ID/users/$MSP_USER/msp
export CORE_PEER_ADDRESS=$HOST:$PORT

export TARGET_TLS_OPTIONS="-o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/$ORG_ID/

