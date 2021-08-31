# Running KICS

## Supported Resources

KICS makes use of the <a href="https://github.com/hashicorp/go-getter#go-getter">go-getter</a> package in order to scan files or directories from various sources.

KICS is able to perform scans on these types of paths:

 - Local Files
 - Archived Files
 - S3
 - Git
 - GSC

 Files and directories that are not local will be placed in a temporarly folder during KICS execution.


### Local Files

```
kics scan -p path/local
```

### Archived Files

Available archive formats:

- `tar.gz` and `tgz`
- `tar.bz2` and `tbz2`
- `tar.xz` and `txz`
- `zip`
- `gz`
- `bz2`
- `xz`

```
kics scan -p path/local.zip
```

More information can be seen [here](https://github.com/hashicorp/go-getter#unarchiving)


### S3

S3 Bucket path syntax:

```
s3::{S3 Bucket URL}?{query parameters}
```

#### Query Parameters:

- `aws_access_key_id` - AWS access key.
- `aws_access_key_secret` - AWS access key secret.
- `aws_access_token` - AWS access token if this is being used.
- `aws_profile` - Use this profile from local ~/.aws/ config. Takes - priority over the other three.


```
kics scan -p s3::https://s3.amazonaws.com/bucket/foo?aws_profile=~/.aws/profile
```

More information can be seen [here](https://github.com/hashicorp/go-getter#s3-s3)

### Git

```
kics scan -p git::https://github.com/Checkmarx/kics
```

#### SSH

```
kics scan -p git::git@github.com:Checkmarx/kics.git
```

Please make sure you have SSH private key configured with your github account

More information can be seen [here](https://github.com/hashicorp/go-getter#git-git)

### GSC

```
kics scan -p gcs::https://www.googleapis.com/storage/v1/bucket
```

Please make sure you have set GSC authentication credentials to your application code by environment variables

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
  "defaultPasswords": [
    "myCustomValue1",
    "myCustomValue2",
    "myCustomValue3",
  ]
}
```

Then you can execute KICS normally adding `--input-data ./custom-input/`, if `custom-input` folder is in current path, and it will replace the key `defaultPasswords` on `passwords_and_secrets_in_infrastructure_code` query with the custom value you defined.

**NOTE**: The value which will replace the default value, **MUST** be the same type as the default key (e.g. `defaultPasswords` must be an array of strings)

## Using commands on scanned files as comments
KICS scan supports some special commands in the comments that are on the file beginning (i.e.: all comments before any valid line on IaC file). To use this feature you need to create a comment that starts with `kics-scan` and wanted command with values (if necessary).

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

KICS currently supports three commands:
- `ignore`: Will ignore file when running a scan;
- `enable=<query_id>,<query_id>`: Will get results on this file **only** for listed queries;
- `disable=<query_id>,<query_id>`: Will ignore results on this file for listed queries;

The order of prescendence in above commands are:
1. ignore
2. enable
3. disable

For example:
```hcl
# kics-scan disable=0afa6ab8-a047-48cf-be07-93a2f8c34cf7
# kics-scan
```
In this case, this file will be ignored by KICS, instead of ignoring results for query with id 0afa6ab8-a047-48cf-be07-93a2f8c34cf7.

This feature is supported by all extensions that supports comments. Currently, KICS supports this features for:
- Dockerfile;
- HCL (Terraform);
- YAML;
