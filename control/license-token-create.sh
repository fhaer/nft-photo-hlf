
AMOUNT=$1
NFT_ID=$2

source $(dirname $0)/identity-init.sh 1

NAME="LICENSE_$NFT_ID"
SYMBOL=$(echo $NAME | cut -c 1-4)
DECIMAL_PLACES=0

if [ "$1" -gt 0 ] && [ "$1" -lt 10000000 ]; then

	echo "NFT ID:"
	echo $NFT_ID
	echo

	echo "Quantity:"
	echo $AMOUNT
	echo

	echo "Token:"
	echo $NAME
	echo

else
        exit
fi


echo "Set NFT ID:"
peer chaincode invoke $TARGET_TLS_OPTIONS -C photolicensing -n token_erc20 -c "{\"function\":\"SetOption\",\"Args\":[\"${NAME}\", \"${SYMBOL}\", \"${DECIMAL_PLACES}\"]}"

echo "Mint Token:"
peer chaincode invoke $TARGET_TLS_OPTIONS -C photolicensing -n token_erc20 -c "{\"function\":\"Mint\",\"Args\":[\"${AMOUNT}\"]}"
