#!/bin/bash
set -e

# สร้าง htpasswd
htpasswd -cb /etc/squid/passwd "$SQUID_USER" "$SQUID_PASSWORD"
chown proxy:proxy /etc/squid/passwd

# สร้าง squid.conf ใหม่
rm -f /etc/squid/squid.conf
touch /etc/squid/squid.conf

# generate http_port จาก START_PORT และ END_PORT
for PORT in $(seq $START_PORT $END_PORT); do
    echo "http_port 0.0.0.0:$PORT" >> /etc/squid/squid.conf
done

# config พื้นฐาน
cat >> /etc/squid/squid.conf <<EOL
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours

acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_access deny all

cache_log /var/log/squid/cache.log
cache_dir ufs /var/spool/squid 100 16 256
EOL

# เริ่ม squid
exec squid -N -d 1
