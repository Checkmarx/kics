## Installation

There are multiple ways to get KICS up and running:

#### Docker

KICS is available as a <a href="https://hub.docker.com/r/checkmarx/kics" target="_blank">Docker image</a> with multiple variants to fit different use cases:

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the `-p` KICS parameter (see Scan Command Options section below)

**Quick Start:**
```shell
docker pull checkmarx/kics:latest
docker run -t -v "{path_to_host_folder_to_scan}":/path checkmarx/kics scan -p /path -o "/path/"
```

**Available Image Variants:**

| Tag | Base OS | Package Manager | Use Case |
|-----|---------|----------------|----------|
| `latest`, `v{VERSION}` | Wolfi Linux | None | Default, lightweight image |
| `alpine`, `v{VERSION}-alpine` | Alpine Linux | `apk` | When you need `apk` package manager |
| `debian`, `v{VERSION}-debian` | Debian | `apt-get` | When you need `apt-get` package manager |
| `ubi8`, `v{VERSION}-ubi8` | Red Hat UBI8 | `yum` | Enterprise environments, Red Hat compatible |

You can see the list of available tags in [dockerhub](https://hub.docker.com/r/checkmarx/kics/tags?page=1&ordering=-name)

**Choosing the Right Image:**

- **For most users**: Use `latest` (default, smallest size)
- **If you need to install additional packages**: Choose based on your preferred package manager:
  - `alpine` for `apk add` commands
  - `debian` for `apt-get install` commands  
  - `ubi8` for `yum install` commands in enterprise environments

ℹ️ **UBI Based Images**

When using [UBI8](https://catalog.redhat.com) based image, the KICS process will run under the `kics` user and `kics` group with default UID=1000 and GID=1000. When using bind mount to share host files with the container, the UID and GID can be overriden to match current user with the `-u` flag that overrides the username:group or UID:GID. e.g:

```sh
docker run -it -u $UID:$GID -v $PWD:/path checkmarx/kics:ubi8 scan -p /path/assets/queries/dockerfile -o /path -v
```

Another option is [rebuilding the dockerfile](https://github.com/Checkmarx/kics/blob/master/docker/Dockerfile.ubi8) providing build arguments e.g: `--build-arg UID=999 --build-arg GID=999 --build-arg KUSER=myuser --build-arg KUSER=mygroup`

#### Build from Sources

1. Download and install Go 1.16 or higher (1.22 recommended) from <a href="https://golang.org/dl/" target="_blank">https://golang.org/dl/</a>.
2. Clone the repository:
    ```sh
    git clone https://github.com/Checkmarx/kics.git
    ```
3. Build the binaries:
    ```sh
    cd kics
    go mod vendor
    make build
    ```

    or 

    ```sh
    cd kics
    go mod vendor
    LINUX/MAC: go build -o ./bin/kics cmd/console/main.go
    WINDOWS: go build -o ./bin/kics.exe cmd/console/main.go (make sure to create the bin folder)
    ```
4. Kick a scan!
    ```sh
    ./bin/kics scan -p '<path-of-your-project-to-scan>' --report-formats json -o ./results
    ```

#### [Deprecated] Homebrew

KICS is available on Checkmarx [homebrew-tap](https://github.com/Checkmarx/homebrew-tap) only for versions until 1.5.1. It can be used as follows:

```
brew install Checkmarx/tap/kics
```

#### Default Queries

To use KICS default queries add the KICS_QUERIES_PATH environmental variable to your shell profile, e.g:

```
echo 'export KICS_QUERIES_PATH=/usr/local/opt/kics/share/kics/assets/queries' >> ~/.zshrc
```

#### Custom Queries

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used The default _./assets/queries_ is built-in in the image. You can use this to provide a path to your own custom queries. Check [create a new query guide](creating-queries.md) to learn how to define your own queries.

#### Password and Secrets

Since the Password and Secrets mechanism uses generic regexes, we advise you to tweak the rules of the secret to your context. Please, see the [Password and Secrets documentation](https://github.com/Checkmarx/kics/blob/master/docs/secrets.md#new-rules-addition) to know how you can use your own rules.

---

**Note**: KICS does not execute scan by default as of [version 1.3.0](https://github.com/Checkmarx/kics/releases/tag/v1.3.0).

**Note**: KICS deprecated the availability of binaries in the GitHub releases assets as of [version 1.5.2](https://github.com/Checkmarx/kics/releases/tag/v1.5.2), it is advised to update all systems (pipelines, integrations, etc.) to use the [KICS Docker Images](https://hub.docker.com/r/checkmarx/kics).

## Next Steps

-   [Understand how to configure KICS](configuration-file.md) so you can have a better KICS experience.
-   [Explore KICS commands](commands.md) to see what you can do with KICS.
-   [Explore supported platforms](platforms.md) to see which files you can scan with KICS.
-   [Explore the queries internals](queries.md) for better understanding how KICS works.
-   [Create a new query](creating-queries.md) to learn how to create your own custom queries.
-   [Explore the output results format](results.md) and quickly fix the issues detected.
-   [Contribute](CONTRIBUTING.md) if you want to go the extra mile.
