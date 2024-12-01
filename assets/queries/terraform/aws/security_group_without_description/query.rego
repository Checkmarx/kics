package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_security_group[name]
	not common_lib.valid_key(resource, "description")

	result := {
		"documentId": document.id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[{{%s}}] description should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_security_group[{{%s}}] description is undefined or null", [name]),
	}
}
