## Crossplane Queries List
This page contains all queries from Crossplane.

### AWS
Below are listed queries related to Crossplane AWS:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|DB Instance Storage Not Encrypted<br/><sup><sub>e50eb68a-a4af-4048-8bbe-8ec324421469</sub></sup>|<span style="color:#bb2124">High</span>|Encryption|<a href="../crossplane-queries/aws/e50eb68a-a4af-4048-8bbe-8ec324421469" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/database.aws.crossplane.io/RDSInstance/v1beta1@v0.29.0#spec-forProvider-storageEncrypted">Documentation</a><br/>|
|EFS Not Encrypted<br/><sup><sub>72840c35-3876-48be-900d-f21b2f0c2ea1</sub></sup>|<span style="color:#bb2124">High</span>|Encryption|<a href="../crossplane-queries/aws/72840c35-3876-48be-900d-f21b2f0c2ea1" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/efs.aws.crossplane.io/FileSystem/v1alpha1@v0.29.0#spec-forProvider-encrypted">Documentation</a><br/>|
|ELB Using Weak Ciphers<br/><sup><sub>a507daa5-0795-4380-960b-dd7bb7c56661</sub></sup>|<span style="color:#bb2124">High</span>|Encryption|<a href="../crossplane-queries/aws/a507daa5-0795-4380-960b-dd7bb7c56661" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/elbv2.aws.crossplane.io/Listener/v1alpha1@v0.29.0#spec-forProvider-sslPolicy">Documentation</a><br/>|
|Neptune Database Cluster Encryption Disabled<br/><sup><sub>83bf5aca-138a-498e-b9cd-ad5bc5e117b4</sub></sup>|<span style="color:#bb2124">High</span>|Encryption|<a href="../crossplane-queries/aws/83bf5aca-138a-498e-b9cd-ad5bc5e117b4" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/neptune.aws.crossplane.io/DBCluster/v1alpha1@v0.29.0#spec-forProvider-storageEncrypted">Documentation</a><br/>|
|DB Security Group Has Public Interface<br/><sup><sub>dd667399-8d9d-4a8d-bbb4-e49ab53b2f52</sub></sup>|<span style="color:#bb2124">High</span>|Insecure Configurations|<a href="../crossplane-queries/aws/dd667399-8d9d-4a8d-bbb4-e49ab53b2f52" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/ec2.aws.crossplane.io/SecurityGroup/v1beta1@v0.29.0#spec-forProvider-ingress-ipRanges-cidrIp">Documentation</a><br/>|
|SQS With SSE Disabled<br/><sup><sub>9296f1cc-7a40-45de-bd41-f31745488a0e</sub></sup>|<span style="color:#ff7213">Medium</span>|Encryption|<a href="../crossplane-queries/aws/9296f1cc-7a40-45de-bd41-f31745488a0e" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/sqs.aws.crossplane.io/Queue/v1beta1@v0.29.0#spec-forProvider-kmsMasterKeyId">Documentation</a><br/>|
|CloudFront Without Minimum Protocol TLS 1.2<br/><sup><sub>255b0fcc-9f82-41fe-9229-01b163e3376b</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../crossplane-queries/aws/255b0fcc-9f82-41fe-9229-01b163e3376b" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudfront.aws.crossplane.io/Distribution/v1alpha1@v0.29.0#spec-forProvider-distributionConfig-viewerCertificate-minimumProtocolVersion">Documentation</a><br/>|
|RDS DB Instance Publicly Accessible<br/><sup><sub>d9dc6429-5140-498a-8f55-a10daac5f000</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../crossplane-queries/aws/d9dc6429-5140-498a-8f55-a10daac5f000" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/database.aws.crossplane.io/RDSInstance/v1beta1@v0.17.0">Documentation</a><br/>|
|CloudFront Without WAF<br/><sup><sub>6d19ce0f-b3d8-4128-ac3d-1064e0f00494</sub></sup>|<span style="color:#ff7213">Medium</span>|Networking and Firewall|<a href="../crossplane-queries/aws/6d19ce0f-b3d8-4128-ac3d-1064e0f00494" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudfront.aws.crossplane.io/Distribution/v1alpha1@v0.29.0#spec-forProvider-distributionConfig-webACLID">Documentation</a><br/>|
|CloudFront Logging Disabled<br/><sup><sub>7b590235-1ff4-421b-b9ff-5227134be9bb</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../crossplane-queries/aws/7b590235-1ff4-421b-b9ff-5227134be9bb" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudfront.aws.crossplane.io/Distribution/v1alpha1@v0.29.0#spec-forProvider-distributionConfig-logging">Documentation</a><br/>|
|DocDB Logging Is Disabled<br/><sup><sub>e6cd49ba-77ed-417f-9bca-4f5303554308</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../crossplane-queries/aws/e6cd49ba-77ed-417f-9bca-4f5303554308" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/docdb.aws.crossplane.io/DBCluster/v1alpha1@v0.21.1#status-atProvider-enabledCloudwatchLogsExports">Documentation</a><br/>|
|EFS Without KMS<br/><sup><sub>bdecd6db-2600-47dd-a10c-72c97cf17ae9</sub></sup>|<span style="color:#edd57e">Low</span>|Encryption|<a href="../crossplane-queries/aws/bdecd6db-2600-47dd-a10c-72c97cf17ae9" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/efs.aws.crossplane.io/FileSystem/v1alpha1@v0.29.0#spec-forProvider-kmsKeyID">Documentation</a><br/>|
|ECS Cluster with Container Insights Disabled<br/><sup><sub>0c7a76d9-7dc5-499e-81ac-9245839177cb</sub></sup>|<span style="color:#edd57e">Low</span>|Observability|<a href="../crossplane-queries/aws/0c7a76d9-7dc5-499e-81ac-9245839177cb" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/ecs.aws.crossplane.io/Cluster/v1alpha1@v0.42.0#spec-forProvider-settings">Documentation</a><br/>|
|CloudWatch Without Retention Period Specified<br/><sup><sub>934613fe-b12c-4e5a-95f5-c1dcdffac1ff</sub></sup>|<span style="color:#5bc0de">Info</span>|Observability|<a href="../crossplane-queries/aws/934613fe-b12c-4e5a-95f5-c1dcdffac1ff" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-aws/cloudwatchlogs.aws.crossplane.io/LogGroup/v1alpha1@v0.29.0#spec-forProvider-retentionInDays">Documentation</a><br/>|

