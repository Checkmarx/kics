---
title: Encoding Map Key Mismatch Schema Defined Properties
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

-   **Query id:** cd7a52cf-8d7f-4cfe-bbeb-6306d23f576b
-   **Query name:** Encoding Map Key Mismatch Schema Defined Properties
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Structure and Semantics
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/20.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/20.html')">20</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/3.0/encoding_map_key_mismatch_schema_defined_properties)

### Description
Encoding Map Key should be set in schema defined properties<br>
[Documentation](https://swagger.io/specification/#media-type-object)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="70"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0",
    "contact": {
      "name": "contact",
      "url": "https://www.google.com/",
      "email": "user@gmail.c"
    }
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
  "components": {
    "responses": {
      "ResponseExample": {
        "description": "200 response",
        "content": {
          "application/json": {
            "schema": {
              "discriminator": {
                "propertyName": "petType"
              },
              "properties": {
                "code": {
                  "type": "string",
                  "format": "binary"
                },
                "message": {
                  "type": "string"
                }
              },
              "type": "object"
            },
            "encoding": {
              "profileImage": {
                "contentType": "image/png, image/jpeg"
              }
            }
          }
        }
      }
    }
  }
}

```
```json title="Positive test num. 2 - json file" hl_lines="36"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0",
    "contact": {
      "name": "contact",
      "url": "https://www.google.com/",
      "email": "user@gmail.c"
    }
  },
  "paths": {
    "/": {
      "get": {
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "discriminator": {
                    "propertyName": "petType"
                  },
                  "properties": {
                    "code": {
                      "type": "string",
                      "format": "binary"
                    },
                    "message": {
                      "type": "string"
                    }
                  }
                },
                "encoding": {
                  "profileImage": {
                    "contentType": "image/png, image/jpeg"
                  }
                }
              }
            }
          }
        },
        "operationId": "listVersionsv2",
        "summary": "List API versions"
      }
    }
  }
}

```
```yaml title="Positive test num. 3 - yaml file" hl_lines="42"
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
        "200":
          description: 200 response
          content:
            application/json:
              examples:
                foo:
                  value:
                    versions:
                      - status: CURRENT
                        updated: "2011-01-21T11:33:21Z"
                        id: v2.0
                        links:
                          - href: http://127.0.0.1:8774/v2/
                            rel: self
components:
  responses:
    ResponseExample:
      description: 200 response
      content:
        application/json:
          schema:
            type: object
            discriminator:
              propertyName: petType
            properties:
              code:
                type: string
                format: binary
              message:
                type: string
          encoding:
            profileImage:
              contentType: image/png, image/jpeg

```
<details><summary>Positive test num. 4 - yaml file</summary>

```yaml hl_lines="26"
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
        "200":
          description: 200 response
          content:
            application/json:
              schema:
                type: object
                discriminator:
                  propertyName: petType
                properties:
                  code:
                    type: string
                    format: binary
                  message:
                    type: string
              encoding:
                profileImage:
                  contentType: image/png, image/jpeg

```
</details>


#### Code samples without security vulnerabilities
```json title="Negative test num. 1 - json file"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0",
    "contact": {
      "name": "contact",
      "url": "https://www.google.com/",
      "email": "user@gmail.c"
    }
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
  "components": {
    "responses": {
      "ResponseExample": {
        "description": "200 response",
        "content": {
          "application/json": {
            "schema": {
              "discriminator": {
                "propertyName": "petType"
              },
              "properties": {
                "code": {
                  "type": "string",
                  "format": "binary"
                },
                "message": {
                  "type": "string"
                }
              },
              "type": "object"
            },
            "encoding": {
              "code": {
                "contentType": "image/png, image/jpeg"
              }
            }
          }
        }
      }
    }
  }
}

```
```json title="Negative test num. 2 - json file"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0",
    "contact": {
      "name": "contact",
      "url": "https://www.google.com/",
      "email": "user@gmail.c"
    }
  },
  "paths": {
    "/": {
      "get": {
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "discriminator": {
                    "propertyName": "petType"
                  },
                  "properties": {
                    "code": {
                      "type": "string",
                      "format": "binary"
                    },
                    "message": {
                      "type": "string"
                    }
                  }
                },
                "encoding": {
                  "code": {
                    "contentType": "image/png, image/jpeg"
                  }
                }
              }
            }
          }
        },
        "operationId": "listVersionsv2",
        "summary": "List API versions"
      }
    }
  }
}

```
```yaml title="Negative test num. 3 - yaml file"
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
        "200":
          description: 200 response
          content:
            application/json:
              examples:
                foo:
                  value:
                    versions:
                      - status: CURRENT
                        updated: "2011-01-21T11:33:21Z"
                        id: v2.0
                        links:
                          - href: http://127.0.0.1:8774/v2/
                            rel: self
components:
  responses:
    ResponseExample:
      description: 200 response
      content:
        application/json:
          schema:
            type: object
            discriminator:
              propertyName: petType
            properties:
              code:
                type: string
                format: binary
              message:
                type: string
          encoding:
            code:
              contentType: image/png, image/jpeg

```
<details><summary>Negative test num. 4 - yaml file</summary>

```yaml
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
        "200":
          description: 200 response
          content:
            application/json:
              schema:
                type: object
                discriminator:
                  propertyName: petType
                properties:
                  code:
                    type: string
                    format: binary
                  message:
                    type: string
              encoding:
                code:
                  contentType: image/png, image/jpeg

```
</details>
