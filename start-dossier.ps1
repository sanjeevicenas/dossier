$pgBin = "$env:LOCALAPPDATA\Programs\pgsql\bin"
$pgData = "$env:LOCALAPPDATA\Programs\pgsql\data"
$env:PATH = "$pgBin;$env:PATH"

# 1. Start PostgreSQL if not already running
$running = Get-Process -Name "*postgres*" -ErrorAction SilentlyContinue
if (!$running) {
    # Clean stale lock file if postgres crashed
    if (Test-Path "$pgData\postmaster.pid") {
        Remove-Item "$pgData\postmaster.pid" -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Starting PostgreSQL database..." -ForegroundColor Cyan
    & "$pgBin\pg_ctl.exe" start -D "$pgData" -l "$pgData\logfile" -w
} else {
    Write-Host "PostgreSQL is already running." -ForegroundColor Cyan
}

# 2. Open browser
Start-Process "http://localhost:3000"

# 3. Start Next.js server
Write-Host "Starting Dossier on http://localhost:3000..." -ForegroundColor Green
npm run dev
