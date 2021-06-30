PEER_ID=$1
NFT_ID=$2

source $(dirname $0)/identity-init.sh $PEER_ID

echo "Peer ID:"
echo $PEER_ID
echo


echo "NFT ID:"
echo $NFT_ID
echo

echo "Owner:"
peer chaincode query -C photolicensing -n token_erc721 -c "{\"function\":\"OwnerOf\",\"Args\":[\"${NFT_ID}\"]}"


