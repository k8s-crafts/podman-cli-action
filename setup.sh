#!/usr/bin/env bash

# Copyright The k8s-crafts Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

BIN="$HOME/.bin"
DIR="$(dirname "$(readlink -f "$0")")"

main() {
    if [[ "$(uname)" != "Linux" ]]; then
        echo "Only Linux platform is supported."
        exit 2
    fi

    # If apt is available, try installing podman-docker package.
    # If failed, fall back to method of an executable script.
    if command -v apt; then
        sudo apt -y install podman-docker || \
            echo "Failed to install podman-docker. Falling back to an executable script \"docker\"" && use_fallback_script
    else
        use_fallback_script
    fi

    if [[ -n "$ENABLE_PODMAN_API" && "$ENABLE_PODMAN_API" == "true" ]]; then
        enable_podman_api
    fi
}

# This function does the following:
# - Create an executable script named docker.
# - Delegate the execution to podman and pass all its arguments to it.
# - Ensure the script is available on PATH with higher precedence than existing docker command.
use_fallback_script() {
    mkdir -p "$BIN"; cat "$DIR/docker" > "$BIN/docker"; chmod +x "$BIN/docker"
    echo "PATH=$BIN:$PATH" >> "$GITHUB_ENV"
}

enable_podman_api() {
    systemctl --user enable --now podman.socket
    echo "DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock" >> "$GITHUB_ENV"
}

main "$@"
