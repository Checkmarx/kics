---
title: Schema Object Properties With Duplicated Keys (v3)
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

-   **Query id:** 10c61e4b-eed5-49cf-9c7d-d4bf02e9edfa
-   **Query name:** Schema Object Properties With Duplicated Keys (v3)
-   **Platform:** OpenAPI
-   **Severity:** <span style="color:#5bc0de">Info</span>
-   **Category:** Structure and Semantics
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/20.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/20.html')">20</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/openAPI/general/schema_object_properties_with_duplicated_keys)

### Description
Schema Object Property key should be unique through out the fields 'properties', 'allOf', 'additionalProperties'<br>
[Documentation](https://swagger.io/specification/#schema-object)

### Code samples
#### Code samples with security vulnerabilities
```json title="Positive test num. 1 - json file" hl_lines="19 53 38"
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
  "paths": {},
  "components": {
    "schemas": {
      "ErrorModel": {
        "type": "object",
        "required": [
          "message",
          "code"
        ],
        "properties": {
          "message": {
            "type": "string"
          },
          "code": {
            "type": "integer",
            "minimum": 100,
            "maximum": 600
          }
        },
        "allOf": [
          {
            "$ref": "#/components/schemas/ErrorModel"
          },
          {
            "type": "object",
            "required": [
              "code"
            ],
            "properties": {
              "code": {
                "type": "integer",
                "minimum": 100,
                "maximum": 600
              }
            }
          }
        ],
        "additionalProperties": [
          {
            "type": "object",
            "required": [
              "code"
            ],
            "properties": {
              "code": {
                "type": "string"
              }
            }
          }
        ]
      }
    }
  }
}

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="16 28 37"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
  contact:
    name: contact
    url: https://www.google.com/
    email: user@gmail.c
paths: {}
components:
  schemas:
    ErrorModel:
      type: object
      required:
        - message
        - code
      properties:
        message:
          type: string
        code:
          type: integer
          minimum: 100
          maximum: 600
      allOf:
        - "$ref": "#/components/schemas/ErrorModel"
        - type: object
          required:
            - code
          properties:
            code:
              type: integer
              minimum: 100
              maximum: 600
      additionalProperties:
        - type: object
          required:
            - code
          properties:
            code:
              type: string

```
```json title="Positive test num. 3 - json file" hl_lines="57 28 44"
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
                "schema": {
                  "type": "object",
                  "discriminator": {
                    "propertyName": "petType"
                  },
                  "properties": {
                    "message": {
                      "type": "string"
                    },
                    "code": {
                      "type": "integer",
                      "minimum": 100,
                      "maximum": 600
                    }
                  },
                  "allOf": [
                    {
                      "$ref": "#/components/schemas/ErrorModel"
                    },
                    {
                      "type": "object",
                      "required": [
                        "message"
                      ],
                      "properties": {
                        "message": {
                          "type": "string"
                        }
                      }
                    }
                  ],
                  "additionalProperties": [
                    {
                      "type": "object",
                      "required": [
                        "message"
                      ],
                      "properties": {
                        "message": {
                          "type": "string"
                        }
                      }
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

```
<details><summary>Positive test num. 4 - yaml file</summary>

```yaml hl_lines="24 41 34"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
  contact:
    name: contact
    url: https://www.google.com/
    email: user@gmail.c
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
                  message:
                    type: string
                  code:
                    type: integer
                    minimum: 100
                    maximum: 600
                allOf:
                  - "$ref": "#/components/schemas/ErrorModel"
                  - type: object
                    required:
                      - message
                    properties:
                      message:
                        type: string
                additionalProperties:
                  - type: object
                    required:
                      - message
                    properties:
                      message:
                        type: string

```
</details>
<details><summary>Positive test num. 5 - json file</summary>

```json hl_lines="57 28 44"
{
  "swagger": "2.0",
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
                "schema": {
                  "type": "object",
                  "discriminator": {
                    "propertyName": "petType"
                  },
                  "properties": {
                    "message": {
                      "type": "string"
                    },
                    "code": {
                      "type": "integer",
                      "minimum": 100,
                      "maximum": 600
                    }
                  },
                  "allOf": [
                    {
                      "$ref": "#/definitions/ErrorModel"
                    },
                    {
                      "type": "object",
                      "required": [
                        "message"
                      ],
                      "properties": {
                        "message": {
                          "type": "string"
                        }
                      }
                    }
                  ],
                  "additionalProperties": [
                    {
                      "type": "object",
                      "required": [
                        "message"
                      ],
                      "properties": {
                        "message": {
                          "type": "string"
                        }
                      }
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

```
</details>
<details><summary>Positive test num. 6 - yaml file</summary>

```yaml hl_lines="24 41 34"
swagger: '2.0'
info:
  title: Simple API Overview
  version: 1.0.0
  contact:
    name: contact
    url: https://www.google.com/
    email: user@gmail.c
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
              schema:
                type: object
                discriminator:
                  propertyName: petType
                properties:
                  message:
                    type: string
                  code:
                    type: integer
                    minimum: 100
                    maximum: 600
                allOf:
                - "$ref": "#/definitions/ErrorModel"
                - type: object
                  required:
                  - message
                  properties:
                    message:
                      type: string
                additionalProperties:
                - type: object
                  required:
                  - message
                  properties:
                    message:
                      type: string

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
  "paths": {},
  "components": {
    "schemas": {
      "ErrorModel": {
        "type": "object",
        "required": [
          "message",
          "code"
        ],
        "properties": {
          "message": {
            "type": "string"
          },
          "code": {
            "type": "integer",
            "minimum": 100,
            "maximum": 600
          }
        },
        "allOf": [
          {
            "$ref": "#/components/schemas/ErrorModel"
          },
          {
            "type": "object",
            "required": [
              "rootCause"
            ],
            "properties": {
              "rootCause": {
                "type": "string"
              }
            }
          }
        ]
      },
      "ErrorModel_2": {
        "type": "object",
        "required": [
          "message2",
          "code2"
        ],
        "properties": {
          "message2": {
            "type": "string"
          },
          "code2": {
            "type": "integer",
            "minimum": 100,
            "maximum": 600
          }
        },
        "allOf": [
          {
            "$ref": "#/components/schemas/ErrorModel"
          },
          {
            "type": "object",
            "required": [
              "rootCause2"
            ],
            "properties": {
              "rootCause2": {
                "type": "string"
              }
            }
          }
        ]
      }
    }
  }
}

```
```yaml title="Negative test num. 2 - yaml file"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
  contact:
    name: contact
    url: https://www.google.com/
    email: user@gmail.c
paths: {}
components:
  schemas:
    ErrorModel:
      type: object
      required:
        - message
        - code
      properties:
        message:
          type: string
        code:
          type: integer
          minimum: 100
          maximum: 600
      allOf:
        - "$ref": "#/components/schemas/ErrorModel"
        - type: object
          required:
            - rootCause
          properties:
            rootCause:
              type: string
    ErrorModel_2:
      type: object
      required:
        - message2
        - code2
      properties:
        message2:
          type: string
        code2:
          type: integer
          minimum: 100
          maximum: 600
      allOf:
        - "$ref": "#/components/schemas/ErrorModel"
        - type: object
          required:
            - rootCause2
          properties:
            rootCause2:
              type: string

```
```json title="Negative test num. 3 - json file"
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
                "schema": {
                  "type": "object",
                  "discriminator": {
                    "propertyName": "petType"
                  },
                  "properties": {
                    "message": {
                      "type": "string"
                    },
                    "code": {
                      "type": "integer",
                      "minimum": 100,
                      "maximum": 600
                    }
                  },
                  "allOf": [
                    {
                      "$ref": "#/components/schemas/ErrorModel"
                    },
                    {
                      "type": "object",
                      "required": [
                        "rootCause"
                      ],
                      "properties": {
                        "rootCause": {
                          "type": "string"
                        }
                      }
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

```
<details><summary>Negative test num. 4 - yaml file</summary>

```yaml
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
  contact:
    name: contact
    url: https://www.google.com/
    email: user@gmail.c
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
                  message:
                    type: string
                  code:
                    type: integer
                    minimum: 100
                    maximum: 600
                allOf:
                  - "$ref": "#/components/schemas/ErrorModel"
                  - type: object
                    required:
                      - rootCause
                    properties:
                      rootCause:
                        type: string

```
</details>
<details><summary>Negative test num. 5 - json file</summary>

```json
{
  "swagger": "2.0",
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
                "schema": {
                  "type": "object",
                  "discriminator": {
                    "propertyName": "petType"
                  },
                  "properties": {
                    "message": {
                      "type": "string"
                    },
                    "code": {
                      "type": "integer",
                      "minimum": 100,
                      "maximum": 600
                    }
                  },
                  "allOf": [
                    {
                      "$ref": "#/definitions/ErrorModel"
                    },
                    {
                      "type": "object",
                      "required": [
                        "rootCause"
                      ],
                      "properties": {
                        "rootCause": {
                          "type": "string"
                        }
                      }
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

```
</details>
<details><summary>Negative test num. 6 - yaml file</summary>

```yaml
swagger: '2.0'
info:
  title: Simple API Overview
  version: 1.0.0
  contact:
    name: contact
    url: https://www.google.com/
    email: user@gmail.c
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
              schema:
                type: object
                discriminator:
                  propertyName: petType
                properties:
                  message:
                    type: string
                  code:
                    type: integer
                    minimum: 100
                    maximum: 600
                allOf:
                - "$ref": "#/definitions/ErrorModel"
                - type: object
                  required:
                  - rootCause
                  properties:
                    rootCause:
                      type: string

```
</details>
