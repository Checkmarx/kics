## Scan a directory
```
docker run -t -v {path_to_host_folder_to_scan}:/path checkmarx/kics:latest scan -p /path -o "/path/"
```

## Scan a single file
```
docker run -t -v {path_to_host_folder}:/path checkmarx/kics:latest scan -p /path/{filename}.{extension} -o "/path/"
```

## Scan Example
[![](https://raw.githubusercontent.com/Checkmarx/kics/23c62655308523e1bf6aa8ae5852848deb263651/docs/img/faster.gif)](https://raw.githubusercontent.com/Checkmarx/kics/23c62655308523e1bf6aa8ae5852848deb263651/docs/img/faster.gif)
