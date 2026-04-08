# Kimi Quota Server

This folder contains Python scripts for fetching quota data from Kimi Code console.

## Setup

1. Install Python 3.8+ from https://python.org
2. Install Playwright:
   ```bash
   pip install playwright
   playwright install chromium
   ```

## How It Works

The widget uses `NVG.SystemCall.execute()` to run `fetch_kimi_quota.py`, which:
1. Launches a headless Chromium browser via Playwright
2. Navigates to Kimi Code console (using saved cookies if available)
3. Extracts quota percentages from the page
4. Saves cookies for future use
5. Writes the result to `quota_output.json`

The widget then reads this file via `XMLHttpRequest` and displays the data.

## First-Time Login

Since the widget cannot access the WebView's cookies directly, you need to log in manually once:

1. Open the widget's WebView (click the icon in settings)
2. Log in to Kimi Code in the WebView
3. Run this script once manually to capture the cookies:
   ```bash
   python fetch_kimi_quota.py quota_output.json
   ```
4. The script will save cookies to `kimi_cookies.json` for future use

## Files

- `fetch_kimi_quota.py` - Main fetcher script
- `kimi_cookies.json` - Saved cookies (auto-generated)
- `quota_output.json` - Quota data output (auto-generated)
