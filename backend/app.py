from datetime import datetime
import os

from flask import Flask, jsonify, request
from flask_cors import CORS

try:
    import swisseph as swe
except Exception:
    swe = None

app = Flask(__name__)
CORS(app)  # allow all origins for testing


PLANETS = []
if swe:
    PLANETS = [
        ("Sun", swe.SUN),
        ("Moon", swe.MOON),
        ("Mercury", swe.MERCURY),
        ("Venus", swe.VENUS),
        ("Mars", swe.MARS),
        ("Jupiter", swe.JUPITER),
        ("Saturn", swe.SATURN),
        ("Uranus", swe.URANUS),
        ("Neptune", swe.NEPTUNE),
        ("Pluto", swe.PLUTO),
    ]


@app.route("/status", methods=["GET"])
def status():
    """
    Simple health/status endpoint. Frontend should poll this to decide connected state.
    """
    return jsonify({
        "connected": True,
        "server_time": datetime.utcnow().isoformat() + "Z",
        "details": {"pyswisseph_available": bool(swe)},
    })


@app.route("/astro/positions", methods=["GET"])
def astro_positions():
    """
    Returns planetary longitudes for a given UTC datetime.
    Query param: dt=ISO_DATETIME (e.g. 2025-12-08T12:00:00Z). If omitted, uses now UTC.
    """
    if not swe:
        return jsonify({"error": "pyswisseph (swisseph) not installed on server"}), 500

    dt_str = request.args.get("dt")
    if dt_str:
        try:
            dt = datetime.fromisoformat(dt_str.replace("Z", "+00:00"))
        except Exception:
            return jsonify({"error": "invalid dt format, use ISO format"}), 400
    else:
        dt = datetime.utcnow()

    # compute Julian day (UTC)
    year = dt.year
    month = dt.month
    day = dt.day
    hour = dt.hour + dt.minute / 60.0 + dt.second / 3600.0

    jd = swe.julday(year, month, day, hour)
    results = {}
    for name, const in PLANETS:
        try:
            pos = swe.calc_ut(jd, const)
            # pos[0] usually contains position(s) where longitude is index 0
            lon = None
            if isinstance(pos, (list, tuple)) and len(pos) > 0:
                first = pos[0]
                if isinstance(first, (list, tuple)) and len(first) > 0:
                    lon = float(first[0])
                else:
                    lon = float(first)
            else:
                lon = float(pos)
            results[name] = {"longitude": round(lon, 6)}
        except Exception as ex:
            results[name] = {"error": str(ex)}

    return jsonify({"datetime_utc": dt.isoformat() + "Z", "jd": jd, "positions": results})


@app.route("/", methods=["GET"])
def index():
    return jsonify({"message": "Astro.FM backend (Flask). Use /status and /astro/positions"})


if __name__ == "__main__":
    # Optional: allow setting EPHE_PATH env var for local ephemeris files
    ephe_path = os.getenv("EPHE_PATH")
    if swe and ephe_path:
        swe.set_ephe_path(ephe_path)

    app.run(host="0.0.0.0", port=7777)
