#!/usr/bin/env bash
set -e

# Extract Varnish version
VARNISH_VERSION="$( varnishd -V 2>&1 | grep -Eo 'varnish-[.0-9]+' | sed 's/varnish-/Varnish /g' )"

for name in BACKEND_PORT BACKEND_HOST VARNISH_VERSION
do
	eval value=\$$name
	sed -i "s|\${${name}}|${value}|g" /etc/varnish/default.vcl
done

exec bash -c \
	"exec varnishd \
	-a :6081 \
	-T localhost:6082 \
	-F \
	-f $VARNISH_CONFIG \
	-s malloc,$CACHE_SIZE \
	$VARNISHD_PARAMS"
