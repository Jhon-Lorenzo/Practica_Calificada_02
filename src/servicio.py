from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import json

PORT = int(os.getenv("PORT", "8080"))
WHITELIST = ["PORT", "RELEASE", "HOST", "DEBUG", "LOG_LEVEL"]
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/salud":
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"OK")
        
        elif self.path == "/config":
            # Validar variables requeridas
            if os.getenv("PORT") is None:
                self.send_response(500)
                self.send_header("Content-type", "text/plain")
                self.end_headers()
                self.wfile.write("ERROR: Variable requerida PORT no definida".encode())
                return

            # Filtrar variables de la lista blanca
            config = {key: os.getenv(key) for key in WHITELIST if os.getenv(key)}

            # Determinar formato
            formato = os.getenv("FORMATO_SALIDA", "json").lower()
            if formato == "texto":
                body = "\n".join(f"{k}={v}" for k, v in config.items())
                self.send_response(200)
                self.send_header("Content-type", "text/plain")
                self.end_headers()
                self.wfile.write(body.encode())
            else:  # JSON por defecto
                body = json.dumps(config, indent=2)
                self.send_response(200)
                self.send_header("Content-type", "application/json")
                self.end_headers()
                self.wfile.write(body.encode())

        else:
            self.send_response(404)
            self.end_headers()

if __name__ == "__main__":
    try:
        with HTTPServer(("", PORT), Handler) as httpd:
            print(f"Servidor escuchando en puerto {PORT}")
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("")