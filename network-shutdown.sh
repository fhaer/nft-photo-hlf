
cd network

# shutdown the network
./network.sh down


# remove docker images
#docker rm -f $(docker ps -aq)
#docker rmi -f $(docker images -q)

