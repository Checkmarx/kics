## Scan a directory
```
docker run -t -v {path_to_host_folder_to_scan}:/path checkmarx/kics:latest scan -p /path -o "/path/"
```

## Scan a single file
```
docker run -t -v {path_to_host_folder}:/path checkmarx/kics:latest scan -p /path/{filename}.{extension} -o "/path/"
```

## Scan Example
[![](https://raw.githubusercontent.com/Checkmarx/kics/aa0522c7a6cdb510da30a988d668247058e5882b/docs/img/faster.gif)](https://raw.githubusercontent.com/Checkmarx/kics/aa0522c7a6cdb510da30a988d668247058e5882b/docs/img/faster.gif)
