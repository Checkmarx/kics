package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.resource.aws_mq_broker[name]

	not common_lib.valid_key(resource, "encryption_options")

	result := {
		"documentId": document.id,
		"resourceType": "aws_mq_broker",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_mq_broker", name),
		"searchKey": sprintf("resource.aws_mq_broker[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_mq_broker[%s].encryption_options should be defined", [name]),
		"keyActualValue": sprintf("resource.aws_mq_broker[%s].encryption_options is not defined", [name]),
	}
}
