# Multi-Instance Squid Proxy Docker

นี่คือโปรเจคสำหรับรัน **หลาย instance ของ Squid Proxy** บน Docker พร้อม **Basic Authentication**  
สามารถตั้งค่า range ของพอร์ตแต่ละ instance ได้ตามต้องการ

---

## 💡 Features

- รัน **หลาย instance** (ตัวอย่าง 2 instance, ขยายได้ถึง 20 instance)  
- แต่ละ instance ใช้ **range ของ HTTP port** แยกกัน  
- ใช้งาน **Basic Authentication** (username/password จาก `.env`)  
- รองรับ **dynamic configuration** ผ่าน `entrypoint.sh`  
- สามารถตรวจสอบ proxy ด้วย script หรือ curl  

---

## 📁 Project Structure

squid-docker/
├── Dockerfile # Dockerfile สำหรับสร้าง Squid image
├── entrypoint.sh # Script เริ่ม Squid, สร้าง squid.conf dynamic
├── squid.conf # Template squid.conf (ถ้าจำเป็น)
├── .env # กำหนด SQUID_USER, SQUID_PASSWORD, START_PORT, END_PORT
├── docker-compose.yml # Compose file สำหรับรันหลาย instance
└── check_proxy.sh # Script ตรวจสอบ proxy (Linux/Mac)


---

## ⚙️ Environment Variables (.env)

```dotenv
# Username/Password
SQUID_USER=phanurat
SQUID_PASSWORD=1111

# Instance Port Range (ตัวอย่าง squid1)
START_PORT=15000
END_PORT=15100

# สำหรับ instance อื่นๆ สามารถเพิ่ม .env แยกหรือ generate dynamic


---

## ⚙️ Environment Variables (.env)

```dotenv
# Username/Password
SQUID_USER=phanurat
SQUID_PASSWORD=1111

# Instance Port Range (ตัวอย่าง squid1)
START_PORT=15000
END_PORT=15100

# สำหรับ instance อื่นๆ สามารถเพิ่ม .env แยกหรือ generate dynamic


version: '3.9'
services:
  squid1:
    build: .
    container_name: squid1
    env_file:
      - instance1.env
    ports:
      - "15000-15100:15000-15100"

  squid2:
    build: .
    container_name: squid2
    env_file:
      - instance2.env
    ports:
      - "15101-15200:15101-15200"

```sh
docker compose build
docker compose up -d
```

```sh
docker compose logs -f squid1
docker compose logs -f squid2
```

```sh
curl -x http://phanurat:1111@127.0.0.1:15000 http://example.com
curl -x http://phanurat:1111@127.0.0.1:15101 http://example.com
```