#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"

image_name="qmk-pok3r-pinned:arm-gcc-7-2018-q2"

echo "Building pinned toolchain image: ${image_name}"
docker build -f "${repo_root}/Dockerfile.pinned" -t "${image_name}" "${repo_root}"

echo "Running build: make vortex/core:default"
docker run --rm \
  -v "${repo_root}:/qmk:rw" \
  -w /qmk \
  "${image_name}" \
  make vortex/core:default
