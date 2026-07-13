FROM metaligh/amneziawg:latest

# Образ на Debian/Ubuntu, не Alpine — apk не работает!
# Проверим и установим curl если нужно
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY run.sh /
RUN chmod +x /run.sh

CMD ["/run.sh"]
