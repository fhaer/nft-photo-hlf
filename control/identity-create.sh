
ID=$1

source $(dirname $0)/identity-init.sh $ID

echo "Peer ID:"
echo $PEER_ID
echo

echo "Register and enroll peer:"
fabric-ca-client register --caname $CA_NAME --id.name $NAME --id.secret $SEC --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/$CA_DIR/tls-cert.pem
echo
fabric-ca-client enroll -u https://$NAME:$SEC@$CA_HOST:$CA_PORT --caname $CA_NAME -M ${PWD}/organizations/peerOrganizations/$ORG_ID/users/$USER/msp --tls.certfiles ${PWD}/organizations/fabric-ca/$CA_DIR/tls-cert.pem
cp ${PWD}/organizations/peerOrganizations/$ORG_ID/msp/config.yaml ${PWD}/organizations/peerOrganizations/$ORG_ID/users/$USER/msp/config.yaml

