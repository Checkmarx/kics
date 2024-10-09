## Pulumi Queries List
This page contains all queries from Pulumi.

### AWS
Below are listed queries related to Pulumi AWS:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|Amazon DMS Replication Instance Is Publicly Accessible<br/><sup><sub>bccb296f-362c-4b05-9221-86d1437a1016</sub></sup>|<span style="color:#ff0000">Critical</span>|Access Control|<a href="../pulumi-queries/aws/bccb296f-362c-4b05-9221-86d1437a1016" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/bccb296f-362c-4b05-9221-86d1437a1016')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/dms/replicationinstance/">Documentation</a><br/>|
|DynamoDB Table Not Encrypted<br/><sup><sub>b6a7e0ae-aed8-4a19-a993-a95760bf8836</sub></sup>|<span style="color:#bb2124">High</span>|Encryption|<a href="../pulumi-queries/aws/b6a7e0ae-aed8-4a19-a993-a95760bf8836" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/b6a7e0ae-aed8-4a19-a993-a95760bf8836')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/dynamodb/table/#serversideencryption_yaml">Documentation</a><br/>|
|ElastiCache Nodes Not Created Across Multi AZ<br/><sup><sub>9b18fc19-7fb8-49b1-8452-9c757c70f926</sub></sup>|<span style="color:#ff7213">Medium</span>|Availability|<a href="../pulumi-queries/aws/9b18fc19-7fb8-49b1-8452-9c757c70f926" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/9b18fc19-7fb8-49b1-8452-9c757c70f926')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticache/cluster/#azmode_yaml">Documentation</a><br/>|
|ElastiCache Redis Cluster Without Backup<br/><sup><sub>e93bbe63-a631-4c0f-b6ef-700d48441ff2</sub></sup>|<span style="color:#ff7213">Medium</span>|Backup|<a href="../pulumi-queries/aws/e93bbe63-a631-4c0f-b6ef-700d48441ff2" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/e93bbe63-a631-4c0f-b6ef-700d48441ff2')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticache/cluster/#snapshotretentionlimit_yaml">Documentation</a><br/>|
|API Gateway Without SSL Certificate<br/><sup><sub>f27791a5-e2ae-4905-8910-6f995c576d09</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../pulumi-queries/aws/f27791a5-e2ae-4905-8910-6f995c576d09" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/f27791a5-e2ae-4905-8910-6f995c576d09')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/apigatewayv2/stage/#clientcertificateid_yaml">Documentation</a><br/>|
|RDS DB Instance Publicly Accessible<br/><sup><sub>647de8aa-5a42-41b5-9faf-22136f117380</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../pulumi-queries/aws/647de8aa-5a42-41b5-9faf-22136f117380" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/647de8aa-5a42-41b5-9faf-22136f117380')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/rds/instance/#publiclyaccessible_yaml">Documentation</a><br/>|
|Elasticsearch with HTTPS disabled<br/><sup><sub>00603add-7f72-448f-a6c0-9e456a7a3f94</sub></sup>|<span style="color:#ff7213">Medium</span>|Networking and Firewall|<a href="../pulumi-queries/aws/00603add-7f72-448f-a6c0-9e456a7a3f94" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/00603add-7f72-448f-a6c0-9e456a7a3f94')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticsearch/domain/#enforcehttps_yaml">Documentation</a><br/>|
|API Gateway Access Logging Disabled<br/><sup><sub>bf4b48b9-fc1f-4552-984a-4becdb5bf503</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../pulumi-queries/aws/bf4b48b9-fc1f-4552-984a-4becdb5bf503" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/bf4b48b9-fc1f-4552-984a-4becdb5bf503')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/apigatewayv2/stage/#accesslogsettings_yaml">Documentation</a><br/>|
|DocDB Logging Is Disabled<br/><sup><sub>2ca87964-fe7e-4cdc-899c-427f0f3525f8</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../pulumi-queries/aws/2ca87964-fe7e-4cdc-899c-427f0f3525f8" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/2ca87964-fe7e-4cdc-899c-427f0f3525f8')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/docdb/cluster/#enabledcloudwatchlogsexports_yaml">Documentation</a><br/>|
|EC2 Instance Monitoring Disabled<br/><sup><sub>daa581ef-731c-4121-832d-cf078f67759d</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../pulumi-queries/aws/daa581ef-731c-4121-832d-cf078f67759d" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/daa581ef-731c-4121-832d-cf078f67759d')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/ec2/instance/#monitoring_yaml">Documentation</a><br/>|
|Elasticsearch Logs Disabled<br/><sup><sub>a1120ee4-a712-42d9-8fb5-22595fed643b</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../pulumi-queries/aws/a1120ee4-a712-42d9-8fb5-22595fed643b" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/a1120ee4-a712-42d9-8fb5-22595fed643b')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticsearch/domain/#logpublishingoptions_yaml">Documentation</a><br/>|
|IAM Password Without Minimum Length<br/><sup><sub>9850d621-7485-44f7-8bdd-b3cf426315cf</sub></sup>|<span style="color:#edd57e">Low</span>|Best Practices|<a href="../pulumi-queries/aws/9850d621-7485-44f7-8bdd-b3cf426315cf" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/9850d621-7485-44f7-8bdd-b3cf426315cf')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/iam/accountpasswordpolicy/#minimumpasswordlength_yaml">Documentation</a><br/>|
|ECS Cluster with Container Insights Disabled<br/><sup><sub>abcefee4-a0c1-4245-9f82-a473f79a9e2f</sub></sup>|<span style="color:#edd57e">Low</span>|Observability|<a href="../pulumi-queries/aws/abcefee4-a0c1-4245-9f82-a473f79a9e2f" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/abcefee4-a0c1-4245-9f82-a473f79a9e2f')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/ecs/cluster/#settings_yaml">Documentation</a><br/>|
|DynamoDB Table Point In Time Recovery Disabled<br/><sup><sub>327b0729-4c5c-4c44-8b5c-e476cd9c7290</sub></sup>|<span style="color:#5bc0de">Info</span>|Best Practices|<a href="../pulumi-queries/aws/327b0729-4c5c-4c44-8b5c-e476cd9c7290" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/327b0729-4c5c-4c44-8b5c-e476cd9c7290')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/dynamodb/table/#pointintimerecovery_yaml">Documentation</a><br/>|
|EC2 Not EBS Optimized<br/><sup><sub>d991e4ae-42ab-429b-ab43-d5e5fa9ca633</sub></sup>|<span style="color:#5bc0de">Info</span>|Best Practices|<a href="../pulumi-queries/aws/d991e4ae-42ab-429b-ab43-d5e5fa9ca633" onclick="newWindowOpenerSafe(event, '../pulumi-queries/aws/d991e4ae-42ab-429b-ab43-d5e5fa9ca633')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/aws/api-docs/ec2/instance/#ebsoptimized_yaml">Documentation</a><br/>|

