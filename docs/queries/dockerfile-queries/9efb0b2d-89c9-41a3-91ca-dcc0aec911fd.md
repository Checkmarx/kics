---
title: Image Version Not Explicit
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

-   **Query id:** 9efb0b2d-89c9-41a3-91ca-dcc0aec911fd
-   **Query name:** Image Version Not Explicit
-   **Platform:** Dockerfile
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Supply-Chain
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/1357.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/1357.html')">1357</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/dockerfile/image_version_not_explicit)

### Description
Always tag the version of an image explicitly<br>
[Documentation](https://docs.docker.com/engine/reference/builder/#from)

### Code samples
#### Code samples with security vulnerabilities
```dockerfile title="Positive test num. 1 - dockerfile file" hl_lines="1"
FROM alpine
RUN apk add --update py2-pip
RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"] 
```
```dockerfile title="Positive test num. 2 - dockerfile file" hl_lines="7"
FROM ubuntu:22.04 AS test
RUN echo "hello"

FROM test AS build
RUN echo "build"

FROM construction AS final
RUN echo "final"
```
```dockerfile title="Positive test num. 3 - dockerfile file" hl_lines="4 7"
FROM ubuntu:22.04 AS test
RUN echo "hello"

FROM positive4 
RUN echo "positive4"

FROM positive42
RUN echo "positive42"
```
<details><summary>Positive test num. 4 - dockerfile file</summary>

```dockerfile hl_lines="10 7"
FROM ubuntu:22.04 AS test1
RUN echo "depth"

FROM test1 AS test2
RUN echo "depth"

FROM test_fail_1
RUN echo "depth"

FROM test3 AS test_fail_2
RUN echo "depth"

FROM test2 AS test3
RUN echo "depth"

FROM test3 AS test_fail_1
RUN echo "depth"
```
</details>


#### Code samples without security vulnerabilities
```dockerfile title="Negative test num. 1 - dockerfile file"
FROM alpine:3.5
RUN apk add --update py2-pip
RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
ARG IMAGE=alpine:3.12
FROM $IMAGE
CMD ["python", "/usr/src/app/app.py"]

```
```dockerfile title="Negative test num. 2 - dockerfile file"
FROM ubuntu:22.04 AS test
RUN echo "hello"

FROM test AS build
RUN echo "build"

FROM build AS final
RUN echo "final"
```
```dockerfile title="Negative test num. 3 - dockerfile file"
FROM ubuntu@sha256:b59d21599a2b151e23eea5f6602f4af4d7d31c4e236d22bf0b62b86d2e386b8f as base
RUN echo "base"

FROM base
RUN echo "stage1"

```
<details><summary>Negative test num. 4 - dockerfile file</summary>

```dockerfile
FROM ubuntu:22.04 AS test1
RUN echo "depth1"

FROM test1 AS test2
RUN echo "depth2"

FROM test2 AS test3
RUN echo "depth3"

FROM test3 AS test4
RUN echo "depth4"

FROM test4 
RUN echo "depth5"
```
</details>
