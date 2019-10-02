Simple image, proxying an HTTP server with wide open CORS settings.
Change the `TARGET` environment variable to the URL you want to proxy.

Example:
```bash
docker run -p 8000:80 -it --rm -e TARGET=https://api.kanye.rest tiagoad/simplecorsproxy
```
