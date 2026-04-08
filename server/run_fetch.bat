@echo off
REM %1 = Python path
cd /d "%~dp0"
"%~1" fetch_kimi_quota.py quota_output.json
