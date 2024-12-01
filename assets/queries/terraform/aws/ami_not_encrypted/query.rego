package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	ami := document.resource.aws_ami[name]
	ami.ebs_block_device.encrypted == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_ami",
		"resourceName": tf_lib.get_resource_name(ami, name),
		"searchKey": sprintf("aws_ami[%s].ebs_block_device.encrypted", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ami", name, "ebs_block_device", "encrypted"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' should be 'true'",
		"keyActualValue": "One of 'rule.ebs_block_device.encrypted' is not 'true'",
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some document in input.document
	ami := document.resource.aws_ami[name]
	common_lib.valid_key(ami, "ebs_block_device")
	not common_lib.valid_key(ami.ebs_block_device, "encrypted")
	result := {
		"documentId": document.id,
		"resourceType": "aws_ami",
		"resourceName": tf_lib.get_resource_name(ami, name),
		"searchKey": sprintf("aws_ami[%s].ebs_block_device", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ami", name, "ebs_block_device"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' should be 'true'",
		"keyActualValue": "'rule.ebs_block_device' is undefined",
		"remediation": "encrypted = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	ami := document.resource.aws_ami[name]
	not common_lib.valid_key(ami, "ebs_block_device")

	result := {
		"documentId": document.id,
		"resourceType": "aws_ami",
		"resourceName": tf_lib.get_resource_name(ami, name),
		"searchKey": sprintf("aws_ami[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ami", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' should be 'true'",
		"keyActualValue": "One of 'rule.ebs_block_device' is undefined",
		"remediation": "ebs_block_device{ \n\t\tencrypted = true\n\t}",
		"remediationType": "addition",
	}
}
