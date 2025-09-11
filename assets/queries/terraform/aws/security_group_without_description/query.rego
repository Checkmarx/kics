package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	#Case of "aws_security_group" Resource without description 
	resource := input.document[i].resource.aws_security_group[name]
	not common_lib.valid_key(resource, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[%s] description should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] description is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name], []),
	}
}

CxPolicy[result] {
	#Case of "security-group" Module without description 
	module := input.document[i].module[name]
	contains(module.source,"security-group")
	not common_lib.valid_key(module, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s] description should be defined and not null",[name]),
		"keyActualValue": sprintf("module[%s] description is undefined or null",[name]),
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}