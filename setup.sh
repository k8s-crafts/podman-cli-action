#!/usr/bin/env bash

# MIT License

# Copyright (c) 2024 k8s-crafts Authors

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


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

    if [[ "${ENABLE_PODMAN_API:-}" == "true" ]]; then
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
