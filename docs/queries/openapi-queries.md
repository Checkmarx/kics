## OpenAPI Queries List
This page contains all queries from OpenAPI.

|            Query            |Severity|Category|Description|Help|
|-----------------------------|--------|--------|-----------|----|
|Global security field has an empty object<br/><sup><sub>543e38f4-1eee-479e-8eb0-15257013aa0a</sub></sup>|<span style="color:#C00">High</span>|Access Control|Global security definition must not have empty objects|<a href="https://swagger.io/specification/#security-requirement-object">Documentation</a><br/>|
|Global security field has an empty array<br/><sup><sub>d674aea4-ba8b-454b-bb97-88a772ea33f0</sub></sup>|<span style="color:#C00">High</span>|Access Control|Security object need to be defined with a default values and, if needed, specified for particular cases on securityScheme|<a href="https://swagger.io/specification/#security-requirement-object">Documentation</a><br/>|
|Global Server Object Uses HTTP<br/><sup><sub>2d8c175a-6d90-412b-8b0e-e034ea49a1fe</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|Global server object URL should use 'https' protocol instead of 'http'|<a href="https://swagger.io/specification/#server-object">Documentation</a><br/>|
|Path Server Object Uses HTTP<br/><sup><sub>9670f240-7b4d-4955-bd93-edaa9fa38b58</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|The property 'url' in the Path Server Object should only allow 'HTTPS' protocols to ensure an encrypted connection|<a href="https://swagger.io/specification/#server-object">Documentation</a><br/>|
