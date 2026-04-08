# AGENTS.md - Kimi Code Quota Extension for SAO Utils 2

## Project Overview

This is a **SAO Utils 2** desktop widget (挂件) that displays Kimi Code usage quota information. It shows:
- Weekly usage percentage with progress bar
- Rate limit percentage with progress bar
- Time until reset for both quotas
- Status indicator (green/amber/red)

The widget uses Kimi's official API (`https://api.kimi.com/coding/v1/usages`) to fetch quota data. It reads authentication tokens from Kimi CLI's credential storage (`~/.kimi/credentials/kimi-code.json`).

**Package ID**: `com.ericfl.imicode.quota`  
**Version**: 1.2.0 (package.json), build script generates 1.1.0  
**License**: Not specified  
**Homepage**: https://github.com/EricFL1998/KimiQuota-For-SAOUtils


## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Widget UI** | Qt Quick (QML) 2.12 | Desktop widget interface |
| **Framework** | NERvGear/SAO Utils 2 | Extension framework |
| **Data Fetching** | Python 3.8+ | API calls to Kimi servers |
| **HTTP Library** | `urllib` (stdlib) | No external dependencies |
| **Build** | PowerShell | Packaging into `.nvg` files |
| **Manifest** | JSON | Extension metadata |


## Project Structure

```
kimi-code-quota/
├── package.json              # Extension manifest (SAO Utils 2 format)
├── preset.json               # Widget preset metadata
├── build.ps1                 # Build script - creates .nvg package
├── preview.png               # Gallery preview image (14013 bytes)
├── README.md                 # Chinese documentation
├── INSTALL.md                # Installation guide (multiple methods)
│
├── qml/                      # Widget UI files
│   ├── KimiCodeQuota.qml     # Main widget component (356 lines)
│   └── SettingsDialog.qml    # Settings window (152 lines)
│
├── server/                   # Python backend
│   ├── fetch_kimi_quota.py   # API fetcher script (129 lines)
│   ├── run_fetch.bat         # Batch wrapper for Windows
│   ├── quota_output.json     # Data output file (auto-generated)
│   └── README.md             # Outdated docs (mentions Playwright)
│
├── icons/                    # Icon resources
│   └── quota.png             # Widget icon
│
└── translations/             # i18n files
    ├── en.json               # English strings
    └── zh.json               # Chinese strings
```


## Architecture

