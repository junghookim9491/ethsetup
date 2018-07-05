
#!/bin/bash


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -i|--ipaddress)
    IPADDRESS="$2"
    shift # past argument
    shift # past value
    ;;
    -n|--networkid)
    NETWORKID="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi





echo "........Setting up Ethereum Network......."
sudo ifconfig enp0s8 "${IPADDRESS}" netmask 255.255.255.0 up
sudo route add  default gw 192.168.0.1
cd
rm -rf ~/data_testnet
mkdir ~/data_testnet
cd data_testnet/
echo "........Created data_testnet directory......"


touch genesis.json
echo "{
  \"config\": {
    \"chainId\": 33,
    \"homesteadBlock\": 0,
    \"eip155Block\": 0,
    \"eip158Block\": 0
  },
  \"nonce\": \"0x0000000000000033\",
  \"timestamp\": \"0x00\",
  \"parentHash\": \"0x0000000000000000000000000000000000000000000000000000000000000000\",
  \"gasLimit\": \"0x8000000\",
  \"difficulty\": \"0x100\",
  \"mixhash\": \"0x0000000000000000000000000000000000000000000000000000000000000000\",
  \"coinbase\": \"0x3333333333333333333333333333333333333333\",
  \"alloc\": {}
}">> genesis.json
echo "..........Created genesis.json..........."


echo ".......geth init.........."
geth --datadir ~/data_testnet/ init ~/data_testnet/genesis.json

echo ".......setting up network.........."
nohup geth --networkid "${NETWORKID}" --nodiscover --datadir /home/user01/data_testnet --rpc  --rpcaddr "0.0.0.0" --rpcport 8545  --rpccorsdomain "*" --rpcapi "admin,db,eth,miner,net,personal,web3" --verbosity 6  2>> /home/user01/data_testnet/geth.log &





