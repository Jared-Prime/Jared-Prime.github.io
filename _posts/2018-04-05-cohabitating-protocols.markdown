---
layout: post
title: "Cohabitating Protocols"
date: 2018-04-05
preview: Using nginx +1.13.10, REST and gRPC services can cohabitate behind a single proxy.
---

Many modern "stacks" (at the time of writing this blog post) will utilizer Docker + Kubernetes to isolate and distribute services of different flavors. If you find yourself in a "legacy" situation where services get deployed to distinct servers, and those servers use nginx as a proxy between the outside and to the deployed services, then you'll be relieved to know that cohabitation is not all that difficult.

Here's a (simplified) nginx configuration for a RESTful API

    upstream restful_app {
      server unix:/run/puma/restful_app1.socket;
      server unix:/run/puma/restful_app2.socket;
    }

    server {
      listen 80 default_server;

      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;

      location @restful_app {
        proxy_pass http://restful_app;
      }
    }

Assume the configuration lay in someplace like `/etc/nginx/default.d/restful_app.conf`. The [recently released support for gRPC](https://www.nginx.com/blog/nginx-1-13-10-grpc) makes configuring an accompanying service very easy.

    upstream grpc_app {
      server 127.0.0.1:50051
      server 127.0.0.1:50052
    }

    server {
      listen 80 http2;

      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;

      location /service.Endpoint {
        grpc_pass grpc://grpc_app;
      }
    }

We can assume this configuration lay somewhere nearby like `/etc/nginx/default.d/grpc_app.conf`. Both configurations will load into the same nginx server, which will route traffic as expected. As both HTTP and HTTP2 use TCP as the underlying transport layer, nginx can use port 80 to proxy traffic to both applications, even though the higher-level protocol (HTTP vs HTTP2) and the API dialect (REST vs gRPC) differ.

Cool, huh?
