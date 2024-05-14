# Running KICS

## Supported Resources

KICS makes use of the <a href="https://github.com/hashicorp/go-getter#go-getter">go-getter</a> package in order to scan files or directories from various sources.

KICS is able to perform scans on these types of paths:

-   Local Files
-   Archived Files
-   S3
-   Git
-   GCS

Files and directories that are not local will be placed in a temporarily folder during KICS execution.

### Local Files

```
docker run -t -v {path_to_scan}:/path checkmarx/kics scan -p /path
```

### Archived Files

Available archive formats:

-   `tar.gz` and `tgz`
-   `tar.bz2` and `tbz2`
-   `tar.xz` and `txz`
-   `zip`
-   `gz`
-   `bz2`
-   `xz`

```
To scan a zip file, we would use this instruction: 

docker run -t -v "{path_to_folder_of_zip}:/path" checkmarx/kics:latest scan -p /path/{name_of_zip_file}

-t: Docker command to allocate a pseudo-TTY.

-v "{path_to_folder_of_zip}:/path": Mounts the directory containing the zip file to be scanned into the Docker container.

checkmarx/kics:latest: Specifies the Docker image to use, which is the latest version of KICS available. 

scan -p /path/{name_of_zip_file}: initiates a scan on the zip file we provided, considering it's folder path.
```

```
To scan a file named "Example", we would use this instruction: 

docker run -t -v "{path_to_folder_of_file_Example}:/path" checkmarx/kics:latest scan -p /path/Example

-t: Docker command to allocate a pseudo-TTY.

-v "{path_to_folder_of_file_Example}:/path": Mounts the directory containing the file to be scanned into the Docker container.

checkmarx/kics:latest: Specifies the Docker image to use, which is the latest version of KICS available. 

scan -p /path/Example: initiates a scan on the "Example" file we provided, considering it's folder path.
```