### AZURE
Below are listed queries related to Pulumi AZURE:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|Storage Account Not Forcing HTTPS<br/><sup><sub>cb8e4bf0-903d-45c6-a278-9a947d82a27b</sub></sup>|<span style="color:#ff7213">Medium</span>|Encryption|<a href="../pulumi-queries/azure/cb8e4bf0-903d-45c6-a278-9a947d82a27b" onclick="newWindowOpenerSafe(event, '../pulumi-queries/azure/cb8e4bf0-903d-45c6-a278-9a947d82a27b')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/azure-native/api-docs/storage/storageaccount/#enablehttpstrafficonly_yaml">Documentation</a><br/>|
|Redis Cache Allows Non SSL Connections<br/><sup><sub>49e30ac8-f58e-4222-b488-3dcb90158ec1</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../pulumi-queries/azure/49e30ac8-f58e-4222-b488-3dcb90158ec1" onclick="newWindowOpenerSafe(event, '../pulumi-queries/azure/49e30ac8-f58e-4222-b488-3dcb90158ec1')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/azure-native/api-docs/cache/redis/#enablenonsslport_yaml">Documentation</a><br/>|

### GCP
Below are listed queries related to Pulumi GCP:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|Google Compute SSL Policy Weak Cipher In Use<br/><sup><sub>965e8830-2bec-4b9b-a7f0-24dbc200a68f</sub></sup>|<span style="color:#ff7213">Medium</span>|Encryption|<a href="../pulumi-queries/gcp/965e8830-2bec-4b9b-a7f0-24dbc200a68f" onclick="newWindowOpenerSafe(event, '../pulumi-queries/gcp/965e8830-2bec-4b9b-a7f0-24dbc200a68f')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/gcp/api-docs/compute/sslpolicy/#mintlsversion_yaml">Documentation</a><br/>|
|Cloud Storage Bucket Logging Not Enabled<br/><sup><sub>48f7e44d-d1d1-44c2-b336-9f11b65c4fb0</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../pulumi-queries/gcp/48f7e44d-d1d1-44c2-b336-9f11b65c4fb0" onclick="newWindowOpenerSafe(event, '../pulumi-queries/gcp/48f7e44d-d1d1-44c2-b336-9f11b65c4fb0')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/gcp/api-docs/storage/bucket/#logging_yaml">Documentation</a><br/>|

### KUBERNETES
Below are listed queries related to Pulumi KUBERNETES:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|PSP Set To Privileged<br/><sup><sub>ee305555-6b1d-4055-94cf-e22131143c34</sub></sup>|<span style="color:#bb2124">High</span>|Insecure Configurations|<a href="../pulumi-queries/ee305555-6b1d-4055-94cf-e22131143c34" onclick="newWindowOpenerSafe(event, '../pulumi-queries/ee305555-6b1d-4055-94cf-e22131143c34')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/kubernetes/api-docs/policy/v1beta1/podsecuritypolicy/#privileged_yaml">Documentation</a><br/>|
|Missing App Armor Config<br/><sup><sub>95588189-1abd-4df1-9588-b0a5034f9e87</sub></sup>|<span style="color:#ff7213">Medium</span>|Access Control|<a href="../pulumi-queries/95588189-1abd-4df1-9588-b0a5034f9e87" onclick="newWindowOpenerSafe(event, '../pulumi-queries/95588189-1abd-4df1-9588-b0a5034f9e87')">Query details</a><br><a href="https://www.pulumi.com/registry/packages/kubernetes/api-docs/core/v1/pod/#objectmeta">Documentation</a><br/>|
