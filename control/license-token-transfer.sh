export FABRIC_CFG_PATH=$PWD/config/
export CORE_PEER_TLS_ENABLED=true

cd network

AMOUNT=$1

if [ "$1" -gt 0 ] && [ "$1" -lt 10000000 ]; then
	echo "Quantity:"
	echo $AMOUNT
	echo
else
        exit
fi

if [ "$2" -gt 0 ] && [ "$2" -lt 100 ]; then
	S_ORG_NAME=org$2
	S_ORG_ID=$S_ORG_NAME.example.com
	S_PEER_ID=peer0.$S_ORG_ID
	S_MSP_ID=Org$2MSP
	S_CA_NAME=ca-org$2
	S_CA_DIR=org$2
	S_HOST=localhost
        if [ "$2" -eq 1 ]; then
         S_NAME=minter
         S_USER=minter@$S_ORG_ID
         S_PORT=7051
        else
         S_PORT=9051
         S_NAME=recipient
         S_USER=recipient@$S_ORG_ID
        fi
else
        exit
fi

if [ "$3" -gt 0 ] && [ "$3" -lt 100 ]; then
        R_ORG_NAME=org$3
        R_ORG_ID=$R_ORG_NAME.example.com
        R_PEER_ID=peer0.$R_ORG_ID
        R_MSP_ID=Org$3MSP
        R_CA_NAME=ca-org$3
        R_CA_DIR=org$3
        R_HOST=localhost
	if [ "$3" -eq 1 ]; then
         R_NAME=minter
         R_USER=minter@$R_ORG_ID
         R_PORT=7051
        else
         R_PORT=9051
         R_NAME=recipient
         R_USER=recipient@$R_ORG_ID
        fi
else
        exit
fi

export CORE_PEER_LOCALMSPID=$R_MSP_ID
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/$R_ORG_ID/peers/$R_PEER_ID/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/$R_ORG_ID/users/$R_USER/msp
export CORE_PEER_ADDRESS=$R_HOST:$R_PORT

R_ORG_ACC_ID=$(peer chaincode query -C photolicensing -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}')
echo $R_ORG_ACC_ID > acc_id_r.txt

export CORE_PEER_LOCALMSPID=$S_MSP_ID
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/$S_ORG_ID/peers/$S_PEER_ID/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/$S_ORG_ID/users/$S_USER/msp
export CORE_PEER_ADDRESS=$S_HOST:$S_PORT

S_ORG_ACC_ID=$(peer chaincode query -C photolicensing -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}')
echo $S_ORG_ACC_ID > acc_id_s.txt

TARGET_TLS_OPTIONS="-o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"


echo "Sender:"
echo $S_ORG_ACC_ID
echo
echo "Receiver:"
echo $R_ORG_ACC_ID
echo

echo "Transfer:"
peer chaincode invoke $TARGET_TLS_OPTIONS -C photolicensing -n token_erc20  -c "{\"function\":\"Transfer\",\"Args\":[\"${R_ORG_ACC_ID}\",\"${AMOUNT}\"]}"

#peer chaincode invoke "${TARGET_TLS_OPTIONS[@]}" -C mychannel -n token_erc20 -c '{"function":"Transfer","Args":[ "'"$RECIPIENT"'","100"]}'
