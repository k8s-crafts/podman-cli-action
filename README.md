# Podman CLI Action

![Release](https://img.shields.io/badge/Version-v1.0.0-informational?style=flat-square&label=Release)
[![Lint](https://img.shields.io/github/actions/workflow/status/k8s-crafts/podman-cli-action/lint.yaml?style=flat-square&logo=github&label=Lint)](https://github.com/k8s-crafts/podman-cli-action/actions/workflows/lint.yaml)
[![Test](https://img.shields.io/github/actions/workflow/status/k8s-crafts/podman-cli-action/test.yaml?style=flat-square&logo=github&label=Test)](https://github.com/k8s-crafts/podman-cli-action/actions/workflows/test.yaml)

This action provides the functionality to emulate Docker CLI using [`podman`](https://podman.io/) for GitHub Actions runners. If your use cases expect `docker` command but would like to use `podman` as the backend, this is action for you.

## Supported Runners


| Image | YAML Label | Supported |
| --------------------|---------------------|--------------------|
| Ubuntu 24.04 | `ubuntu-24.04` | ✅ |
| Ubuntu 22.04 | `ubuntu-latest` or `ubuntu-22.04` | ✅ |
| Ubuntu 20.04 | `ubuntu-20.04` | ✅ |


## Usage

Create a workflow YAML file in your `.github/workflows` directory. An [example workflow](#examples) is available below. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).


### Inputs

| Input | Description | Default |
| --------------------|---------------------|--------------------|
| `podman_api` | Enable Podman API and configure `DOCKER_HOST` environment variable | `false` |

### Examples

The example workflow below uses [`k8s-crafts/podman-cli-action`](https://github.com/k8s-crafts/podman-cli-action) emulates Docker CLI with `podman` on every push event to `main`.

```yaml
name: Build CI

on:
  push:
    branches:
      - main

jobs:
  build-container-image:
    runs-on: ubuntu-latest
    steps:
      - name: Emulate Docker CLI with Podman
        uses: k8s-crafts/podman-cli-action@v1
        # with: # Uncomment to enable Podman API
        #   podman_api: true
```
