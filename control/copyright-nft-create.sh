
NFT_ID_HEX_UPPER=$(echo $1 | tr a-z A-Z)
URI=$2

source $(dirname $0)/identity-init.sh 1

NFT_ID_DEC=$(echo "ibase=16; $NFT_ID_HEX_UPPER" | BC_LINE_LENGTH=999 bc)
NFT_ID=$(echo "$NFT_ID_DEC / 10^61" | BC_LINE_LENGTH=999 bc)

# note: bash conversion not suitable due to integer overflow
# NFT_ID_DEC=$((16#${1}))

echo "SHA-256:"
echo $NFT_ID_HEX_UPPER
echo

echo "Token ID:"
echo $NFT_ID
echo

echo "URI:"
echo $URI
echo

echo "Result:"

peer chaincode invoke $TARGET_TLS_OPTIONS -C photolicensing -n token_erc721 -c "{\"function\":\"MintWithTokenURI\",\"Args\":[\"${NFT_ID}\", \"${URI}\"]}"

