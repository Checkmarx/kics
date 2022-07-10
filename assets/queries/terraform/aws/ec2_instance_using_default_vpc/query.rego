package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	sbName := split(resource.subnet_id, ".")[1]

	sb := input.document[_].resource.aws_subnet[sbName]

	contains(lower(sb.vpc_id), "default")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s].subnet_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance[%s].subnet_id should not be associated with a default VPC", [name]),
		"keyActualValue": sprintf("aws_instance[%s].subnet_id is associated with a default VPC", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "subnet_id"], []),
	}
}
