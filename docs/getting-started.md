## Installation

There are multiple ways to get KICS up and running:

#### Docker

KICS is available as a <a href="https://hub.docker.com/r/checkmarx/kics" target="_blank">Docker image</a> and can be used as follows:

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see Scan Command Options section below)

```shell
docker pull checkmarx/kics:latest
docker run -v {​​​​path_to_host_folder_to_scan}​​​​:/path checkmarx/kics scan -p "/path" -o "/path/"
```

You can see the list of available tags in [dockerhub](https://hub.docker.com/r/checkmarx/kics/tags?page=1&ordering=-name)

ℹ️ **UBI Based Images**

When using [UBI7](https://catalog.redhat.com) based image, the KICS process will run under the `kics` user and `kics` group with default UID=1000 and GID=1000, when using bind mount to share host files with the container, the UID and GID can be overriden to match current user with the `-u` flag that overrides the username:group or UID:GID. e.g:

```sh
docker run -it -u $UID:$GID -v $PWD:/path checkmarx/kics:ubi7 scan -p /path/assets/queries/dockerfile -o /path -v
```

Another option is [rebuilding the dockerfile](https://github.com/Checkmarx/kics/blob/master/Dockerfile.ubi7) providing build arguments e.g: `--build-arg UID=999 --build-arg GID=999 --build-arg KUSER=myuser --build-arg KUSER=mygroup`

#### Homebrew

KICS is avaiable on Checkmarx [homebrew-tap](https://github.com/Checkmarx/homebrew-tap). It can be used as follows:

```
brew install Checkmarx/tap/kics
```

To use KICS default queries add KICS_QUERIES_PATH env to your `~/.zshrc`, `~/.zprofile`:

```
echo 'export KICS_QUERIES_PATH=/usr/local/opt/kics/share/kics/assets/queries' >> ~/.zshrc
```

#### Custom Queries

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used The default _./assets/queries_ is built-in in the image. You can use this to provide a path to your own custom queries. Check [create a new query guide](creating-queries.md) to learn how to define your own queries.

#### Build from Sources

1. Download and install Go from <a href="https://golang.org/dl/" target="_blank">https://golang.org/dl/</a>
2. Clone the repository:
    ```shell
    git clone https://github.com/Checkmarx/kics.git
    ```
3. Build the binaries:
    ```shell
    cd kics
    make build
    ```
4. Kick a scan!
    ```shell
    ./bin/kics scan -p '<path-of-your-project-to-scan>' --report-formats json -o ./results
    ```

---

**Note**: KICS does not execute scan by default anymore.

## Next Steps

-   [Understand how to configure KICS](configuration-file.md) so you can have a better KICS experience.
-   [Explore KICS commands](commands.md) to see what you can do with KICS.
-   [Explore supported platforms](platforms.md) to see which files you can scan with KICS.
-   [Explore the queries internals](queries.md) for better understanding how KICS works.
-   [Create a new query](creating-queries.md) to learn how to create your own custom queries.
-   [Explore the output results format](results.md) and quickly fix the issues detected.
-   [Contribute](CONTRIBUTING.md) if you want to go the extra mile.
