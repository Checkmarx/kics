package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
    object.get(resource.ebs_block_device, "encrypted", "undefined") != "undefined"
	not resource.ebs_block_device.encrypted

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].ebs_block_device.encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].ebs_block_device.encrypted is true", [name]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].ebs_block_device.encrypted is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	object.get(resource, "ebs_block_device", "undefined") != "undefined"
	object.get(resource.ebs_block_device, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].ebs_block_device", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].ebs_block_device.encrypted is set", [name]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].ebs_block_device.encrypted is undefined", [name]),
	}
}