### Data Flow

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   SAO Utils 2   │     │  Python Script  │     │   Kimi API      │
│   (QML Widget)  │────▶│  (server/*.py)  │────▶│ (api.kimi.com)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                       │
         │                       ▼                       │
         │              ┌─────────────────┐              │
         │              │  Read token from│              │
         │              │  ~/.kimi/creds/ │              │
         │              └─────────────────┘              │
         ▼                       │                       │
┌─────────────────┐              │                       │
│ quota_output.json│◄────────────┘◄──────────────────────┘
│  (local cache)   │     API response
└─────────────────┘
```

### Key Components

1. **KimiCodeQuota.qml** - Main widget
   - Extends `T.Widget` (NERvGear template)
   - Fixed size: 281x161 pixels
   - Uses `NVG.SystemCall.execute()` to run Python script
   - Reads JSON output via `XMLHttpRequest`
   - Auto-refresh timer (configurable interval)

2. **fetch_kimi_quota.py** - Data fetcher
   - Loads access token from `~/.kimi/credentials/kimi-code.json`
   - Calls `GET https://api.kimi.com/coding/v1/usages`
   - Parses weekly usage and rate limits
   - Writes results to JSON file

3. **SettingsDialog.qml** - Configuration UI
   - Python path configuration
   - Auto-refresh interval (1-60 minutes)
   - Usage instructions


## Configuration Files

### package.json
Extension manifest following SAO Utils 2 format:
```json
{
    "name": "com.ericfl.imicode.quota",
    "version": "1.2.0",
    "title": { "en": "...", "zh": "..." },
    "resources": [{
        "catalog": "widget",
        "entry": "qml/KimiCodeQuota.qml"
    }]
}
```

### User Settings (stored by SAO Utils 2)
- `pythonPath` - Path to Python executable (default: "python")
- `refreshIntervalMins` - Auto-refresh interval in minutes (default: 5)


## Build Process

### Build Command
```powershell
.\build.ps1
```

### Build Steps
1. Creates `temp_package/` directory
2. Copies required files:
   - `package.json`, `README.md`, `preview.png`
   - `qml/` directory (QML files)
   - `icons/` directory (PNG only, removes SVG)
   - `translations/` directory
   - `server/` directory
3. Creates ZIP archive: `kimi-code-quota-1.1.0.zip`
4. Renames to `.nvg`: `kimi-code-quota-1.1.0.nvg`
5. Cleans up temporary files

### Output
- `kimi-code-quota-1.1.0.nvg` - Installable extension package
- `.nvg` is a renamed ZIP file


## Development Conventions

### QML Coding Style
- Import order: Qt Quick → Qt Quick Controls → NERvGear
- Property declarations at top of components
- Use `readonly property` for constants
- Chinese text in UI (primary language)
- White theme colors (`#ffffff` background, `#333333` text)

### Python Coding Style
- Standard library only (no external deps for production)
- Function-based architecture (no classes)
- JSON for data exchange
- UTF-8 encoding for all file operations

### File Naming
- QML: PascalCase (e.g., `KimiCodeQuota.qml`)
- Python: snake_case (e.g., `fetch_kimi_quota.py`)
- Resources: lowercase (e.g., `quota.png`)


## Installation & Testing

### Development Installation
1. Copy project folder to SAO Utils 2 Packages directory:
   ```
   Steam: Steam\steamapps\common\SAO Utils 2\Packages\
   Portable: [SAO Utils 2 folder]\Packages\
   ```
2. Restart SAO Utils 2
3. Right-click desktop → Widgets → Widget Gallery
4. Find "Kimi Code Quota" and add to desktop

### Prerequisites for Testing
1. Install Kimi CLI: `pip install kimi-cli`
2. Login: `kimi login` (creates `~/.kimi/credentials/kimi-code.json`)
3. Python 3.8+ in PATH (or configure path in widget settings)

### Manual Testing
```bash
# Test Python script directly
cd server
python fetch_kimi_quota.py test_output.json
cat test_output.json
```

Expected output format:
```json
{
  "weekly": 24,
  "rate_limit": 18,
  "reset_hours": 124,
  "rate_reset_hours": 1,
  "success": true,
  "error": null
}
```


## Security Considerations

### Token Storage
- Access token stored in `~/.kimi/credentials/kimi-code.json` (created by Kimi CLI)
- Token is read-only access for quota API
- Token is not logged or transmitted elsewhere

### API Calls
- HTTPS only (`https://api.kimi.com`)
- Timeout: 30 seconds
- User-Agent: `KimiQuota/1.0`

### File Permissions
- Output JSON written to extension directory
- No elevated permissions required


## Known Issues & Notes

1. **Version mismatch**: `package.json` says 1.2.0, `build.ps1` says 1.1.0
2. **Documentation outdated**: `server/README.md` mentions Playwright (not used)
3. **Translation files**: Not actively used in QML code (hardcoded Chinese)
4. **Error handling**: Basic JSON parsing with try-catch


## Localization

Translation files exist but are **not integrated** into the QML code:
- `translations/en.json` - English strings
- `translations/zh.json` - Chinese strings

To enable translations, use `qsTr()` and Qt's internationalization system.


## API Reference

### Kimi API Endpoint
```
GET https://api.kimi.com/coding/v1/usages
Authorization: Bearer <access_token>
```

### Response Structure
```json
{
  "usage": {
    "used": <int>,
    "limit": <int>,
    "resetTime": "ISO8601 timestamp"
  },
  "limits": [
    {
      "detail": {
        "used": <int>,
        "limit": <int>,
        "resetTime": "ISO8601 timestamp"
      }
    }
  ]
}
```


## Dependencies

### Runtime Dependencies
- SAO Utils 2 (NERvGear platform)
- Python 3.8+
- Kimi CLI (for authentication)

### No Python Package Dependencies
The script uses only standard library:
- `urllib.request` - HTTP requests
- `json` - JSON parsing
- `pathlib` - Path operations
- `datetime` - Time calculations
