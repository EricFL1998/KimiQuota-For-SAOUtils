# Build script for Kimi Code Quota SAO Utils 2 Extension

$ErrorActionPreference = "Stop"

$extensionName = "kimi-code-quota"
$version = "1.1.0"
$outputFile = "$extensionName-$version.nvg"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Building Kimi Code Quota Extension" -ForegroundColor Cyan
Write-Host "Version: $version" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}

$tempDir = "temp_package"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

Write-Host "Copying files..." -ForegroundColor Green
Copy-Item "package.json" -Destination $tempDir
Copy-Item "README.md" -Destination $tempDir
Copy-Item "preview.png" -Destination $tempDir
Copy-Item -Recurse "qml" -Destination $tempDir
Copy-Item -Recurse "icons" -Destination $tempDir
# Remove SVG files, keep only PNG
Remove-Item "$tempDir\icons\*.svg" -Force
Copy-Item -Recurse "translations" -Destination $tempDir
Copy-Item -Recurse "server" -Destination $tempDir

Write-Host "Creating .NVG package..." -ForegroundColor Green
$tempZip = "$extensionName-$version.zip"
Compress-Archive -Path "$tempDir\*" -DestinationPath $tempZip -Force

if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}
Copy-Item $tempZip $outputFile
Remove-Item $tempZip -Force

Remove-Item $tempDir -Recurse -Force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Build completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Output: $extensionName-$version.nvg" -ForegroundColor Cyan
Write-Host ""
Write-Host "Features:" -ForegroundColor Yellow
Write-Host "  - Fetches from official website" -ForegroundColor White
Write-Host "  - Persistent login (cookies)" -ForegroundColor White
Write-Host "  - Two filling progress bars" -ForegroundColor White
Write-Host "  - Auto-refresh: 10 min (adjustable)" -ForegroundColor White
Write-Host ""
Write-Host "Install: SAO Utils 2 → Preferences → Extensions → [+]" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
