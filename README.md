# Docker Varnish

[![Build Status](https://travis-ci.org/devilbox/docker-varnish.svg?branch=master)](https://travis-ci.org/devilbox/docker-varnish)
[![Tag](https://img.shields.io/github/tag/devilbox/docker-varnish.svg?colorB=orange)](https://github.com/devilbox/docker-varnish/releases)
[![Gitter](https://badges.gitter.im/devilbox/Lobby.svg)](https://gitter.im/devilbox/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Discourse](https://img.shields.io/discourse/https/devilbox.discourse.group/status.svg?colorB=%234CB697)](https://devilbox.discourse.group)
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

Varnish Docker images for the Devilbox.

| Docker Hub | Upstream Project |
|------------|------------------|
| <a href="https://hub.docker.com/r/devilbox/varnish"><img height="82px" src="http://dockeri.co/image/devilbox/varnish" /></a> | <a href="https://github.com/cytopia/devilbox" ><img height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a> |


#### Documentation

In case you seek help, go and visit the community pages.

<table width="100%" style="width:100%; display:table;">
 <thead>
  <tr>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.readthedocs.io">Documentation</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://gitter.im/devilbox/Lobby">Chat</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.discourse.group">Forum</a></h3></th>
  </tr>
 </thead>
 <tbody style="vertical-align: middle; text-align: center;">
  <tr>
   <td>
    <a target="_blank" href="https://devilbox.readthedocs.io">
     <img title="Documentation" name="Documentation" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/readthedocs.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://gitter.im/devilbox/Lobby">
     <img title="Chat on Gitter" name="Chat on Gitter" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/gitter.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://devilbox.discourse.group">
     <img title="Devilbox Forums" name="Forum" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/discourse.png" />
    </a>
   </td>
  </tr>
  <tr>
  <td><a target="_blank" href="https://devilbox.readthedocs.io">devilbox.readthedocs.io</a></td>
  <td><a target="_blank" href="https://gitter.im/devilbox/Lobby">gitter.im/devilbox</a></td>
  <td><a target="_blank" href="https://devilbox.discourse.group">devilbox.discourse.group</a></td>
  </tr>
 </tbody>
</table>

## Build
```bash
# Build Varnish 4
make build-4

# Build Varnish 5
make build-5

# Build Varnish 6
make build-6
```


## Environment variables

| Variable        | Default value                             | Description |
|-----------------|-------------------------------------------|-------------|
| VARNISH_CONFIG  | /etc/varnish/default.vcl                  | Path to Varnish configuration file |
| CACHE_SIZE      | 128m                                      | Varnish Cache size |
| VARNISHD_PARAMS | -p default_ttl=3600 -p default_grace=3600 | Additional Varnish startup parameter |
| BACKEND_HOST    | localhost                                 | IP or hostname of backend server.<br/><br/>**Important:** This variable only has effect when using the bundled config. If you change `VARNISH_CONFIG` you need to hard-code it in your custom configuration. |
| BACKEND_PORT    | 80                                        | Port of backend server.<br/><br/>**Important:** This variable only has effect when using the bundled config. If you change `VARNISH_CONFIG` you need to hard-code it in your custom configuration. |


## Mount points

| Container path  | Description |
|-----------------|-------------|
| /etc/varnish.d/ | Mount your host directory with `*.vcl` files to this directory when you want to override the varnish config |


## Ports

By default each Varnish version exposes `6081` as its default listening port.


## Default configuration

Credits for `default.vcl` configuration goes here:

| Version   | Configuration                                                        |
|-----------|----------------------------------------------------------------------|
| Varnish 4 | https://github.com/mattiasgeniar/varnish-4.0-configuration-templates |
| Varnish 5 | https://github.com/mattiasgeniar/varnish-5.0-configuration-templates |
| Varnish 6 | https://github.com/mattiasgeniar/varnish-6.0-configuration-templates |


## Available Docker images

| Docker image              | Varnish version |
|---------------------------|-----------------|
| `devilbox/varnish:latest` | Varnish 6       |
| `devilbox/varnish:6`      | Varnish 6       |
| `devilbox/varnish:5`      | Varnish 5       |
| `devilbox/varnish:4`      | Varnish 4       |


## Examples

#### Use bundled config

Serve Varnish on port `80`, use bundled config and forward Varnish requests to a webserver on
`192.168.0.1` on port `8080` (which accepts HTTP and not HTTPS):
```bash
docker run -it -d --rm \
  -e BACKEND_HOST=192.168.0.1 \
  -e BACKEND_PORT=8080 \
  -p "80:6081" \
  devilbox/varnish:6
```

#### Use custom config

**Important:**

When using a custom config, the `BACKEND_HOST` and `BACKEND_PORT` variables will have no effect
and you need to ensure to hard-code this in your custom config.

Serve Varnish on port `80`, use custom config on host system (`/home/users/varnish/my-varnish.vcl`)
and forward Varnish requests to a webserver on `192.168.0.1` on port `8080` (which accepts HTTP and not HTTPS).

```bash
docker run -it -d --rm \
  -e BACKEND_HOST=192.168.0.1 \
  -e BACKEND_PORT=8080 \
  -e VARNISH_CONFIG=/etc/varnish.d/my-varnish.vcl \
  -v "/home/users/varnish/:/etc/varnish.d/" \
  -p "80:6081" \
  devilbox/varnish:6
```


## LICENSE

**[MIT License](LICENSE.md)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
