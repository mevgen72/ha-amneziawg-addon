FROM metaligh/amneziawg:latest

RUN apk add --no-cache bash curl

COPY run.sh /
RUN chmod +x /run.sh

CMD ["/run.sh"]
