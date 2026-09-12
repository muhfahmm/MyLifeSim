# Script untuk menjalankan Flutter Web pada port 3100 & membuka browser default sistem (seperti Next.js / Vite)
Param(
    [int]$Port = 3100
)

$Url = "http://localhost:$Port"

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " 🚀 MyLifeSim Web Server Development Mode" -ForegroundColor Green
Write-Host " 🌐 Local URL: $Url" -ForegroundColor Yellow
Write-Host " 🌐 (Browser default sistem akan otomatis dibuka)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Membuka browser default secara otomatis setelah server Flutter siap
Start-Job -ScriptBlock {
    param($targetUrl)
    Start-Sleep -Seconds 4
    Start-Process $targetUrl
} -ArgumentList $Url | Out-Null

# Jalankan Flutter Web Server
flutter run -d web-server --web-port=$Port
