"""Grab one JPEG frame from the A1 mini's camera (LAN mode, TLS port 6000). Usage: python -I snapshot.py <out.jpg>
Used before starting a print to see that the plate is clear."""
import socket, struct, sys
sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
import bambu
serial, code = bambu.creds()
auth = struct.pack("<IIII", 0x40, 0x3000, 0, 0) + b"bblp".ljust(32, b"\0") + code.encode().ljust(32, b"\0")
with socket.create_connection((bambu.IP, 6000), timeout=10) as raw, bambu.tls().wrap_socket(raw, server_hostname=bambu.IP) as s:
    s.sendall(auth)
    def read(n):
        buf = b""
        while len(buf) < n:
            chunk = s.recv(n - len(buf))
            if not chunk: raise ConnectionError("camera closed the connection")
            buf += chunk
        return buf
    for _ in range(3):                       # the first frame can be stale; keep the third
        size = struct.unpack("<I", read(16)[:4])[0]
        frame = read(size)
    assert frame[:2] == b"\xff\xd8", "not a JPEG frame"
    open(sys.argv[1], "wb").write(frame)
    print("saved", sys.argv[1], len(frame), "bytes")
