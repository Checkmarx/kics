# Running KICS

KICS makes use of the <a href="https://github.com/hashicorp/go-getter#go-getter">go-getter</a> package in order to scan files or directories from various sources.

KICS is able to perform scans on these types of paths:

 - Local Files
 - Archived Files
 - S3
 - Git
 - GSC

 Files and directories that are not local will be placed in a temporarly folder during KICS execution.


## Local Files

```
kics scan -p path/local
```

## Archived Files

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

More informatition can be seen [here](https://github.com/hashicorp/go-getter#unarchiving)


## S3

S3 Bucket path syntax:

```
s3::{S3 Bucket URL}?{query parameters}
```

### Query Parameters:

- `aws_access_key_id` - AWS access key.
- `aws_access_key_secret` - AWS access key secret.
- `aws_access_token` - AWS access token if this is being used.
- `aws_profile` - Use this profile from local ~/.aws/ config. Takes - priority over the other three.


```
kics scan -p s3::https://s3.amazonaws.com/bucket/foo?aws_profile=~/.aws/profile
```

More informatition can be seen [here](https://github.com/hashicorp/go-getter#s3-s3)

## Git

```
kics scan -p git::https://github.com/Checkmarx/kics
```

### SSH

```
kics scan -p git::git@github.com:Checkmarx/kics.git
```

Please make sure you have SSH private key configured with your github account

More informatition can be seen [here](https://github.com/hashicorp/go-getter#git-git)

## GSC

```
kics scan -p gcs::https://www.googleapis.com/storage/v1/bucket
```

Please make sure you have set GSC authentication credentials to your application code by environment variables

More informatition can be seen [here](https://github.com/hashicorp/go-getter#gcs-gcs)

