@echo off
set "PATH=%LOCALAPPDATA%\Programs\nodejs;%LOCALAPPDATA%\Programs\pgsql\pgsql\bin;%PATH%"

REM Check if PostgreSQL is responding
"%LOCALAPPDATA%\Programs\pgsql\pgsql\bin\pg_isready.exe" -h 127.0.0.1 -p 5432 >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    REM Clean stale postmaster.pid if postgres is not running
    tasklist /fi "imagename eq postgres.exe" 2>nul | find /i "postgres.exe" >nul
    if %ERRORLEVEL% NEQ 0 (
        if exist "%LOCALAPPDATA%\Programs\pgsql\data\postmaster.pid" (
            del "%LOCALAPPDATA%\Programs\pgsql\data\postmaster.pid" /f /q >nul 2>&1
        )
    )
    echo Starting PostgreSQL...
    "%LOCALAPPDATA%\Programs\pgsql\pgsql\bin\pg_ctl.exe" start -D "%LOCALAPPDATA%\Programs\pgsql\data" -l "%LOCALAPPDATA%\Programs\pgsql\data\logfile" -w
)

echo Opening browser at http://localhost:3000 ...
start http://localhost:3000

echo Starting Dossier server...
yarn dev
