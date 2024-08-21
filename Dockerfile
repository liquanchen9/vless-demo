FROM alpine:latest

ADD entrypoint.sh /opt/entrypoint.sh
ADD v2ray-linux-64.zip /opt/v2ray-linux-64.zip

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
