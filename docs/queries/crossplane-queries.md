## Crossplane Queries List
This page contains all queries from Crossplane.

### AWS
Bellow are listed queries related with Crossplane AWS:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|EFS Not Encrypted<br/><sup><sub>72840c35-3876-48be-900d-f21b2f0c2ea1</sub></sup>|<span style="color:#C00">High</span>|Encryption|Elastic File System (EFS) must be encrypted|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/efs.aws.crossplane.io/FileSystem/v1alpha1@v0.29.0#spec-forProvider-encrypted">Documentation</a><br/>|
|EFS Without KMS<br/><sup><sub>bdecd6db-2600-47dd-a10c-72c97cf17ae9</sub></sup>|<span style="color:#C00">High</span>|Encryption|Amazon Elastic Filesystem should have filesystem encryption enabled using KMS CMK customer-managed keys instead of AWS managed-keys|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/efs.aws.crossplane.io/FileSystem/v1alpha1@v0.29.0#spec-forProvider-kmsKeyID">Documentation</a><br/>|
|DB Instance Storage Not Encrypted<br/><sup><sub>e50eb68a-a4af-4048-8bbe-8ec324421469</sub></sup>|<span style="color:#C00">High</span>|Encryption|RDS Instance should have its storage encrypted by setting the parameter to 'true'. The storageEncrypted default value is 'false'.|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/database.aws.crossplane.io/RDSInstance/v1beta1@v0.29.0#spec-forProvider-storageEncrypted">Documentation</a><br/>|
|ELB Using Weak Ciphers<br/><sup><sub>a507daa5-0795-4380-960b-dd7bb7c56661</sub></sup>|<span style="color:#C00">High</span>|Encryption|ELB Predefined or Custom Security Policies must not use weak ciphers, to reduce the risk of the SSL connection between the client and the load balancer being exploited. That means the 'sslPolicy' of 'Listener' must not coincide with any of a predefined list of weak ciphers.|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/elbv2.aws.crossplane.io/Listener/v1alpha1@v0.29.0#spec-forProvider-sslPolicy">Documentation</a><br/>|
|CloudFront Without Minimum Protocol TLS 1.2<br/><sup><sub>255b0fcc-9f82-41fe-9229-01b163e3376b</sub></sup>|<span style="color:#C00">High</span>|Insecure Configurations|CloudFront Minimum Protocol version should be at least TLS 1.2|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudfront.aws.crossplane.io/Distribution/v1alpha1@v0.29.0#spec-forProvider-distributionConfig-viewerCertificate-minimumProtocolVersion">Documentation</a><br/>|
|DB Security Group Has Public Interface<br/><sup><sub>dd667399-8d9d-4a8d-bbb4-e49ab53b2f52</sub></sup>|<span style="color:#C00">High</span>|Insecure Configurations|The CIDR IP should not be a public interface|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/ec2.aws.crossplane.io/SecurityGroup/v1beta1@v0.29.0#spec-forProvider-ingress-ipRanges-cidrIp">Documentation</a><br/>|
|SQS With SSE Disabled<br/><sup><sub>9296f1cc-7a40-45de-bd41-f31745488a0e</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|Amazon Simple Queue Service (SQS) queue should protect the contents of their messages using Server-Side Encryption (SSE)|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/sqs.aws.crossplane.io/Queue/v1beta1@v0.29.0#spec-forProvider-kmsMasterKeyId">Documentation</a><br/>|
|Neptune Database Cluster Encryption Disabled<br/><sup><sub>83bf5aca-138a-498e-b9cd-ad5bc5e117b4</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|Neptune database cluster storage should have encryption enabled|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/neptune.aws.crossplane.io/DBCluster/v1alpha1@v0.29.0#spec-forProvider-storageEncrypted">Documentation</a><br/>|
|CloudFront Logging Disabled<br/><sup><sub>7b590235-1ff4-421b-b9ff-5227134be9bb</sub></sup>|<span style="color:#C60">Medium</span>|Observability|AWS CloudFront distributions should have logging enabled to collect all viewer requests, which means the attribute 'logging' must be defined with 'enabled' set to true|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudfront.aws.crossplane.io/Distribution/v1alpha1@v0.29.0#spec-forProvider-distributionConfig-logging">Documentation</a><br/>|
|CloudWatch Without Retention Period Specified<br/><sup><sub>934613fe-b12c-4e5a-95f5-c1dcdffac1ff</sub></sup>|<span style="color:#C60">Medium</span>|Observability|AWS CloudWatch should have CloudWatch Logs enabled in order to monitor, store, and access log events|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudwatchlogs.aws.crossplane.io/LogGroup/v1alpha1@v0.29.0#spec-forProvider-retentionInDays">Documentation</a><br/>|
|CloudFront Without WAF<br/><sup><sub>6d19ce0f-b3d8-4128-ac3d-1064e0f00494</sub></sup>|<span style="color:#CC0">Low</span>|Networking and Firewall|All AWS CloudFront distributions should be integrated with the Web Application Firewall (AWS WAF) service|<a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudfront.aws.crossplane.io/Distribution/v1alpha1@v0.29.0#spec-forProvider-distributionConfig-webACLID">Documentation</a><br/>|

### AZURE
Bellow are listed queries related with Crossplane AZURE:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|AKS RBAC Disabled<br/><sup><sub>b2418936-cd47-4ea2-8346-623c0bdb87bd</sub></sup>|<span style="color:#C60">Medium</span>|Access Control|Azure Container Service (AKS) instance should have role-based access control (RBAC) enabled|<a href="https://doc.crds.dev/github.com/crossplane/provider-azure/compute.azure.crossplane.io/AKSCluster/v1alpha3@v0.19.0#spec-disableRBAC">Documentation</a><br/>|
|Redis Cache Allows Non SSL Connections<br/><sup><sub>6c7cfec3-c686-4ed2-bf58-a1ec054b63fc</sub></sup>|<span style="color:#C60">Medium</span>|Encryption|Redis Cache resource should not allow non-SSL connections.|<a href="https://doc.crds.dev/github.com/crossplane/provider-azure/cache.azure.crossplane.io/Redis/v1beta1@v0.19.0#spec-forProvider-enableNonSslPort">Documentation</a><br/>|

### GCP
Bellow are listed queries related with Crossplane GCP:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Cloud Storage Bucket Logging Not Enabled<br/><sup><sub>6c2d627c-de0f-45fb-b33d-dad9bffbb421</sub></sup>|<span style="color:#C00">High</span>|Observability|Cloud storage bucket should have logging enabled|<a href="https://doc.crds.dev/github.com/crossplane/provider-gcp/storage.gcp.crossplane.io/Bucket/v1alpha3@v0.21.0#spec-logging">Documentation</a><br/>|
|Google Container Node Pool Auto Repair Disabled<br/><sup><sub>b4f65d13-a609-4dc1-af7c-63d2e08bffe9</sub></sup>|<span style="color:#C60">Medium</span>|Insecure Configurations|Google Container Node Pool Auto Repair should be enabled. This service periodically checks for failing nodes and repairs them to ensure a smooth running state.|<a href="https://doc.crds.dev/github.com/crossplane/provider-gcp/container.gcp.crossplane.io/NodePool/v1beta1@v0.21.0#spec-forProvider-management-autoRepair">Documentation</a><br/>|
