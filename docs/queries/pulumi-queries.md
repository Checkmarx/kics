## Pulumi Queries List
This page contains all queries from Pulumi.

### AZURE
Bellow are listed queries related with Pulumi AZURE:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Storage Account Not Forcing HTTPS<br/><sup><sub>cb8e4bf0-903d-45c6-a278-9a947d82a27b</sub></sup>|<span style="color:#C00">High</span>|Encryption|Storage Accounts should enforce the use of HTTPS (<a href="../pulumi-queries/azure/cb8e4bf0-903d-45c6-a278-9a947d82a27b" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/azure-native/api-docs/storage/storageaccount/#enablehttpstrafficonly_yaml">Documentation</a><br/>|
|Redis Cache Allows Non SSL Connections<br/><sup><sub>49e30ac8-f58e-4222-b488-3dcb90158ec1</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|Redis Cache resource should not allow non-SSL connections. (<a href="../pulumi-queries/azure/49e30ac8-f58e-4222-b488-3dcb90158ec1" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/azure-native/api-docs/cache/redis/#enablenonsslport_yaml">Documentation</a><br/>|

### AWS
Bellow are listed queries related with Pulumi AWS:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Amazon DMS Replication Instance Is Publicly Accessible<br/><sup><sub>bccb296f-362c-4b05-9221-86d1437a1016</sub></sup>|<span style="color:#C00">High</span>|Access Control|Amazon DMS is publicly accessible, therefore exposing possible sensitive information. To prevent such a scenario, update the attribute 'PubliclyAccessible' to false. (<a href="../pulumi-queries/aws/bccb296f-362c-4b05-9221-86d1437a1016" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/dms/replicationinstance/">Documentation</a><br/>|
|RDS DB Instance Publicly Accessible<br/><sup><sub>647de8aa-5a42-41b5-9faf-22136f117380</sub></sup>|<span style="color:#C00">High</span>|Insecure Configurations|RDS must not be defined with public interface, which means the attribute 'PubliclyAccessible' must be set to false. (<a href="../pulumi-queries/aws/647de8aa-5a42-41b5-9faf-22136f117380" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/rds/instance/#publiclyaccessible_yaml">Documentation</a><br/>|
|Elasticsearch with HTTPS disabled<br/><sup><sub>00603add-7f72-448f-a6c0-9e456a7a3f94</sub></sup>|<span style="color:#C00">High</span>|Networking and Firewall|Amazon Elasticsearch does not have encryption for its domains enabled. To prevent such a scenario, update the attribute 'EnforceHTTPS' to true. (<a href="../pulumi-queries/aws/00603add-7f72-448f-a6c0-9e456a7a3f94" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticsearch/domain/#enforcehttps_yaml">Documentation</a><br/>|
|ElastiCache Nodes Not Created Across Multi AZ<br/><sup><sub>9b18fc19-7fb8-49b1-8452-9c757c70f926</sub></sup>|<span style="color:#C60">Medium</span>|Availability|ElastiCache Nodes should be created across multi az, which means 'AZMode' should be set to 'cross-az' in multi nodes cluster (<a href="../pulumi-queries/aws/9b18fc19-7fb8-49b1-8452-9c757c70f926" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticache/cluster/#azmode_yaml">Documentation</a><br/>|
|ElastiCache Redis Cluster Without Backup<br/><sup><sub>e93bbe63-a631-4c0f-b6ef-700d48441ff2</sub></sup>|<span style="color:#C60">Medium</span>|Backup|ElastiCache Redis cluster should have 'snapshotRetentionLimit' higher than 0 (<a href="../pulumi-queries/aws/e93bbe63-a631-4c0f-b6ef-700d48441ff2" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticache/cluster/#snapshotretentionlimit_yaml">Documentation</a><br/>|
|IAM Password Without Lowercase Letter<br/><sup><sub>de92dd34-1b88-43e8-b825-6e02d73c4549</sub></sup>|<span style="color:#C60">Medium</span>|Best Practices|IAM Password should have at least one lowercase letter (<a href="../pulumi-queries/aws/de92dd34-1b88-43e8-b825-6e02d73c4549" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/iam/accountpasswordpolicy/#requirelowercasecharacters_yaml">Documentation</a><br/>|
|IAM Password Without Minimum Length<br/><sup><sub>9850d621-7485-44f7-8bdd-b3cf426315cf</sub></sup>|<span style="color:#C60">Medium</span>|Best Practices|IAM password should have the required minimum length (<a href="../pulumi-queries/aws/9850d621-7485-44f7-8bdd-b3cf426315cf" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/iam/accountpasswordpolicy/#minimumpasswordlength_yaml">Documentation</a><br/>|
|DynamoDB Table Not Encrypted<br/><sup><sub>b6a7e0ae-aed8-4a19-a993-a95760bf8836</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|AWS DynamoDB Tables should have serverSideEncryption enabled (<a href="../pulumi-queries/aws/b6a7e0ae-aed8-4a19-a993-a95760bf8836" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/dynamodb/table/#serversideencryption_yaml">Documentation</a><br/>|
|API Gateway Without SSL Certificate<br/><sup><sub>f27791a5-e2ae-4905-8910-6f995c576d09</sub></sup>|<span style="color:#C60">Medium</span>|Insecure Configurations|SSL Client Certificate should be defined (<a href="../pulumi-queries/aws/f27791a5-e2ae-4905-8910-6f995c576d09" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/apigatewayv2/stage/#clientcertificateid_yaml">Documentation</a><br/>|
|API Gateway Access Logging Disabled<br/><sup><sub>bf4b48b9-fc1f-4552-984a-4becdb5bf503</sub></sup>|<span style="color:#C60">Medium</span>|Observability|API Gateway should have Access Log Settings defined (<a href="../pulumi-queries/aws/bf4b48b9-fc1f-4552-984a-4becdb5bf503" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/apigatewayv2/stage/#accesslogsettings_yaml">Documentation</a><br/>|
|Elasticsearch Logs Disabled<br/><sup><sub>a1120ee4-a712-42d9-8fb5-22595fed643b</sub></sup>|<span style="color:#C60">Medium</span>|Observability|AWS Elasticsearch should have logs enabled (<a href="../pulumi-queries/aws/a1120ee4-a712-42d9-8fb5-22595fed643b" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/elasticsearch/domain/#logpublishingoptions_yaml">Documentation</a><br/>|
|DocDB Logging Is Disabled<br/><sup><sub>2ca87964-fe7e-4cdc-899c-427f0f3525f8</sub></sup>|<span style="color:#CC0">Low</span>|Observability|DocDB logging should be enabled (<a href="../pulumi-queries/aws/2ca87964-fe7e-4cdc-899c-427f0f3525f8" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/docdb/cluster/#enabledcloudwatchlogsexports_yaml">Documentation</a><br/>|
|DynamoDB Table Point In Time Recovery Disabled<br/><sup><sub>327b0729-4c5c-4c44-8b5c-e476cd9c7290</sub></sup>|<span style="color:#00C">Info</span>|Best Practices|It's considered a best practice to have point in time recovery enabled for DynamoDB Table (<a href="../pulumi-queries/aws/327b0729-4c5c-4c44-8b5c-e476cd9c7290" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/dynamodb/table/#pointintimerecovery_yaml">Documentation</a><br/>|
|EC2 Not EBS Optimized<br/><sup><sub>d991e4ae-42ab-429b-ab43-d5e5fa9ca633</sub></sup>|<span style="color:#00C">Info</span>|Best Practices|It's considered a best practice for an EC2 instance to use an EBS optimized instance. This provides the best performance for your EBS volumes by minimizing contention between Amazon EBS I/O and other traffic from your instance (<a href="../pulumi-queries/aws/d991e4ae-42ab-429b-ab43-d5e5fa9ca633" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/ec2/instance/#ebsoptimized_yaml">Documentation</a><br/>|
|EC2 Instance Monitoring Disabled<br/><sup><sub>daa581ef-731c-4121-832d-cf078f67759d</sub></sup>|<span style="color:#00C">Info</span>|Observability|EC2 Instance should have detailed monitoring enabled. With detailed monitoring enabled data is available in 1-minute periods (<a href="../pulumi-queries/aws/daa581ef-731c-4121-832d-cf078f67759d" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/aws/api-docs/ec2/instance/#monitoring_yaml">Documentation</a><br/>|

### KUBERNETES
Bellow are listed queries related with Pulumi KUBERNETES:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|PSP Set To Privileged<br/><sup><sub>ee305555-6b1d-4055-94cf-e22131143c34</sub></sup>|<span style="color:#C60">Medium</span>|Insecure Configurations|Do not allow pod to request execution as privileged. (<a href="../pulumi-queries/ee305555-6b1d-4055-94cf-e22131143c34" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/kubernetes/api-docs/policy/v1beta1/podsecuritypolicy/#privileged_yaml">Documentation</a><br/>|
|Missing App Armor Config<br/><sup><sub>95588189-1abd-4df1-9588-b0a5034f9e87</sub></sup>|<span style="color:#CC0">Low</span>|Access Control|Containers should be configured with AppArmor for any application to reduce its potential attack (<a href="../pulumi-queries/95588189-1abd-4df1-9588-b0a5034f9e87" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/kubernetes/api-docs/core/v1/pod/#objectmeta">Documentation</a><br/>|

### GCP
Bellow are listed queries related with Pulumi GCP:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Cloud Storage Bucket Logging Not Enabled<br/><sup><sub>48f7e44d-d1d1-44c2-b336-9f11b65c4fb0</sub></sup>|<span style="color:#C00">High</span>|Observability|Cloud storage bucket should have logging enabled (<a href="../pulumi-queries/gcp/48f7e44d-d1d1-44c2-b336-9f11b65c4fb0" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/gcp/api-docs/storage/bucket/#logging_yaml">Documentation</a><br/>|
|Google Compute SSL Policy Weak Cipher In Use<br/><sup><sub>965e8830-2bec-4b9b-a7f0-24dbc200a68f</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|This query confirms if Google Compute SSL Policy Weak Chyper Suits is Enabled, to do so we need to check if TLS is TLS_1_2, because other version have Weak Chypers (<a href="../pulumi-queries/gcp/965e8830-2bec-4b9b-a7f0-24dbc200a68f" target="_blank">read more</a>)|<a href="https://www.pulumi.com/registry/packages/gcp/api-docs/compute/sslpolicy/#mintlsversion_yaml">Documentation</a><br/>|
