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
