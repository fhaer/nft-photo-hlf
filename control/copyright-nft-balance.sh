
PEER_ID=$1

source $(dirname $0)/identity-init.sh $PEER_ID

echo "Peer ID:"
echo $PEER_ID
echo



if [ "$1" == "1" ]; then
        export CORE_PEER_LOCALMSPID="Org1MSP"
        export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/minter@org1.example.com/msp
        export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        export CORE_PEER_ADDRESS=localhost:7051
else
        export CORE_PEER_LOCALMSPID="Org2MSP"
        export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/recipient@org2.example.com/msp
        export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        export CORE_PEER_ADDRESS=localhost:9051
fi

echo "Token balance:"
peer chaincode query -C photolicensing -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'

