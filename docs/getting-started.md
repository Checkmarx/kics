## Scan a directory
```
docker run -t -v {path_to_host_folder_to_scan}:/path checkmarx/kics:latest scan -p /path -o "/path/"
```

## Scan a single file
```
docker run -t -v {path_to_host_folder}:/path checkmarx/kics:latest scan -p /path/{filename}.{extention} -o "/path/"
```

## Scan Example
[![](https://user-images.githubusercontent.com/111127232/206156696-283f9d43-1ff1-4cf4-8fa6-6bf37a282360.gif)](https://user-images.githubusercontent.com/111127232/206156696-283f9d43-1ff1-4cf4-8fa6-6bf37a282360.gif)