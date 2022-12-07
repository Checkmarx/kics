package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_ebs_volume[name]
	not common_lib.valid_key(resource, "encrypted")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_ebs_volume",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ebs_volume[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ebs_volume", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "One of 'aws_ebs_volume.encrypted' should be defined",
		"keyActualValue": "One of 'aws_ebs_volume.encrypted' is undefined",
		"remediation": "encrypted = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_ebs_volume[name]
	resource.encrypted == false

	result := {
		"documentId": doc.id,
		"resourceType": "aws_ebs_volume",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ebs_volume[%s].encrypted", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ebs_volume", name, "encrypted"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'aws_ebs_volume.encrypted' should be 'true'",
		"keyActualValue": "One of 'aws_ebs_volume.encrypted' is 'false'",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
