FROM ghcr.io/home-assistant/amd64-base:3.19

RUN apk add --no-cache bash iptables curl

RUN curl -fsSL -o /usr/local/bin/amneziawg-go \
    "https://github.com/amnezia-vpn/amneziawg-go/releases/download/v0.2.12/amneziawg-go-v0.2.12-linux-amd64" && \
    chmod +x /usr/local/bin/amneziawg-go

COPY run.sh /
RUN chmod +x /run.sh

CMD ["/run.sh"]
