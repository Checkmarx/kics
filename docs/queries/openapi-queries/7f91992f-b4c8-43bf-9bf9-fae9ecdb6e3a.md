---
title: File Parameter With Wrong Consumes Property
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

-   **Query id:** 7f91992f-b4c8-43bf-9bf9-fae9ecdb6e3a
-   **Query name:** File Parameter With Wrong Consumes Property
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Structure and Semantics
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/20.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/20.html')">20</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/2.0/file_parameter_with_wrong_consumes_property)

### Description
Operations file parameters consumes must be 'multipart/form-data', 'application/x-www-form-urlencoded' or both<br>
[Documentation](https://swagger.io/specification/v2/#operation-object)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="12"
{
  "swagger": "2.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {
    "/": {
      "get": {
        "operationId": "listVersionsv2",
        "summary": "List API versions",
        "parameters": [
          {
            "name": "File",
            "type": "file",
            "in": "formData"
          }
        ],
        "consumes": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "200 response"
          }
        }
      }
    }
  },
  "definitions": {
    "User": {
      "type": "object",
      "required": [
        "id",
        "name"
      ],
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "name": {
          "type": "string"
        }
      }
    }
  }
}

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="10"
swagger: '2.0'
info:
  title: Simple API Overview
  version: 1.0.0
paths:
  "/":
    get:
      operationId: listVersionsv2
      summary: List API versions
      parameters:
      - name: File
        type: file
        in: formData
      consumes:
      - application/json
      responses:
        '200':
          description: 200 response
definitions:
  User:
    type: object
    required:
    - id
    - name
    properties:
      id:
        type: integer
        format: int64
      name:
        type: string

```


#### Code samples without security vulnerabilities
```json title="Negative test num. 1 - json file"
{
  "swagger": "2.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {
    "/": {
      "get": {
        "operationId": "listVersionsv2",
        "summary": "List API versions",
        "parameters": [
          {
            "name": "File",
            "type": "file",
            "in": "formData"
          }
        ],
        "consumes": [
          "multipart/form-data"
        ],
        "responses": {
          "200": {
            "description": "200 response"
          }
        }
      }
    }
  },
  "definitions": {
    "User": {
      "type": "object",
      "required": [
        "id",
        "name"
      ],
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "name": {
          "type": "string"
        }
      }
    }
  }
}

```
```yaml title="Negative test num. 2 - yaml file"
swagger: '2.0'
info:
  title: Simple API Overview
  version: 1.0.0
paths:
  "/":
    get:
      operationId: listVersionsv2
      summary: List API versions
      parameters:
      - name: File
        type: file
        in: formData
      consumes:
      - multipart/form-data
      responses:
        '200':
          description: 200 response
definitions:
  User:
    type: object
    required:
    - id
    - name
    properties:
      id:
        type: integer
        format: int64
      name:
        type: string

```
