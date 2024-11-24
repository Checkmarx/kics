package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_instance[name]

	not common_lib.valid_key(resource, "vpc_security_group_ids")

	result := {
		"documentId": document.id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'vpc_security_group_ids' should be defined and not null",
		"keyActualValue": "Attribute 'vpc_security_group_ids' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "vpc_security_group_ids")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'vpc_security_group_ids' should be defined and not null",
		"keyActualValue": "Attribute 'vpc_security_group_ids' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
