# nginx-php

[![Release](https://img.shields.io/github/release/dakalab/nginx-php.svg)](https://github.com/dakalab/nginx-php/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/dakalab/nginx-php.svg)](https://hub.docker.com/r/dakalab/nginx-php)
[![License](https://img.shields.io/github/license/dakalab/nginx-php.svg)](https://github.com/dakalab/nginx-php)

*nginx + php + nodejs, built on ubuntu 18.04 (bionic)*

Working directory is `/app` and http root is `/app/public`.

If you need to run customized scripts, you can mount your scripts into `/scripts` folder.

`https` is off by default, if you want to enable it, you can mount your certificates into `/etc/nginx/certs` folder.

Component versions:

- composer: v1.9.0
- nginx: v1.16.0
- node: v10.16.0
- php: v7.2.19 (with modules grpc v1.22.0 and protobuf v3.91)
- ubuntu: v18.04.2
- yarn: v1.17.3
