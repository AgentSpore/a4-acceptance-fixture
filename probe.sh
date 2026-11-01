#!/bin/sh
# Immutable fixture uses only reviewed disposable stand addresses, never production.
set -eu
mkdir -p /www
/bin/busybox wget -q -T 5 -O /tmp/mirror.json http://10.253.77.10:5000/v2/
/bin/busybox wget -q -T 5 -O /tmp/package.json http://10.253.77.12:8084/config.json
# A matching trusted peer must first prove this exact nc primitive succeeds on live targets.
blocked() {
    if /bin/busybox nc -w 2 "$1" "$2" </dev/null >/dev/null 2>&1; then
        exit 72
    fi
}
blocked 10.253.78.30 5432
blocked 10.253.78.31 6379
blocked 10.253.79.30 8080
blocked 10.253.80.30 5000
blocked 10.253.79.31 2375
blocked 10.253.77.1 2375
blocked 10.253.77.1 18085
blocked 10.253.81.1 18085
blocked 10.253.81.1 2375
blocked 169.254.169.254 80
blocked 1.1.1.1 443
for host in 10.253.77.20 10.253.78.20 10.253.79.20 10.253.80.20; do
    for port in 2375 1234 5000 8000 8080 5432 6379; do blocked "$host" "$port"; done
done
route_mode=denied
forwarding=not_exercised
if /bin/busybox ip route add 10.253.78.0/24 via 10.253.77.20 2>/dev/null; then
    route_mode=attempted
    forwarding=blocked
    blocked 10.253.78.30 5432
    /bin/busybox ip route del 10.253.78.0/24 via 10.253.77.20
fi
printf '{"origin":"actual_buildkit_run","mirror_positive":true,"package_positive":true,"route_mode":"%s","targets":{"postgres":"blocked","redis":"blocked","launcher":"blocked","registry":"blocked","restart_gate":"blocked","docker_api":"blocked","host_gateway":"blocked","metadata_endpoint":"blocked","direct_public_egress":"blocked","worker_proxy":"blocked","worker_forwarding":"%s"}}\n' "$route_mode" "$forwarding" > /www/probe.json
