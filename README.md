#### server build

# server build image

cd openvpn-record

# ceate server\client's certs

bash cmd/easyrsa-certs-build.sh

# build openvpn server image

bash openvpn-build.sh

# create openvpn-server deployment in kubernetes

kubectl create deployment  openvpn-server --image=openvpn:vx.x.x

# ceate openvpn-server service in kubernetes

kubectl create service nodeport openvpn-server-svc --tcp=1194:1194


#### client build 

# copy certs to client's /etc/openvpn/certs

# copy client.conf to client's /etc/openvpn/

# vim client.conf

remote xx.xx.xx.xx 1194 # server addr

# client connect

nohup openvpn --config /etc/openvpn/client.conf > out.log &