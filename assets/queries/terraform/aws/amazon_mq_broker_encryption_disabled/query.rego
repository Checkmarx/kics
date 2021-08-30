package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.resource.aws_mq_broker[name]

	not common_lib.valid_key(resource, "encryption_options")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_mq_broker[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_mq_broker[%s].encryption_options is defined", [name]),
		"keyActualValue": sprintf("resource.aws_mq_broker[%s].encryption_options is not defined", [name]),
	}
}