More information on Docker CLI can be seen [here](https://docs.docker.com/engine/reference/commandline/cli/)   

More information on Go getter can be seen [here](https://github.com/hashicorp/go-getter#unarchiving)   

### S3

S3 Bucket path syntax:

```
s3::{S3 Bucket URL}?{query parameters}
```

#### Query Parameters:

-   `aws_access_key_id` - AWS access key.
-   `aws_access_key_secret` - AWS access key secret.
-   `aws_access_token` - AWS access token if this is being used.
-   `aws_profile` - Use this profile from local ~/.aws/ config. Takes - priority over the other three.

```
docker run -t -v ~/.aws:/path checkmarx/kics scan -p "s3::https://s3.amazonaws.com/bucket/foo?aws_profile=/path/.aws/profile"
```

More information can be seen [here](https://github.com/hashicorp/go-getter#s3-s3)

### Git

```
docker run -t checkmarx/kics scan -p "git::https://github.com/Checkmarx/kics"
```

#### SSH

```
docker run -t checkmarx/kics scan -p "git::git@github.com:Checkmarx/kics.git"
```

Please make sure you have SSH private key configured with your github account

More information can be seen [here](https://github.com/hashicorp/go-getter#git-git)

### GCS

```
docker run -t checkmarx/kics scan -p "gcs::https://www.googleapis.com/storage/v1/bucket"
```

Please make sure you have set authentication credentials to your application code by environment variables

More information can be seen [here](https://github.com/hashicorp/go-getter#gcs-gcs)

## Using custom input data

Since from v1.3.5, KICS supports using custom input data to replace data on queries that have this feature supported. To see if a query supports overwriting, check if the query's folder contains a `data.json` file, this file will contain all keys that can be overwritten.
To overwrite the key, you need to create files following the pattern `<query_id>.json`, each file representing **one** query and passing folder path containing these files to the flag `input-data`, this will get all files from this folder and replace all keys on queries found.

**NOTE**: Keys that are not overwritten will use the default value proposed by `data.json` file of targeted query.

For example, on `queries/common/passwords_and_secrets_in_infrastructure_code/` contains the following `data.json`:

```json
{
  "defaultPasswords": [
    "!@",
    "root",
    "wubao",
    ...
  ],
  "blackList": [
    "RESOURCE",
    "GROUP",
    "SUBNET",
    ...
  ]
}

```

This means there are two keys, `defaultPasswords` and `blackList`, that can be overwritten. On the query, you can search them on `query.rego` file with: `data.defaultPasswords` and `data.blackList`, to understand how it is used by the query.

To overwrite `defaultPasswords`, you can create a file `f996f3cb-00fc-480c-8973-8ab04d44a8cc.json` on a folder `custom-input`, for example, as following:

```json
{
    "defaultPasswords": ["myCustomValue1", "myCustomValue2", "myCustomValue3"]
}
```

Then you can execute KICS normally adding `--input-data ./custom-input/`, if `custom-input` folder is in current path, and it will replace the key `defaultPasswords` on `passwords_and_secrets_in_infrastructure_code` query with the custom value you defined.

**NOTE**: The value which will replace the default value, **MUST** be the same type as the default key (e.g. `defaultPasswords` must be an array of strings)

## Using commands on scanned files as comments

KICS scan supports some special commands in the comments. To use this feature you need to create a comment that starts with `kics-scan` and wanted command with values (if necessary).

For example, if you want to ignore a tf file when running a scan, you can start your file as following:

```hcl
# kics-scan ignore
# rest of the file...
```

If you need to start with a header comment, you can add another line below with the `kics-scan` command you want, but `kics-scan` will not works if there is any valid line above it, as you can see on the following example:

```hcl
# Some comment
# This works
# kics-scan ignore
resource "google_storage_bucket" "example" {
  # This does not works
  # kics-scan ignore
  name          = "image-store.com"
  location      = "EU"
  force_destroy = true
}
# This also not works, since there is valid script before this comment
# kics-scan ignore
```

KICS currently supports five commands:

-   Must be in file's start:
    -   `ignore`: Will ignore file when running a scan;
    -   `enable=<query_id>,<query_id>`: Will get results on this file **only** for listed queries;
    -   `disable=<query_id>,<query_id>`: Will ignore results on this file for listed queries;
-   Can be used in all file extension:
    -   `ignore-line`: Will ignore the line beneath the comment on the results
    -   `ignore-block`: Will ignore the block and all its key-value pairs on the results

The order of prescendence in above commands are:

1. ignore
2. ignore-block
3. ignore-line
4. enable
5. disable

For example:

```hcl
# kics-scan disable=0afa6ab8-a047-48cf-be07-93a2f8c34cf7
# kics-scan
```

In this case, this file will be ignored by KICS, instead of ignoring results for query with id 0afa6ab8-a047-48cf-be07-93a2f8c34cf7.

`kics-scan ignore-line` example:

```hcl
1: resource "google_storage_bucket" "example" {
2:  # kics-scan ignore-line
3:  name          = "image-store.com"
4:  location      = "EU"
5:  force_destroy = true
6: }
```

Results that point to lines 2 and 3 will be ignored.

`kics-scan ignore-block` example:

```hcl
1: # kics-scan ignore-block
2: resource "google_storage_bucket" "example" {
3:  name          = "image-store.com"
4:  location      = "EU"
5:  force_destroy = true
6: }
```

Results that point from line 1 to 6 will be ignored.

For Dockerfile `ignore-block` is only usable when the whole `FROM` block should be ignored.

```Dockerfile
1: # kics-scan ignore-block
2: FROM kics
3: USER Checkmarx
4:
5: FROM kics:2.0
6: USER Checkmarx
```

in this case only lines from 1 to 3 will be ignored.

`ignore-line` will ignore all lines of a multi-line command in Docker.

**NOTE**: For YAML when trying to ignore the whole resource this file should start with `---` and then the KICS comment command as you can see on the following example:

```yaml
1: ---
2: # kics-scan ignore-block
3: apiVersion: v1
4: kind: Pod
5: metadata:
6:  name: memory-demo-1
7:  namespace: mem-example
```

This feature is supported by all extensions that supports comments. Currently, KICS supports this feature for:

-   Dockerfile;
-   HCL (Terraform);
-   YAML;
