$nodeDir = "$env:LOCALAPPDATA\Programs\nodejs"
$pgBin = "$env:LOCALAPPDATA\Programs\pgsql\pgsql\bin"
$pgData = "$env:LOCALAPPDATA\Programs\pgsql\data"
$env:PATH = "$nodeDir;$pgBin;$env:PATH"

# 1. Start PostgreSQL if not already running
& "$pgBin\pg_isready.exe" -h 127.0.0.1 -p 5432 2>$null
if ($LASTEXITCODE -ne 0) {
    # Clean stale lock file if postgres crashed
    if (Test-Path "$pgData\postmaster.pid") {
        $running = Get-Process -Name "*postgres*" -ErrorAction SilentlyContinue
        if (!$running) {
            Remove-Item "$pgData\postmaster.pid" -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "Starting PostgreSQL database..." -ForegroundColor Cyan
    & "$pgBin\pg_ctl.exe" start -D "$pgData" -l "$pgData\logfile" -w
}

# 2. Open browser
Start-Process "http://localhost:3000"

# 3. Start Next.js server
Write-Host "Starting Dossier on http://localhost:3000..." -ForegroundColor Green
yarn dev
