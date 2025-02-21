---
title: Servers Array Undefined
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

-   **Query id:** c66ebeaa-676c-40dc-a3ff-3e49395dcd5e
-   **Query name:** Servers Array Undefined
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Structure and Semantics
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/665.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/665.html')">665</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/3.0/servers_undefined)

### Description
The Servers array should have at least one server defined. If not, the default value would be a Server Object with a URL value of '/'.<br>
[Documentation](https://swagger.io/specification/#server-object)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="2"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {
    "/": {
      "get": {
        "operationId": "listVersionsv2",
        "summary": "List API versions",
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": {
                      "versions": [
                        {
                          "status": "CURRENT",
                          "updated": "2011-01-21T11:33:21Z",
                          "id": "v2.0",
                          "links": [
                            {
                              "href": "http://127.0.0.1:8774/v2/",
                              "rel": "self"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

```
```json title="Positive test num. 2 - json file" hl_lines="43"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {
    "/": {
      "get": {
        "operationId": "listVersionsv2",
        "summary": "List API versions",
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": {
                      "versions": [
                        {
                          "status": "CURRENT",
                          "updated": "2011-01-21T11:33:21Z",
                          "id": "v2.0",
                          "links": [
                            {
                              "href": "http://127.0.0.1:8774/v2/",
                              "rel": "self"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "servers": []
}

```
```yaml title="Positive test num. 3 - yaml file" hl_lines="1"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
paths:
  "/":
    get:
      operationId: listVersionsv2
      summary: List API versions
      responses:
        '200':
          description: 200 response
          content:
            application/json:
              examples:
                foo:
                  value:
                    versions:
                    - status: CURRENT
                      updated: '2011-01-21T11:33:21Z'
                      id: v2.0
                      links:
                      - href: http://127.0.0.1:8774/v2/
                        rel: self

```
<details><summary>Positive test num. 4 - yaml file</summary>

```yaml hl_lines="25"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
paths:
  "/":
    get:
      operationId: listVersionsv2
      summary: List API versions
      responses:
        '200':
          description: 200 response
          content:
            application/json:
              examples:
                foo:
                  value:
                    versions:
                    - status: CURRENT
                      updated: '2011-01-21T11:33:21Z'
                      id: v2.0
                      links:
                      - href: http://127.0.0.1:8774/v2/
                        rel: self
servers: []

```
</details>


#### Code samples without security vulnerabilities
```json title="Negative test num. 1 - json file"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {
    "/": {
      "get": {
        "operationId": "listVersionsv2",
        "summary": "List API versions",
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": {
                      "versions": [
                        {
                          "status": "CURRENT",
                          "updated": "2011-01-21T11:33:21Z",
                          "id": "v2.0",
                          "links": [
                            {
                              "href": "http://127.0.0.1:8774/v2/",
                              "rel": "self"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "servers": [
    {
      "url": "https://my.api.server.com/",
      "description": "My API Server"
    }
  ]
}

```
```yaml title="Negative test num. 2 - yaml file"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
paths:
  "/":
    get:
      operationId: listVersionsv2
      summary: List API versions
      responses:
        '200':
          description: 200 response
          content:
            application/json:
              examples:
                foo:
                  value:
                    versions:
                    - status: CURRENT
                      updated: '2011-01-21T11:33:21Z'
                      id: v2.0
                      links:
                      - href: http://127.0.0.1:8774/v2/
                        rel: self
servers:
  url: https://my.api.server.com/
  description: My API server

```
