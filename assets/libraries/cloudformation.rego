package generic.cloudformation

import data.generic.common as common_lib

isCloudFormationFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}

isCloudFormationTrue(answer) {
	lower(answer) == "true"
} else {
	answer == true
}

# Find out if the document has a resource type equals to 'AWS::SecretsManager::Secret'
hasSecretManager(str, document) {
	selectedSecret := strings.replace_n({"${": "", "}": ""}, regex.find_n(`\${\w+}`, str, 1)[0])
	document[selectedSecret].Type == "AWS::SecretsManager::Secret"
}

# Check if the type is ELB
isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
}

# Check if the type is ELB
isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
}

# Check if there is an action inside an array
checkAction(currentAction, actionToCompare) {
	is_string(currentAction)
	currentAction == "*"
	currentAction == actionToCompare
} else {
	is_string(currentAction)
	contains(lower(currentAction), actionToCompare)
} else {
	is_array(currentAction)
	action := currentAction[_]
	action == "*"
	action == actionToCompare
} else {
	is_array(currentAction)
	action := currentAction[_]
	contains(lower(action), actionToCompare)
}

# Dictionary of UDP ports
udpPortsMap = {
	53: "DNS",
	137: "NetBIOS Name Service",
	138: "NetBIOS Datagram Service",
	139: "NetBIOS Session Service",
	161: "SNMP",
	389: "LDAP",
	1434: "MSSQL Browser",
	2483: "Oracle DB SSL",
	2484: "Oracle DB SSL",
	5432: "PostgreSQL",
	11211: "Memcached",
	11214: "Memcached SSL",
	11215: "Memcached SSL"
}

get_ingress_list(resource) = result {
	ingress_array_types := ["AWS::EC2::SecurityGroup","AWS::RDS::DBSecurityGroup"]
	resource.Type == ingress_array_types[_]
	result := resource.Properties[get_associated_ingress_type(resource.Type)]
} else = result {
	# assumes it is a "AWS::EC2::SecurityGroupIngress" or "AWS::EC2::SecurityGroupEgress" resource
	result := [resource.Properties]
}

get_associated_ingress_type("AWS::EC2::SecurityGroup") = "SecurityGroupIngress"
get_associated_ingress_type("AWS::RDS::DBSecurityGroup") = "DBSecurityGroupIngress" #legacy

containsPort(from_port, to_port, port) {
	from_port <= port
	to_port >= port
}

entireNetwork(rule) {
	rule.CidrIp == "0.0.0.0/0"
} else {
	rule.CidrIpv6 == common_lib.unrestricted_ipv6[_]
}

getProtocolList(protocol) = list {
	protocol == "-1"
	list = ["TCP", "UDP"]
} else = list {
	upper(protocol) == ["TCP", "6"][_]
	list = ["TCP"]
} else = list {
	upper(protocol) == ["UDP", "17"][_]
	list = ["UDP"]
}

isTCP_and_port_exposed(ingress, port) {
	upper(ingress.IpProtocol) == ["TCP","6"][_]
	containsPort(ingress.FromPort, ingress.ToPort, port)
} else {
	ingress.IpProtocol == "-1"
}

# Get content of the resource(s) based on the type
getResourcesByType(resources, type) = list {
	list = [resource | resources[i].Type == type; resource := resources[i]]
}

getBucketName(resource) = name {
	name := resource.Properties.Bucket
	not common_lib.valid_key(name, "Ref")
} else = name {
	name := resource.Properties.Bucket.Ref
}

get_encryption(resource) = encryption {
	resource.Properties.Encrypted == true
	encryption := "encrypted"
} else = encryption {
	fields := {"EncryptionSpecification", "KmsMasterKeyId", "EncryptionInfo", "EncryptionOptions", "BucketEncryption", "StreamEncryption"}
	common_lib.valid_key(resource.Properties, fields[_])
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}

get_name(targetName) = name {
	common_lib.valid_key(targetName, "Ref")
	name := targetName.Ref
} else = name {
	not common_lib.valid_key(targetName, "Ref")
	name := targetName
}

get_resource_accessibility(nameRef, type, key) = info {
	document := input.document
	policy := document[_].Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	statement := common_lib.get_statement(policy.Properties.PolicyDocument)
	common_lib.any_principal(statement)
	common_lib.is_allow_effect(statement)

	info := {"accessibility": "public", "policy": policy.Properties.PolicyDocument}
} else = info {
	document := input.document
	policy := document[_].Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	statement := common_lib.get_statement(policy.Properties.PolicyDocument)
	common_lib.any_principal(statement)
	common_lib.is_allow_effect(statement)

	info := {"accessibility": "public", "policy": policy.Properties.PolicyDocument}
} else = info {
	document := input.document
	policy := document[_].Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
	document := input.document
	policy := document[_].Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
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

get_resource_name(resource, resourceDefinitionName) = name {
	field := resourceFieldName[resource.Type]
	name := resource.Properties[field]
} else = name {
	name := common_lib.get_tag_name_if_exists(resource)
} else = name {
	name := resourceDefinitionName
}

getPath(path) = result {
	count(path) > 0
	path_string := common_lib.concat_path(path)
	out := array.concat([path_string], ["."])
	result := concat("", out)
} else = result {
	count(path) == 0
	result := ""
}

createSearchKey(elem) = search {
	not elem.Name.Ref
	search := sprintf("=%s", [elem.Name])
} else = search {
	elem.Name.Ref
	search := sprintf(".Ref=%s", [elem.Name.Ref])
}

# Checks logs within "LogPublishingOptions"
enabled_is_undefined_or_false(logs,path,name,logName) = results {
	not common_lib.valid_key(logs,"Enabled")
	results := {
		"print" : "is undefined",
		"searchKey" : sprintf("%s%s.Properties.LogPublishingOptions.%s", [getPath(path),name, logName]),
		"searchLine" : common_lib.build_search_line(path, [name, "Properties", "LogPublishingOptions", logName]),
	}
} else = results {
	isCloudFormationFalse(logs.Enabled)
	results := {
		"print" : "is set to 'false'",
		"searchKey" : sprintf("%s%s.Properties.LogPublishingOptions.%s.Enabled", [getPath(path),name, logName]),
		"searchLine" : common_lib.build_search_line(path, [name, "Properties", "LogPublishingOptions", logName, "Enabled"]),
	}
}

search_for_standalone_ingress(sec_group_name, doc) = ingresses_with_names {
  resources := doc.Resources

  names := [name |
    ingress := resources[name]
    ingress.Type == "AWS::EC2::SecurityGroupIngress"
    get_name(ingress.Properties.GroupId) == sec_group_name
  ]

  ingresses_with_names := {
    "ingress_list": [resources[name].Properties | name := names[_]],
    "names": names
  }
} else = {"ingress_list": [], "names": []}


get_search_values_for_ingress_resources(ing_index, sec_group_name, names_list, index_sec_document, index_main_document) = results {
	ing_index < count(names_list) # if ingress has name it is standalone

	results := {
		"searchKey" : sprintf("Resources.%s.Properties", [names_list[ing_index]]),
		"searchLine" : common_lib.build_search_line(["Resources", names_list[ing_index], "Properties"], []),
		"doc_index" : index_sec_document,
		"type" : "AWS::EC2::SecurityGroupIngress"
	}
} else = results {  # else it is part of the "SecurityGroupIngress" array

	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupIngress[%d]", [sec_group_name, ing_index-count(names_list)]),
		"searchLine" : common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupIngress", ing_index-count(names_list)], []),
		"doc_index": index_main_document,
		"type" : "AWS::EC2::SecurityGroup"
	}
}
