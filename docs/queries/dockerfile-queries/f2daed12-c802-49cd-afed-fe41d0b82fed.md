---
title: Same Alias In Different Froms
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

-   **Query id:** f2daed12-c802-49cd-afed-fe41d0b82fed
-   **Query name:** Same Alias In Different Froms
-   **Platform:** Dockerfile
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Build Process
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/694.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/694.html')">694</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/dockerfile/same_alias_in_different_froms)

### Description
Different FROMS cant have the same alias defined<br>
[Documentation](https://docs.docker.com/develop/develop-images/multistage-build/)

### Code samples
#### Code samples with security vulnerabilities
```dockerfile title="Positive test num. 1 - dockerfile file" hl_lines="4"
FROM baseImage
RUN Test

FROM debian:jesse2 as build
RUN stuff

FROM debian:jesse1 as build
RUN more_stuff

```


#### Code samples without security vulnerabilities
```dockerfile title="Negative test num. 1 - dockerfile file"
FROM debian:jesse1 as build
RUN stuff

FROM debian:jesse1 as another-alias
RUN more_stuff

```
