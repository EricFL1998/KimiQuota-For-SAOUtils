#!/usr/bin/env python3
"""
Kimi Quota Fetcher - Uses official API
"""
import sys
import json
import os
from pathlib import Path
from datetime import datetime, timezone

def get_credentials_path():
    home = Path.home()
    return home / ".kimi" / "credentials" / "kimi-code.json"

def load_token():
    cred_path = get_credentials_path()
    
    if not cred_path.exists():
        return None
    
    try:
        with open(cred_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data.get('access_token')
    except:
        return None

def fetch_quota(token):
    try:
        import urllib.request
        import urllib.error
        
        url = "https://api.kimi.com/coding/v1/usages"
        headers = {
            "Authorization": f"Bearer {token}",
            "Accept": "application/json",
            "User-Agent": "KimiQuota/1.0"
        }
        
        req = urllib.request.Request(url, headers=headers)
        
        with urllib.request.urlopen(req, timeout=30) as response:
            return json.loads(response.read().decode('utf-8'))
            
    except urllib.error.HTTPError as e:
        error_body = e.read().decode('utf-8') if hasattr(e, 'read') else str(e)
        return {"error": f"HTTP {e.code}: {error_body}"}
    except Exception as e:
        return {"error": str(e)}

def parse_reset_time(reset_time_str):
    """Calculate hours until reset"""
    if not reset_time_str:
        return None
    
    try:
        reset_time = datetime.fromisoformat(reset_time_str.replace('Z', '+00:00'))
        now = datetime.now(timezone.utc)
        delta = reset_time - now
        return max(0, int(delta.total_seconds() / 3600))
    except:
        return None

def parse_quota(data):
    result = {
        "weekly": 0,
        "rate_limit": 0,
        "reset_hours": None,
        "rate_reset_hours": None,
        "success": False,
        "error": None
    }
    
    try:
        usage = data.get("usage", {})
        if usage:
            used = int(usage.get("used", 0) or 0)
            limit = int(usage.get("limit", 1) or 1)
            result["weekly"] = int((used / limit) * 100) if limit > 0 else 0
            
            reset_time = usage.get("resetTime") or usage.get("reset_time")
            result["reset_hours"] = parse_reset_time(reset_time)
        
        limits = data.get("limits", [])
        highest_rate = 0
        rate_reset = None
        
        for item in limits:
            detail = item.get("detail", item)
            if isinstance(detail, dict):
                used = int(detail.get("used", 0) or 0)
                limit = int(detail.get("limit", 1) or 1)
                if limit > 0:
                    pct = int((used / limit) * 100)
                    if pct > highest_rate:
                        highest_rate = pct
                        reset_time = detail.get("resetTime") or detail.get("reset_time")
                        rate_reset = parse_reset_time(reset_time)
        
        result["rate_limit"] = highest_rate
        result["rate_reset_hours"] = rate_reset
        result["success"] = True
        
    except Exception as e:
        result["error"] = str(e)
    
    return result

def main():
    output_file = sys.argv[1] if len(sys.argv) > 1 else "quota_output.json"
    
    token = load_token()
    if not token:
        result = {"success": False, "error": "Not logged in. Run 'kimi login' first.", "weekly": 0, "rate_limit": 0, "reset_hours": None, "rate_reset_hours": None}
    else:
        data = fetch_quota(token)
        if "error" in data:
            result = {"success": False, "error": data.get("error", "API error"), "weekly": 0, "rate_limit": 0, "reset_hours": None, "rate_reset_hours": None}
        else:
            result = parse_quota(data)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(result, f)
    
    print(json.dumps(result))
    return 0 if result.get("success") else 1

if __name__ == "__main__":
    sys.exit(main())
