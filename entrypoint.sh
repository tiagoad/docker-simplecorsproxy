#!/bin/bash

cat > /etc/nginx/conf.d/default.conf << CONFIG
server {
    listen 80;
    listen [::]:80 ipv6only=on;
    access_log off;
    server_name localhost;

    location / {
        proxy_pass ${TARGET};
        proxy_redirect off;
        proxy_ssl_server_name on;
        
        sub_filter_once off;
        sub_filter '${TARGET}' '$scheme://$host';
        
        # Wide-open CORS
        if ($request_method = 'OPTIONS') {
           add_header 'Access-Control-Allow-Origin' '*';
           add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
           #
           # Custom headers and headers various browsers *should* be OK with but aren't
           #
           add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
           #
           # Tell client that this pre-flight info is valid for 20 days
           #
           add_header 'Access-Control-Max-Age' 1728000;
           add_header 'Content-Type' 'text/plain; charset=utf-8';
           add_header 'Content-Length' 0;
           return 204;
        }
        if ($request_method = 'POST') {
           add_header 'Access-Control-Allow-Origin' '*';
           add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
           add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
           add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
        }
        if ($request_method = 'GET') {
           add_header 'Access-Control-Allow-Origin' '*';
           add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
           add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
           add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
        }
    }
}
CONFIG

nginx -g "daemon off;"