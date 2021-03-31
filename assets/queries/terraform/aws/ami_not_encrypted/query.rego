package Cx

CxPolicy[result] {
	ami := input.document[i].resource.aws_ami[name]
	ami.ebs_block_device
	not ami.ebs_block_device.encrypted

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ami[%s].ebs_block_device", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' is 'true'",
		"keyActualValue": "One of 'rule.ebs_block_device.encrypted' is not 'true'",
	}
}

CxPolicy[result] {
	ami := input.document[i].resource.aws_ami[name]
	not ami.ebs_block_device

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ami[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' is 'true'",
		"keyActualValue": "One of 'rule.ebs_block_device' is undefined",
	}
}
