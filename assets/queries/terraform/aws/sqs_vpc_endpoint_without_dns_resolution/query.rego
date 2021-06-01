package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_vpc_endpoint[name]

	serviceNameSplit := split(resource.service_name, ".")
	serviceNameSplit[minus(count(serviceNameSplit), 1)] == "sqs"
	vpcNameRef := split(resource.vpc_id, ".")[1]

	vpc := input.document[j].resource.aws_vpc[vpcNameRef]
	vpc.enable_dns_support == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_vpc_endpoint[%s].vpc_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "SQS VPC Endpoint has DNS resolution enabled",
		"keyActualValue": "SQS VPC Endpoint has DNS resolution disabled ('enable_dns_support' set to false)",
	}
}
