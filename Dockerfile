FROM alpine:latest

ADD entrypoint.sh /opt/entrypoint.sh
ADD v2ray-linux-64.zip /opt/v2ray-linux-64.zip

RUN apk add -U --no-cache --virtual .build-deps ca-certificates curl wireguard-tools \
 && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
