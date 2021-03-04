package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	object.get(resource[block], "encrypted", "undefined") != "undefined"
	not resource[block].encrypted

	not contains(block, "ephemeral")
	contains(block, "block_device")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].%s.encrypted", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].%s.encrypted is true", [name, block]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].%s.encrypted is false", [name, block]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	object.get(resource[block], "encrypted", "undefined") == "undefined"

	not contains(block, "ephemeral")
	contains(block, "block_device")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].%s", [name, block]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].%s.encrypted is set", [name, block]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].%s.encrypted is undefined", [name, block]),
	}
}
