
PEER_ID=$1

source $(dirname $0)/identity-init.sh $PEER_ID


echo "Token Name:"
peer chaincode query -C photolicensing -n token_erc20 -c '{"function":"TokenName","Args":[]}'
echo


echo "Peer ID:"
echo $PEER_ID
echo

echo "Number of Licenses:"
peer chaincode query -C photolicensing -n token_erc20 -c '{"function":"ClientAccountBalance","Args":[]}'


