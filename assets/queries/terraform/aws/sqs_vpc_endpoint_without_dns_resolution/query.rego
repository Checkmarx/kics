package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_vpc_endpoint[name]

	serviceNameSplit := split(resource.service_name, ".")
	serviceNameSplit[minus(count(serviceNameSplit), 1)] == "sqs"
	vpcNameRef := split(resource.vpc_id, ".")[1]

	vpc := input.document[j].resource.aws_vpc[vpcNameRef]
	vpc.enable_dns_support == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_vpc_endpoint",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_vpc_endpoint[%s].vpc_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enable_dns_support' should be set to true or undefined",
		"keyActualValue": "'enable_dns_support' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_vpc_endpoint", name, "vpc_id"], []),
	}
}


CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_vpc", "enable_dns_support")

	module[keyToCheck] == false
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].enable_dns_support", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enable_dns_support' should be set to true or undefined",
		"keyActualValue": "'enable_dns_support' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "vpc_id"], []),
	}
}
