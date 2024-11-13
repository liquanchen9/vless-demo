#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"
SCRIPT_DIR="$(dirname "$0")"

if [ "${ID}" = "" ]; then
export ID="$1"
fi
echo "ID:  ${ID}"
if [ "$WSPATH" = "" ]; then
export WSPATH="$2"
fi
echo "WSPATH:  ${WSPATH}"

# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/heroku.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "${ID}"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# cat ${DIR_TMP}/heroku.json

# Get V2Ray executable release
# curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
# busybox unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}
busybox unzip ${SCRIPT_DIR}/v2ray-linux-64.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
# ${DIR_TMP}/v2ctl config ${DIR_TMP}/heroku.json > ${DIR_CONFIG}/config.pb
cp -f ${DIR_TMP}/heroku.json  ${DIR_CONFIG}/config.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

if [ "${WG_ENDPOINT}" = "" ]; then
  echo "ignore wireguard"
else
  cat << EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = qN70k6q4HOPXpwDFT+tUsUrvxcR4iIrfaDe1D0VWpmU=
Address = 192.168.99.249/32
# Interface PublicKey k+cIyrGcgsgq5PbUlTZEZVER2O19vwza4Wc/u9r1y3E=
[Peer]
PublicKey = /gwzvJbtHHeXLKjoUe4XfJD014RlrnVPgf0PFsz0vhE=
AllowedIPs = 192.168.99.0/24
PersistentKeepalive = 25
Endpoint = ${WG_ENDPOINT}:55825
EOF
# whereis ip
# ls -l /usr/sbin/ip
# 开启 wg
wg-quick up wg0
# 不交互下 不会进行联通。。。这坑啊
ping 192.168.99.1 -c 1
fi

# Run V2Ray
# ${DIR_RUNTIME}/v2ray -config=${DIR_CONFIG}/config.pb
cat ${DIR_CONFIG}/config.json
${DIR_RUNTIME}/v2ray run --config=${DIR_CONFIG}/config.json
# docker run  --cap-add=NET_ADMIN -e PORT=8080  -e ID=7b01ffb3-ade8-4e26-808a-032c86f8d67e -e WSPATH=1ws -e