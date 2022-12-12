package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	resource.is_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kms_key[%s].is_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name, "is_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].is_enabled should be set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].is_enabled is set to false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
