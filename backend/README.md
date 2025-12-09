# Astro.FM Backend (Flask + pyswisseph)

This backend exposes a small HTTP API for testing the Flutter frontend connection.

Endpoints
- `GET /status` — returns `{ connected: true, server_time: ..., details: { pyswisseph_available: bool } }`
- `GET /astro/positions?dt=ISO_DATETIME` — returns planetary longitudes for the given UTC datetime (or now if omitted)

Quick start (Windows PowerShell)
```powershell
cd C:\Astro.FM\astro_fm_app\backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

Notes
- The server listens on port `7777` and enables CORS so your Flutter app can fetch `http://<host-ip>:7777/status`.
- On Android emulator use `http://10.0.2.2:7777/status` to reach the host machine.
- If `pyswisseph` is not installed the `/astro/positions` endpoint will return HTTP 500 and a message; `/status` will still return `connected: true` but `details.pyswisseph_available` will be `false`.
