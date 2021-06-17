## Installation

There are multiple ways to get KICS up and running:

#### Docker

KICS is available as a <a href="https://hub.docker.com/r/checkmarx/kics" target="_blank">Docker image</a> and can be used as follows:

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see Scan Command Options section below)

```shell
docker pull checkmarx/kics:latest
docker run -v {​​​​path_to_host_folder_to_scan}​​​​:/path checkmarx/kics:latest scan -p "/path" -o "/path/"
```

We also provide alpine based docker image with `latest-alpine`.

You can see the list of available tags in [dockerhub](https://hub.docker.com/r/checkmarx/kics/tags?page=1&ordering=-name)

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used The default *./assets/queries* is built-in in the image.

#### One-liner Install Script

Run the following command to download and install kics. It will detect your current OS and download the appropriate binary package, defaults installation to `./bin` and the queries will be placed alongside the binary in `./bin/assets/queries`:

```shell
curl -sfL 'https://raw.githubusercontent.com/Checkmarx/kics/master/install.sh' | bash
```

If you want to place it somewhere else like `/usr/local/bin`:

```shell
sudo curl -sfL 'https://raw.githubusercontent.com/Checkmarx/kics/master/install.sh' | bash -s -- -b /usr/local/bin
```

#### Binary

KICS release process is pretty straightforward.
When we're releasing a new version, we'll pack KICS executables for Linux, Windows and macOS operating systems.
Our security queries will be included in the ZIP files and tarballs, so that you can scan your IaC code with the out-of-the-box queries.

So all you need is:

1. Go to <a href="https://github.com/Checkmarx/kics/releases/latest" target="_blank">KICS releases</a>
2. Download KICS binaries based on your OS
3. Extract files
4. Run kics executable with the cli options as described below (note that kics binary should be located in the same directory as queries directory)
   ```shell
   ./kics scan -p '<path-of-your-project-to-scan>' -o '<output-results.json>'
   ```

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
- [Understand how to configure KICS](configuration-file.md) so you can have a better KICS experience.
- [Explore KICS commands](commands.md) to see what you can do with KICS.
- [Explore supported platforms](platforms.md) to see which files you can scan with KICS.
- [Explore the queries internals](queries.md) for better understanding how KICS works.
- [Explore the output results format](results.md) and quickly fix the issues detected.
- [Contribute](CONTRIBUTING.md) if you want to go the extra mile.

