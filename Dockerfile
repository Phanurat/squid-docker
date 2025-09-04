FROM squid:latest

# ติดตั้ง apache2-utils สำหรับ htpasswd
RUN apt-get update && apt-get install -y apache2-utils

# คัดลอกไฟล์ config และ entrypoint
COPY squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# expose ports range (15000-15200)
EXPOSE 15000-15200

# ใช้ entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
