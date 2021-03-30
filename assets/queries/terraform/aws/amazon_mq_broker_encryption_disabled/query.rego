package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.resource.aws_mq_broker[name]

	object.get(resource, "encryption_options", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_mq_broker[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_mq_broker[%s].encryption_options is defined", [name]),
		"keyActualValue": sprintf("resource.aws_mq_broker[%s].encryption_options is not defined", [name]),
	}
}
