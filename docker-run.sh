#!/usr/bin/env bash
#
# run via Dockerfile
#

set -o errexit
set -o pipefail
set -o nounset

podman build \
	--build-arg COMMIT="$(git rev-parse --short HEAD)-docker-run" \
	--build-arg LASTMOD="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
	-t rdap-proxy .

podman run -it -p 4000:4000 rdap-proxy
