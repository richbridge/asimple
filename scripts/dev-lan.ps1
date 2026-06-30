# LAN preview for mobile devices (bind 0.0.0.0)
$ErrorActionPreference = "Stop"

$ip = Get-NetIPConfiguration |
  Where-Object {
    $_.IPv4DefaultGateway -and
    $_.NetAdapter.Status -eq "Up" -and
    $_.InterfaceAlias -notmatch "vEthernet|VMware|VirtualBox|WSL|Loopback|TAP"
  } |
  ForEach-Object { $_.IPv4Address.IPAddress } |
  Select-Object -First 1

if (-not $ip) {
  Write-Host "[dev-lan] No LAN IP found. Check Wi-Fi/Ethernet." -ForegroundColor Red
  exit 1
}

$baseURL = "http://${ip}:1313/"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host ""
Write-Host "[dev-lan] Open on phone:" -ForegroundColor Green
Write-Host "  $baseURL" -ForegroundColor Cyan
Write-Host ""
Write-Host "[dev-lan] Use the IP above, not localhost." -ForegroundColor Yellow
Write-Host "[dev-lan] Allow port 1313 in Windows Firewall if blocked." -ForegroundColor Yellow
Write-Host ""

Set-Location $root
hugo server -D --bind 0.0.0.0 --baseURL $baseURL --disableFastRender
