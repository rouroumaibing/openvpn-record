#!/bin/bash
TAG=${1:-3.1.7}
WORKDIR=`pwd`
SERVERNAME=${1:-openvpn-server}
CLIENTNAME=${2:-openvpn-client}

mkdir -p easyrsa-certs;cd easyrsa-certs
wget https://github.com/OpenVPN/easy-rsa/archive/refs/tags/v${TAG}.tar.gz
tar -zxvf v${TAG}.tar.gz
mv easy-rsa-${TAG} easy-rsa
cd easy-rsa/easyrsa3

./easyrsa init-pki
echo | ./easyrsa build-ca nopass
echo yes | ./easyrsa build-server-full ${SERVERNAME} nopass
echo yes | ./easyrsa build-client-full ${CLIENTNAME} nopass
./easyrsa gen-dh

mkdir -p certs
cp -rf  pki/ca.crt certs/
cp -rf  pki/dh.pem certs/
cp -rf  pki/issued/${SERVERNAME}.crt certs/
cp -rf  pki/issued/${CLIENTNAME}.crt certs/
cp -rf  pki/private/ca.key certs/
cp -rf  pki/private/${SERVERNAME}.key certs/
cp -rf  pki/private/${CLIENTNAME}.key certs/

cp -rf certs ${WORKDIR}