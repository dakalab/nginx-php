# nginx-php

[![Release](https://img.shields.io/github/release/dakalab/nginx-php.svg)](https://github.com/dakalab/nginx-php/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/dakalab/nginx-php.svg)](https://hub.docker.com/r/dakalab/nginx-php)
[![License](https://img.shields.io/github/license/dakalab/nginx-php.svg)](https://github.com/dakalab/nginx-php)

*nginx + php + nodejs, built on ubuntu 18.04 (bionic)*

Working directory is `/app` and http root is `/app/public`.

If you need to run customized scripts, you can mount your scripts into `/scripts` folder.

You can run `docker run --rm dakalab/nginx-php php -m` to show pre-installed php modules.

Component versions:

- composer: v1.10.6
- nginx: v1.18.0
- node: v12.17.0
- php: v7.2.24
- ubuntu: v18.04.2
- yarn: v1.22.4
