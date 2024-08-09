---
title: Update Instruction Alone
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** 9bae49be-0aa3-4de5-bab2-4c3a069e40cd
-   **Query name:** Update Instruction Alone
-   **Platform:** Dockerfile
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Build Process
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/710.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/710.html')">710</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/dockerfile/update_instruction_alone)

### Description
Instruction 'RUN update' should always be followed by ' install' in the same RUN statement<br>
[Documentation](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run)

### Code samples
#### Code samples with security vulnerabilities
```dockerfile title="Positive test num. 1 - dockerfile file" hl_lines="3"
FROM alpine:latest
RUN apk update
RUN apk add nginx

CMD ["nginx", "-g", "daemon off;"]
```
```dockerfile title="Positive test num. 2 - dockerfile file" hl_lines="3"
FROM opensuse:latest
RUN zypper refresh
RUN zypper install nginx

CMD ["nginx", "-g", "daemon off;"]
```
```dockerfile title="Positive test num. 3 - dockerfile file" hl_lines="3"
FROM debian:latest
RUN apt update
RUN apt install nginx

CMD ["nginx", "-g", "daemon off;"]
```
<details><summary>Positive test num. 4 - dockerfile file</summary>

```dockerfile hl_lines="3"
FROM centos:latest
RUN yum update
RUN yum install nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Positive test num. 5 - dockerfile file</summary>

```dockerfile hl_lines="3"
FROM fedora:latest
RUN dnf update
RUN dnf install nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Positive test num. 6 - dockerfile file</summary>

```dockerfile hl_lines="3"
FROM archlinux:latest
RUN pacman -Syu
RUN pacman -S nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Positive test num. 7 - dockerfile file</summary>

```dockerfile hl_lines="3"
FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk update
ENTRYPOINT ["mysql"]
```
</details>


#### Code samples without security vulnerabilities
```dockerfile title="Negative test num. 1 - dockerfile file"
FROM ubuntu:18.04
RUN apt-get update \
    && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk update \
    && apk add --no-cache git ca-certificates
RUN apk --update add easy-rsa
ENTRYPOINT ["mysql"]

```
```dockerfile title="Negative test num. 2 - dockerfile file"
FROM alpine:latest
RUN apk update && apk add nginx
RUN apk --update-cache add vim
RUN apk -U add nano

CMD ["nginx", "-g", "daemon off;"]
```
```dockerfile title="Negative test num. 3 - dockerfile file"
FROM alpine:latest
RUN apk --update add nginx
RUN apk add --update nginx

CMD ["nginx", "-g", "daemon off;"]
```
<details><summary>Negative test num. 4 - dockerfile file</summary>

```dockerfile
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y netcat \
    apt-get update && apt-get install -y supervisor
ENTRYPOINT ["mysql"]

```
</details>
<details><summary>Negative test num. 5 - dockerfile file</summary>

```dockerfile
FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends zend-server-php-5.6=8.5.17+b19 \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/zend/bin/php -r "readfile('https://getcomposer.org/installer');" | /usr/local/zend/bin/php \
    && /usr/local/zend/bin/php composer.phar self-update && /usr/local/zend/bin/php composer.phar update
```
</details>
<details><summary>Negative test num. 6 - dockerfile file</summary>

```dockerfile
FROM archlinux:latest
RUN pacman -Syu && pacman -S nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Negative test num. 7 - dockerfile file</summary>

```dockerfile
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk update
ENTRYPOINT ["mysql"]

```
</details>
<details><summary>Negative test num. 8 - dockerfile file</summary>

```dockerfile
FROM opensuse:latest
RUN zypper refresh && zypper install nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Negative test num. 9 - dockerfile file</summary>

```dockerfile
FROM debian:latest
RUN apt update && install nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Negative test num. 10 - dockerfile file</summary>

```dockerfile
FROM centos:latest
RUN yum update && yum install nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
<details><summary>Negative test num. 11 - dockerfile file</summary>

```dockerfile
FROM fedora:latest
RUN dnf update && dnf install nginx

CMD ["nginx", "-g", "daemon off;"]
```
</details>
