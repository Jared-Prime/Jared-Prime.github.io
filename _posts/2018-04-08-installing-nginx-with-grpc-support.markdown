---
layout: post
title: "Installing nginx with gRPC support"
date: 2018-04-05
preview: Simple shell commands are suffient for testing until an official package available for your distro
---

I used the following to rebuild nginx 1.13.11 on Fedora 27 with an existing HTTP/1 nginx proxy. As sepcified, this builds nginx from the release to replace the existing installation; it's backwards compatible safe.

    cd /opt
    wget http://nginx.org/download/nginx-1.13.11.tar.gz
    tar -xvzf nginx-1.13.11.tar.gz 
    cd nginx-13.11
    ./configure --sbin-path=/usr/sbin --conf-path=/etc/nginx/nginx.conf --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module
    make
    make install

I'll have a systems engineer package an RPM for deploying out to servers ( or maybe Fedora will have a package ready in time for our release). But I find it valuable to be able to compile myself for testing purposes.