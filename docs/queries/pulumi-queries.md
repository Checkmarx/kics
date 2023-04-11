## Pulumi Queries List
This page contains all queries from Pulumi.

### KUBERNETES
Bellow are listed queries related with Pulumi KUBERNETES:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|PSP Set To Privileged<br/><sup><sub>ee305555-6b1d-4055-94cf-e22131143c34</sub></sup>|<span style="color:#C60">Medium</span>|Insecure Configurations|Do not allow pod to request execution as privileged.|<a href="https://www.pulumi.com/registry/packages/kubernetes/api-docs/policy/v1beta1/podsecuritypolicy/#privileged_yaml">Documentation</a><br/>|
|Missing App Armor Config<br/><sup><sub>95588189-1abd-4df1-9588-b0a5034f9e87</sub></sup>|<span style="color:#CC0">Low</span>|Access Control|Containers should be configured with AppArmor for any application to reduce its potential attack|<a href="https://www.pulumi.com/registry/packages/kubernetes/api-docs/core/v1/pod/#objectmeta">Documentation</a><br/>|

### AWS
Bellow are listed queries related with Pulumi AWS:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|ElastiCache Nodes Not Created Across Multi AZ<br/><sup><sub>9b18fc19-7fb8-49b1-8452-9c757c70f926</sub></sup>|<span style="color:#C60">Medium</span>|Availability|ElastiCache Nodes should be created across multi az, which means 'AZMode' should be set to 'cross-az' in multi nodes cluster|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticache/cluster/#azmode_yaml">Documentation</a><br/>|
|ElastiCache Redis Cluster Without Backup<br/><sup><sub>e93bbe63-a631-4c0f-b6ef-700d48441ff2</sub></sup>|<span style="color:#C60">Medium</span>|Backup|ElastiCache Redis cluster should have 'snapshotRetentionLimit' higher than 0|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticache/cluster/#snapshotretentionlimit_yaml">Documentation</a><br/>|
|IAM Password Without Lowercase Letter<br/><sup><sub>de92dd34-1b88-43e8-b825-6e02d73c4549</sub></sup>|<span style="color:#C60">Medium</span>|Best Practices|IAM Password should have at least one lowercase letter|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/iam/accountpasswordpolicy/#requirelowercasecharacters_yaml">Documentation</a><br/>|
|IAM Password Without Minimum Length<br/><sup><sub>9850d621-7485-44f7-8bdd-b3cf426315cf</sub></sup>|<span style="color:#C60">Medium</span>|Best Practices|IAM password should have the required minimum length|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/iam/accountpasswordpolicy/#minimumpasswordlength_yaml">Documentation</a><br/>|
|DynamoDB Table Not Encrypted<br/><sup><sub>b6a7e0ae-aed8-4a19-a993-a95760bf8836</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|AWS DynamoDB Tables should have serverSideEncryption enabled|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/dynamodb/table/#serversideencryption_yaml">Documentation</a><br/>|
|API Gateway Without SSL Certificate<br/><sup><sub>f27791a5-e2ae-4905-8910-6f995c576d09</sub></sup>|<span style="color:#C60">Medium</span>|Insecure Configurations|SSL Client Certificate should be defined|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/apigatewayv2/stage/#clientcertificateid_yaml">Documentation</a><br/>|
|API Gateway Access Logging Disabled<br/><sup><sub>bf4b48b9-fc1f-4552-984a-4becdb5bf503</sub></sup>|<span style="color:#C60">Medium</span>|Observability|API Gateway should have Access Log Settings defined|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/apigatewayv2/stage/#accesslogsettings_yaml">Documentation</a><br/>|
|DynamoDB Table Point In Time Recovery Disabled<br/><sup><sub>327b0729-4c5c-4c44-8b5c-e476cd9c7290</sub></sup>|<span style="color:#00C">Info</span>|Best Practices|It's considered a best practice to have point in time recovery enabled for DynamoDB Table|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/dynamodb/table/#pointintimerecovery_yaml">Documentation</a><br/>|
|EC2 Not EBS Optimized<br/><sup><sub>d991e4ae-42ab-429b-ab43-d5e5fa9ca633</sub></sup>|<span style="color:#00C">Info</span>|Best Practices|It's considered a best practice for an EC2 instance to use an EBS optimized instance. This provides the best performance for your EBS volumes by minimizing contention between Amazon EBS I/O and other traffic from your instance|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/ec2/instance/#ebsoptimized_yaml">Documentation</a><br/>|
|EC2 Instance Monitoring Disabled<br/><sup><sub>daa581ef-731c-4121-832d-cf078f67759d</sub></sup>|<span style="color:#00C">Info</span>|Observability|EC2 Instance should have detailed monitoring enabled. With detailed monitoring enabled data is available in 1-minute periods|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/ec2/instance/#monitoring_yaml">Documentation</a><br/>|

### AZURE
Bellow are listed queries related with Pulumi AZURE:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Storage Account Not Forcing HTTPS<br/><sup><sub>cb8e4bf0-903d-45c6-a278-9a947d82a27b</sub></sup>|<span style="color:#C00">High</span>|Encryption|Storage Accounts should enforce the use of HTTPS|<a href="https://www.pulumi.com/registry/packages/azure-native/api-docs/storage/storageaccount/#enablehttpstrafficonly_yaml">Documentation</a><br/>|
|Redis Cache Allows Non SSL Connections<br/><sup><sub>49e30ac8-f58e-4222-b488-3dcb90158ec1</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|Redis Cache resource should not allow non-SSL connections.|<a href="https://www.pulumi.com/registry/packages/azure-native/api-docs/cache/redis/#enablenonsslport_yaml">Documentation</a><br/>|

### GCP
Bellow are listed queries related with Pulumi GCP:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Cloud Storage Bucket Logging Not Enabled<br/><sup><sub>48f7e44d-d1d1-44c2-b336-9f11b65c4fb0</sub></sup>|<span style="color:#C00">High</span>|Observability|Cloud storage bucket should have logging enabled|<a href="https://www.pulumi.com/registry/packages/gcp/api-docs/storage/bucket/#logging_yaml">Documentation</a><br/>|
|Google Compute SSL Policy Weak Cipher In Use<br/><sup><sub>965e8830-2bec-4b9b-a7f0-24dbc200a68f</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|This query confirms if Google Compute SSL Policy Weak Chyper Suits is Enabled, to do so we need to check if TLS is TLS_1_2, because other version have Weak Chypers|<a href="https://www.pulumi.com/registry/packages/gcp/api-docs/compute/sslpolicy/#mintlsversion_yaml">Documentation</a><br/>|
