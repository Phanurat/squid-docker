import requests

# List of ports ของ Squid proxy
ports = list(range(15000, 15201))  # 3128–3140

# Username/password สำหรับ proxy
username = "phanurat"
password = "1111"
ip = "192.168.1.152"

# Target HTTPS URL
url = "https://www.facebook.com/"

for port in ports:
    proxy_url = f"http://{username}:{password}@{ip}:{port}"
    proxies = {
        "http": proxy_url,
        "https": proxy_url
    }
    print(f"Checking proxy {proxy_url} ...")
    try:
        response = requests.get(url, proxies=proxies, timeout=10)
        print(f"[SUCCESS] Port {port} -> Status: {response.status_code}, Content length: {len(response.content)}\n")
    except requests.exceptions.ProxyError as e:
        print(f"[PROXY ERROR] Port {port} -> {e}\n")
    except requests.exceptions.SSLError as e:
        print(f"[SSL ERROR] Port {port} -> {e}\n")
    except Exception as e:
        print(f"[OTHER ERROR] Port {port} -> {e}\n")
