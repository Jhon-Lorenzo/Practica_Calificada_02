from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import subprocess

PORT = int(os.getenv("PORT", "8080"))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/salud":
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"OK")
        
        elif self.path == "/config":
            try:
                # DELEGAR TODA LA LÓGICA A TU SCRIPT BASH
                result = subprocess.run(
                    ['bash', './src/generar-config.sh'],
                    capture_output=True, #stdout y stderror
                    text=True,
                    timeout=5,
                    env=os.environ  # Pasar todas las variables de entorno
                )
                
                if result.returncode == 0:
                    # Script Bash retorna la configuración directamente
                    self.send_response(200)
                    self.send_header("Content-type", "text/plain")
                    self.end_headers()
                    self.wfile.write(result.stdout.encode())
                else:
                    # Error manejado por Bash
                    self.send_response(500)
                    self.send_header("Content-type", "text/plain") 
                    self.end_headers()
                    self.wfile.write(result.stderr.encode())
                    
            except Exception as e:
                self.send_response(500)
                self.send_header("Content-type", "text/plain")
                self.end_headers()
                self.wfile.write(f"Error ejecutando configuración: {str(e)}".encode())

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