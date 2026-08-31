FROM busybox
RUN apt-get install python=2.7
RUN ["pwsh.exe", "-NoLogo", "-Command", "vcpkg integrate install"]
