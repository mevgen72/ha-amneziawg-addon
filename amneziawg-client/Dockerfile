FROM metaligh/amneziawg:latest

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY run.sh /
RUN chmod +x /run.sh

CMD ["/run.sh"]
