# Installation Guide

## Quick Install

### Option 1: Using the Build Script (Recommended)

1. Open PowerShell in the extension directory
2. Run the build script:
   ```powershell
   .\build.ps1
   ```
3. This will create `kimi-code-quota-1.0.0.nvg`
4. Open SAO Utils 2 → Preferences → Extensions → Click `[+]` → Select the .nvg file

### Option 2: Manual ZIP

1. Select all files in the `kimi-code-quota` folder
2. Create a ZIP archive
3. Rename the `.zip` to `.nvg`
4. Install via SAO Utils 2 Extension Manager

### Option 3: Direct Copy (Development)

1. Copy the entire `kimi-code-quota` folder
2. Navigate to your SAO Utils 2 installation:
   - Steam: `Steam\steamapps\common\SAO Utils 2\Packages\`
   - Portable: `[SAO Utils 2 folder]\Packages\`
3. Paste the folder here
4. Restart SAO Utils 2

## Verifying Installation

After installation:
1. Right-click on desktop
2. Select `Widgets` → `Widget Gallery`
3. Look for "Kimi Code Quota"
4. Click to add to desktop

## Configuration

### Kimi Code API Setup

The widget communicates with Kimi Code's local API. Ensure:

1. Kimi Code is running
2. Local API is enabled (usually on port 41115)
3. Firewall allows localhost connections

### Customizing the Widget

Right-click the widget → `Settings...` to:
- Change refresh interval
- Toggle quota displays
- Set custom API endpoint
- Test the connection

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Widget not in gallery | Restart SAO Utils 2 |
| "Connection failed" | Check Kimi Code is running |
| "API Error" | Verify API endpoint URL |
| No data displayed | Check Kimi Code settings |

## Uninstallation

1. Right-click widget → `Remove`
2. Go to Preferences → Extensions
3. Select "Kimi Code Quota"
4. Click `[-]` or `Remove`
