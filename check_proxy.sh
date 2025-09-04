# Check-Proxy.ps1
# ตรวจสอบ Squid proxy range port บน Windows

# โหลดค่าจากไฟล์ .env
$envFile = ".env"
if (!(Test-Path $envFile)) {
    Write-Host ".env file not found!"
    exit
}

# อ่าน .env และ export เป็น environment variable
Get-Content $envFile | ForEach-Object {
    if ($_ -match "^\s*#") { return }
    if ($_ -match "=") {
        $parts = $_ -split "="
        $name = $parts[0].Trim()
        $value = $parts[1].Trim()
        Set-Item -Path "Env:$name" -Value $value
    }
}

# ตรวจสอบตัวแปร
if (-not $Env:START_PORT -or -not $Env:END_PORT -or -not $Env:SQUID_USER -or -not $Env:SQUID_PASSWORD) {
    Write-Host "Please set START_PORT, END_PORT, SQUID_USER, SQUID_PASSWORD in .env"
    exit
}

$testUrl = "http://example.com"

Write-Host "Checking proxy from port $($Env:START_PORT) to $($Env:END_PORT)..."
Write-Host "Username: $($Env:SQUID_USER), Password: $($Env:SQUID_PASSWORD)"
Write-Host ""

for ($port = [int]$Env:START_PORT; $port -le [int]$Env:END_PORT; $port++) {
    try {
        $response = Invoke-WebRequest -Uri $testUrl -Proxy "http://192.168.1.152:$port" -ProxyCredential (New-Object System.Management.Automation.PSCredential($Env:SQUID_USER, (ConvertTo-SecureString $Env:SQUID_PASSWORD -AsPlainText -Force))) -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "Port $port: OK ✅"
        } else {
            Write-Host "Port $port: FAIL ❌ (HTTP $($response.StatusCode))"
        }
    } catch {
        Write-Host "Port $port: FAIL ❌ ($($_.Exception.Message))"
    }
}
