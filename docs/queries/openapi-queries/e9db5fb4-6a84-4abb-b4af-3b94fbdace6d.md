---
title: Responses JSON Reference Does Not Exists (v2)
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

-   **Query id:** e9db5fb4-6a84-4abb-b4af-3b94fbdace6d
-   **Query name:** Responses JSON Reference Does Not Exists (v2)
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Structure and Semantics
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/20.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/20.html')">20</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/2.0/json_reference_does_not_exists_response)

### Description
Responses reference should exist on responses definition field<br>
[Documentation](https://swagger.io/specification/v2/#responsesDefinitionsObject)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="14"
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
        "responses": {
          "200": {
            "$ref": "#/responses/Succes"
          }
        }
      }
    }
  },
  "responses": {
    "Success": {
      "description": "An array with users",
      "schema": {
        "$ref": "#/definitions/User"
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
```yaml title="Positive test num. 2 - yaml file" hl_lines="12"
swagger: '2.0'
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
          "$ref": "#/responses/Succes"
responses:
  Success:
    description: An array with users
    schema:
      "$ref": "#/definitions/User"
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
        "responses": {
          "200": {
            "$ref": "#/responses/Success"
          }
        }
      }
    }
  },
  "responses": {
    "Success": {
      "description": "An array with users",
      "schema": {
        "$ref": "#/definitions/User"
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
      responses:
        '200':
          "$ref": "#/responses/Success"
responses:
  Success:
    description: An array with users
    schema:
      "$ref": "#/definitions/User"
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
