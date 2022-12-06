## Scan a directory
```
docker run -t -v {path_to_host_folder_to_scan}:/path checkmarx/kics:latest scan -p /path -o "/path/"
```

## Scan a single file
```
docker run -t -v {path_to_host_folder}:/path checkmarx/kics:latest scan -p /path/{filename}.{extention} -o "/path/"
```

## Scan Example
[![](https://user-images.githubusercontent.com/111127232/205708625-ac555103-1d8d-4236-b97b-aee2a14c776b.gif)](https://user-images.githubusercontent.com/111127232/205708625-ac555103-1d8d-4236-b97b-aee2a14c776b.gif)