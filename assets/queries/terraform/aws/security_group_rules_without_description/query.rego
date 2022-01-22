package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	types := {"ingress", "egress"}
	resourceType := resource[types[y]]
    not is_array(resourceType)
	not common_lib.valid_key(resourceType, "description")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[{{%s}}].%s", [name, types[y]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[{{%s}}].%s description is defined and not null", [name, types[y]]),
		"keyActualValue": sprintf("aws_security_group[{{%s}}].%s description is undefined or null", [name, types[y]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, types[y]], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	types := {"ingress", "egress"}
	resourceType := resource[types[y]]
    is_array(resourceType)
    currentResource := resourceType[resourceIndex]
	not common_lib.valid_key(currentResource, "description")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[{{%s}}].%s", [name, types[y]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[{{%s}}].%s description is defined and not null", [name, types[y]]),
		"keyActualValue": sprintf("aws_security_group[{{%s}}].%s description is undefined or null", [name, types[y]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, types[y], resourceIndex], []),
	}
}
