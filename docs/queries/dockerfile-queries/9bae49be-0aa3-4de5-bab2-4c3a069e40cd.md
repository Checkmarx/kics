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
-   **Severity:** <span style="color:#C60">Medium</span>
-   **Category:** Build Process
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/dockerfile/update_instruction_alone)

### Description
Instruction 'RUN <package-manager> update' should always be followed by '<package-manager> install' in the same RUN statement<br>
[Documentation](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run)

### Code samples
#### Code samples with security vulnerabilities
```dockerfile title="Postitive test num. 1 - dockerfile file" hl_lines="2 5"
FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk update
ENTRYPOINT ["mysql"]

```


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
