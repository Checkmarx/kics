## Installation

There are multiple ways to get KICS up and running:

#### Docker

KICS is available as a <a href="https://hub.docker.com/r/checkmarx/kics" target="_blank">Docker image</a> and can be used as follows:

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see Scan Command Options section below)

```txt
docker pull checkmarx/kics:latest
docker run -v {​​​​path_to_host_folder_to_scan}​​​​:/path checkmarx/kics:latest scan -p "/path" -o "/path/results.json"
```

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used The default *./assets/queries* is built-in in the image.

#### One-liner Install Script

Run the following command to download and install kics. It will detect your current OS and download the appropriate binary package, defaults installation to `./bin` the queries will be placed alongside the binary in `./bin/assets/queries`:

```sh
curl -sfL https://raw.githubusercontent.com/Checkmarx/kics/master/install.sh | bash
```

If you want to place it somewhere else like `/usr/local/bin`:

```sh
sudo curl -sfL https://raw.githubusercontent.com/Checkmarx/kics/master/install.sh | bash -s -- -b /usr/local/bin
```

#### Binary

KICS release process is pretty straightforward.
When we're releasing a new version, we'll pack KICS executables for both Linux and Windows operating systems.
Our security queries will be included in the ZIP files and tarballs, so that you can scan your IaC code with the out-of-the-box queries

So all you need is:

1. Go to <a href="https://github.com/Checkmarx/kics/releases/latest" target="_blank">KICS releases</a>
1. Download KICS binaries based on your OS
1. Extract files
1. Run kics executable with the cli options as described below (note that kics binary should be located in the same directory as queries directory)
   ```
   ./kics scan -p <path-of-your-project-to-scan> -o <output-results.json>
   ```

#### Build from Sources

1. Download and install Go from <a href="https://golang.org/dl/" target="_blank">https://golang.org/dl/</a>
1. Clone the repository:
   ```
   git clone https://github.com/Checkmarx/kics.git
   ```
   ```
   cd kics
   ```
1. Kick a scan!
   ```
   go run ./cmd/console/main.go scan -p <path-of-your-project-to-scan> -o <output-results.json>
   ```

---

## Next Steps
- [Understand how to configure KICS](configuration-file.md) so you can have a better KICS experience.
- [Explore KICS commands](usage/commands.md) to see what you can do with KICS.
- [Explore the queries internals](queries.md) for better understanding how KICS works.
- [Explore the output results format](results.md) and quickly fix the issues detected.
- [Contribute](CONTRIBUTING.md) if you want to go the extra mile.

