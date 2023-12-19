#!/bin/bash
TAG=${1:-2.6.7}
WORKDIR=`pwd`

wget https://github.com/OpenVPN/openvpn/releases/download/v${TAG}/openvpn-${TAG}.tar.gz
tar -zxvf openvpn-${TAG}.tar.gz

mkdir -p openvpn-conf
cp -rf certs openvpn-conf/
cp -rf conf/*.conf openvpn-conf/

cat > Dockerfile <<EOF
FROM ubuntu:22.04

COPY openvpn-${TAG} /openvpn
COPY openvpn-conf /etc/openvpn

WORKDIR /openvpn

RUN apt-get update \\
  && apt-get install -y gcc make libnl-3-dev libnl-genl-3-dev libcap-ng-dev \\
  libssl-dev liblz4-dev  liblzo2-dev libpam0g-dev pkg-config \\
    && ./configure \\
      && make \\
        && make install

CMD [ "openvpn", "--config /etc/openvpn/server.conf" ]
EOF

docker build --network host . -t openvpn:2.6.7