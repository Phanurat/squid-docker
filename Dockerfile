FROM ubuntu:22.04

# ติดตั้ง squid และ apache2-utils
RUN apt-get update && \
    apt-get install -y squid apache2-utils && \
    apt-get clean

# คัดลอก entrypoint และ config
COPY squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 15000-15200

ENTRYPOINT ["/entrypoint.sh"]
