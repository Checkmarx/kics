---
title: Example JSON Reference Outside Components Examples
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

-   **Query id:** bac56e3c-1f71-4a74-8ae6-2fba07efcddb
-   **Query name:** Example JSON Reference Outside Components Examples
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Structure and Semantics
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/20.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/20.html')">20</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/3.0/example_json_reference_outside_components_examples)

### Description
Reference to examples should point to #/components/examples<br>
[Documentation](https://swagger.io/specification/#reference-object)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="77"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API overview",
    "version": "1.0.0"
  },
  "components": {
    "securitySchemes": {
      "regularSecurity": {
        "type": "http",
        "scheme": "basic"
      }
    },
    "schemas": {
      "ErrorModel": {
        "type": "object",
        "properties": {
          "code": {
            "type": "string"
          }
        }
      },
      "Address": {
        "type": "object",
        "properties": {
          "street": {
            "type": "string"
          }
        },
        "required": [
          "street"
        ]
      }
    }
  },
  "paths": {
    "/": {
      "post": {
        "operationId": "updateAddress",
        "summary": "updateAddress",
        "servers": [
          {
            "url": "http://kicsapi.com/",
            "description": "server URL"
          }
        ],
        "responses": {
          "200": {
            "description": "a pet to be returned",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Address"
                }
              }
            }
          },
          "default": {
            "description": "Unexpected error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorModel"
                }
              }
            }
          }
        },
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Address"
              },
              "examples": {
                "Address": {
                  "$ref": "#/components/schemas/Address"
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
```yaml title="Positive test num. 2 - yaml file" hl_lines="51"
openapi: 3.0.0
info:
  title: Simple API overview
  version: 1.0.0
components:
  securitySchemes:
    regularSecurity:
      type: http
      scheme: basic
  schemas:
    ErrorModel:
      type: object
      properties:
        code:
          type: string
    Address:
      type: object
      properties:
        street:
          type: string
      required:
        - street
paths:
  "/":
    post:
      operationId: updateAddress
      summary: updateAddress
      servers:
        - url: http://kicsapi.com/
          description: server URL
      responses:
        '200':
          description: a pet to be returned
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Address'
        default:
          description: Unexpected error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorModel'
      requestBody:
        content:
          'application/json':
            schema:
              $ref: '#/components/schemas/Address'
            examples:
              Address:
                $ref: '#/components/schemas/Address'

```


#### Code samples without security vulnerabilities
```json title="Negative test num. 1 - json file"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API overview",
    "version": "1.0.0"
  },
  "components": {
    "securitySchemes": {
      "regularSecurity": {
        "type": "http",
        "scheme": "basic"
      }
    },
    "schemas": {
      "ErrorModel": {
        "type": "object",
        "properties": {
          "code": {
            "type": "string"
          }
        }
      },
      "Address": {
        "type": "object",
        "properties": {
          "street": {
            "type": "string"
          }
        },
        "required": [
          "street"
        ]
      }
    },
    "examples": {
      "Address": {
        "summary": "user address",
        "value": {
          "street": "my street"
        }
      }
    }
  },
  "paths": {
    "/": {
      "post": {
        "operationId": "updateAddress",
        "summary": "updateAddress",
        "servers": [
          {
            "url": "http://kicsapi.com/",
            "description": "server URL"
          }
        ],
        "responses": {
          "200": {
            "description": "a pet to be returned",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Address"
                }
              }
            }
          },
          "default": {
            "description": "Unexpected error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorModel"
                }
              }
            }
          }
        },
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Address"
              },
              "examples": {
                "Address": {
                  "$ref": "#/components/examples/Address"
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
```yaml title="Negative test num. 2 - yaml file"
openapi: 3.0.0
info:
  title: Simple API overview
  version: 1.0.0
components:
  securitySchemes:
    regularSecurity:
      type: http
      scheme: basic
  schemas:
    ErrorModel:
      type: object
      properties:
        code:
          type: string
    Address:
      type: object
      properties:
        street:
          type: string
      required:
        - street
  examples:
    Address:
      summary: user address
      value: { "street": "my street" }
paths:
  "/":
    post:
      operationId: updateAddress
      summary: updateAddress
      servers:
        - url: http://kicsapi.com/
          description: server URL
      responses:
        '200':
          description: a pet to be returned
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Address'
        default:
          description: Unexpected error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorModel'
      requestBody:
        content:
          'application/json':
            schema:
              $ref: '#/components/schemas/Address'
            examples:
              Address:
                $ref: '#/components/examples/Address'

```
