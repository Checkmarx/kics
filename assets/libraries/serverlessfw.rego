package generic.serverlessfw

import data.generic.common as common_lib

get_provider_name(doc)=name{
	provider := doc.provider
	name := provider.name
} else = name {
	name = "AWS"
}


resourceTypeMapping(resourceType, provider)= resourceTypeVal{
    resourceTypeVal :=resourcesMap[provider][resourceType]
}

resourcesMap = {
    "aws": {
        "function": "AWS::Lambda",
        "api": "AWS::ApiGateway",
        "iam": "AWS::IAM"        
    },
    "azure":{
        "function": "Azure:Function",
        "api": "Azure:APIManagement",
        "iam": "Azure:Role"
    },
    "google":{
        "function": "Google:Cloudfunctions",
        "api": "Google:ApiGateway",
        "iam": "Google:IAM"
    },
    "aliyun":{
        "function": "Aliyun:FunctionCompute",
        "api": "Aliyun:ApiGateway",
        "iam": "Aliyun:RAM"
    }
}

get_service_name(document) = name{
    name := document.service.name
} else = name {
    is_string(document.service)
    name := document.service
}


get_resource_accessibility(nameRef, type, key) = info {
	document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	policyDoc := policy.Properties.PolicyDocument
	common_lib.any_principal(policyDoc)
	common_lib.is_allow_effect(policyDoc)

	info := {"accessibility": "public", "policy": policyDoc}
} else = info {
    document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	policyDoc := policy.Properties.PolicyDocument
	common_lib.any_principal(policyDoc)
	common_lib.is_allow_effect(policyDoc)

	info := {"accessibility": "public", "policy": policyDoc}
} else = info {
    document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
    document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
}

get_name(targetName) = name {
	common_lib.valid_key(targetName, "Ref")
	name := targetName.Ref
} else = name {
	not common_lib.valid_key(targetName, "Ref")
	name := targetName
}

resourceFieldName = {
	"AWS::Config::ConfigRule": "ConfigRuleName",  
	"AWS::ElasticLoadBalancing::LoadBalancer": "LoadBalancerName",
	"AWS::ElasticLoadBalancingV2::LoadBalancer": "Name",
	"Alexa::ASK::Skill": "",
	"AWS::AmazonMQ::Broker": "BrokerName",
	"AWS::Amplify::App": "Name",
	"AWS::ApiGateway::Stage": "StageName",
	"AWS::ApiGatewayV2::Stage": "StageName",
	"AWS::ApiGateway::Deployment": "StageName",
	"AWS::ApiGateway::RestApi": "Name",
	"AWS::ApiGateway::Method": "OperationName",
	"AWS::ApiGateway::Authorizer": "Name", 
	"AWS::ApiGatewayV2::Authorizer": "Name",
	"AWS::ApiGatewayV2::Api": "Name",
	"AWS::ApiGateway::DomainName": "DomainName",
	"AWS::AutoScaling::AutoScalingGroup": "AutoScalingGroupName",
	"AWS::RDS::DBInstance": "DBName",
	"AWS::Batch::JobDefinition": "JobDefinitionName",
	"AWS::CloudFront::Distribution": "",
	"AWS::EC2::Instance": "",
	"AWS::CloudTrail::Trail": "TrailName",
	"AWS::Route53::HostedZone": "Name",
	"AWS::KMS::Key": "",
	"AWS::DocDB::DBCluster": "",
	"AWS::Neptune::DBCluster": "",
	"AWS::RDS::DBCluster": "DatabaseName",
	"AWS::RDS::GlobalCluster": "",
	"AWS::Redshift::Cluster": "DBName",
	"AWS::CodeBuild::Project": "Name",
	"AWS::Cognito::UserPool": "UserPoolName",
	"AWS::Config::ConfigurationAggregator": "ConfigurationAggregatorName",
	"AWS::IAM::Role": "RoleName",
	"AWS::EC2::SecurityGroup": "GroupName",
	"AWS::RDS::DBSecurityGroup": "",
	"AWS::DirectoryService::MicrosoftAD": "Name",
	"AWS::DirectoryService::SimpleAD": "Name",
	"AWS::DMS::Endpoint": "",
	"AWS::DynamoDB::Table": "TableName",
	"AWS::EC2::Volume": "",
	"AWS::EC2::NetworkAclEntry": "",
	"AWS::EC2::Subnet": "",
	"AWS::ECR::Repository": "RepositoryName",
	"AWS::ECS::Service": "ServiceName",
	"AWS::ECS::TaskDefinition": "",
	"AWS::EFS::FileSystem": "",
	"AWS::EKS::Nodegroup": "NodegroupName",
	"AWS::Elasticsearch::Domain": "DomainName",
	"AWS::ElastiCache::CacheCluster": "ClusterName",
	"AWS::ElastiCache::ReplicationGroup": "",
	"AWS::EMR::Cluster": "Name",
	"AWS::EMR::SecurityConfiguration": "Name",
	"AWS::EC2::SecurityGroupIngress": "GroupName",
	"AWS::ECS::Cluster": "ClusterName",
	"AWS::GameLift::Fleet": "Name",
	"AWS::CodeStar::GitHubRepository": "RepositoryName",
	"AWS::GuardDuty::Detector": "",
	"AWS::Lambda::Function": "FunctionName",
	"AWS::IAM::Group": "GroupName",
	"AWS::IAM::ManagedPolicy": "ManagedPolicyName",
	"AWS::IAM::User": "UserName",
	"AWS::IAM::Policy": "PolicyName",
	"AWS::IAM::AccessKey": "",
	"AWS::IoT::Policy": "PolicyName",
	"AWS::Kinesis::Stream": "Name",
	"AWS::Lambda::Permission": "",
	"AWS::MSK::Cluster": "ClusterName",
	"AWS::EC2::Route": "",
	"AWS::S3::Bucket": "BucketName",
	"AWS::S3::BucketPolicy": "",
	"AWS::SageMaker::NotebookInstance": "NotebookInstanceName",
	"AWS::SageMaker::EndpointConfig": "EndpointConfigName",
	"AWS::SDB::Domain": "",
	"AWS::SecretsManager::Secret": "Name",
	"AWS::EC2::SecurityGroupEgress": "",
	"AWS::GlobalAccelerator::Accelerator": "Name",
	"AWS::EC2::EIP": "",
	"AWS::SNS::TopicPolicy": "",
	"AWS::SNS::Topic": "TopicName",
	"AWS::SQS::QueuePolicy": "",
	"AWS::SQS::Queue": "QueueName",
	"AWS::CloudFormation::Stack": "",
	"AWS::CloudFormation::StackSet": "StackSetName",
	"AWS::AutoScaling::LaunchConfiguration": "LaunchConfigurationName",
	"AWS::EC2::VPC": "",
	"AWS::EC2::VPCGatewayAttachment": "",
	"AWS::EC2::FlowLog": "",
	"AWS::NetworkFirewall::Firewall": "FirewallName",
	"AWS::WAF::WebACL": "Name",
	"AWS::CertificateManager::Certificate": "",
	"AWS::Serverless::HttpApi": "",
	"AWS::Serverless::Api": "",
	"AWS::Serverless::Function": "FunctionName",
}

get_encryption(resource) = encryption {
	resource.encrypted == true
    encryption := "encrypted"
} else = encryption {
    fields := {"kmsMasterKeyId", "encryptionInfo", "encryptionOptions", "bucketEncryption"}
    common_lib.valid_key(resource, fields[_])
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
