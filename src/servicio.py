from http.server import BaseHTTPRequestHandler, HTTPServer
import os

PORT = int(os.getenv("PORT", "8080"))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/salud":
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"OK")
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == "__main__":
    with HTTPServer(("", PORT), Handler) as httpd:
        print(f"Servidor escuchando en puerto {PORT}")
        httpd.serve_forever()
