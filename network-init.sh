# Setup
export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

# Bring up test network
cd network
#./network.sh down
./network.sh up -ca

docker ps -a

# Create and join channel
./network.sh createChannel -c photolicensing -ca

# Deploy chain code
# - channel photolicensing
# - chain code directories copyright-nft-erc-721 and license-token-erc-20
# - chain code language javascript
./network.sh deployCC -c photolicensing -ccn token_erc721 -ccp ../copyright-nft-erc-721/chaincode-javascript/ -ccl javascript
./network.sh deployCC -c photolicensing -ccn token_erc20 -ccp ../license-token-erc-20/chaincode-javascript/ -ccl javascript

