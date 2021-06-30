
NFT_ID_HEX=$(sha256sum -z "$1" | awk '{print $1}')
echo $NFT_ID_HEX

#NFT_ID=$((16#${NFT_ID_HEX}))
#echo $NFT_ID
