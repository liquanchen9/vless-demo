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

# Get V2Ray executable release
# curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
#  unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}
unzip ${SCRIPT_DIR}/v2ray-linux-64.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
# ${DIR_TMP}/v2ctl config ${DIR_TMP}/heroku.json > ${DIR_CONFIG}/config.pb
cp -f ${DIR_TMP}/heroku.json  ${DIR_CONFIG}/config.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
# ${DIR_RUNTIME}/v2ray -config=${DIR_CONFIG}/config.pb
cat ${DIR_CONFIG}/config.json
nohup  ${DIR_RUNTIME}/v2ray run --config=${DIR_CONFIG}/config.json 2>&1  &

/usr/local/bin/cpolar authtoken MjcyZjRlYWEtMjBlNS00NjgzLThlMTUtNDU2OWFmMzU0MWYy

/usr/local/bin/cpolar start-all -dashboard=on -daemon=on -config=/usr/local/etc/cpolar/cpolar.yml -log=stdout

