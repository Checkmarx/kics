---
title: COPY '--from' References Current FROM Alias
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

-   **Query id:** cdddb86f-95f6-4fc4-b5a1-483d9afceb2b
-   **Query name:** COPY '--from' References Current FROM Alias
-   **Platform:** Dockerfile
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Build Process
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/706.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/706.html')">706</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/dockerfile/copy_from_references_current_from_alias)

### Description
COPY '--from' should not mention the current FROM alias, since it is impossible to copy from itself<br>
[Documentation](https://docs.docker.com/develop/develop-images/multistage-build/)

### Code samples
#### Code samples with security vulnerabilities
```dockerfile title="Positive test num. 1 - dockerfile file" hl_lines="2"
FROM myimage:tag as dep
COPY --from=dep /binary /
RUN dir c:\ 
```


#### Code samples without security vulnerabilities
```dockerfile title="Negative test num. 1 - dockerfile file"
FROM golang:1.7.3 AS builder
WORKDIR /go/src/github.com/foo/href-counter/
RUN go get -d -v golang.org/x/net/html
COPY app.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# another dockerfile
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/foo/href-counter/app .
CMD ["./app"]

```
