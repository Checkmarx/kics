---
title: Global Parameter Definition Not Being Used
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

-   **Query id:** b30981fa-a12e-49c7-a5bb-eeafb61d0f0f
-   **Query name:** Global Parameter Definition Not Being Used
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Best Practices
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/710.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/710.html')">710</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/2.0/unused_parameter_definition)

### Description
All global parameters definitions should be in use<br>
[Documentation](https://swagger.io/specification/v2/#parametersDefinitionsObject)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="26"
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
            "description": "200 response"
          }
        },
        "parameters": [
          {
            "$ref": "#/parameters/limitParame"
          }
        ]
      }
    }
  },
  "parameters": {
    "limitParam": {
      "name": "limit",
      "in": "body",
      "description": "max records to return",
      "required": true,
      "schema": {
        "type": "string"
      }
    }
  }
}

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="16"
swagger: "2.0"
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
      parameters:
        - "$ref": "#/parameters/limitParame"
parameters:
  limitParam:
    name: limit
    in: body
    description: max records to return
    required: true
    schema:
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
            "description": "200 response"
          }
        },
        "parameters": [
          {
            "$ref": "#/parameters/limitParam"
          }
        ]
      }
    }
  },
  "parameters": {
    "limitParam": {
      "name": "limit",
      "in": "body",
      "description": "max records to return",
      "required": true,
      "schema": {
        "type": "string"
      }
    }
  }
}

```
```yaml title="Negative test num. 2 - yaml file"
swagger: "2.0"
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
      parameters:
        - "$ref": "#/parameters/limitParam"
parameters:
  limitParam:
    name: limit
    in: body
    description: max records to return
    required: true
    schema:
      type: string

```