### AZURE
Below are listed queries related to Crossplane AZURE:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|AKS RBAC Disabled<br/><sup><sub>b2418936-cd47-4ea2-8346-623c0bdb87bd</sub></sup>|<span style="color:#ff7213">Medium</span>|Access Control|<a href="../crossplane-queries/azure/b2418936-cd47-4ea2-8346-623c0bdb87bd" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-azure/compute.azure.crossplane.io/AKSCluster/v1alpha3@v0.19.0#spec-disableRBAC">Documentation</a><br/>|
|Redis Cache Allows Non SSL Connections<br/><sup><sub>6c7cfec3-c686-4ed2-bf58-a1ec054b63fc</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../crossplane-queries/azure/6c7cfec3-c686-4ed2-bf58-a1ec054b63fc" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-azure/cache.azure.crossplane.io/Redis/v1beta1@v0.19.0#spec-forProvider-enableNonSslPort">Documentation</a><br/>|

### GCP
Below are listed queries related to Crossplane GCP:



|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
|Google Container Node Pool Auto Repair Disabled<br/><sup><sub>b4f65d13-a609-4dc1-af7c-63d2e08bffe9</sub></sup>|<span style="color:#ff7213">Medium</span>|Insecure Configurations|<a href="../crossplane-queries/gcp/b4f65d13-a609-4dc1-af7c-63d2e08bffe9" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-gcp/container.gcp.crossplane.io/NodePool/v1beta1@v0.21.0#spec-forProvider-management-autoRepair">Documentation</a><br/>|
|Cloud Storage Bucket Logging Not Enabled<br/><sup><sub>6c2d627c-de0f-45fb-b33d-dad9bffbb421</sub></sup>|<span style="color:#ff7213">Medium</span>|Observability|<a href="../crossplane-queries/gcp/6c2d627c-de0f-45fb-b33d-dad9bffbb421" target="_blank">Query details</a><br><a href="https://doc.crds.dev/github.com/crossplane/provider-gcp/storage.gcp.crossplane.io/Bucket/v1alpha3@v0.21.0#spec-logging">Documentation</a><br/>|
