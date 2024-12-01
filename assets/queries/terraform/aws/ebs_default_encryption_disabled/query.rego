package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_ebs_encryption_by_default[name]
	resource.enabled == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_ebs_encryption_by_default",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ebs_encryption_by_default[%s].enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ebs_encryption_by_default", name, "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_ebs_encryption_by_default.encrypted' should be true",
		"keyActualValue": "'aws_ebs_encryption_by_default.encrypted' is false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
