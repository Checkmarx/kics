package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	resource.is_enabled == true

	resource.enable_key_rotation == true

	not resource.deletion_window_in_days

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].deletion_window_in_days should be set and valid", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].deletion_window_in_days is undefined", [name]),
		"remediation": "deletion_window_in_days = 30",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	resource.is_enabled == true

	resource.enable_key_rotation == true

	resource.deletion_window_in_days > 30

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kms_key[%s].deletion_window_in_days", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name ,"deletion_window_in_days"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].deletion_window_in_days should be set and valid", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].deletion_window_in_days is set but invalid", [name]),
		"remediation": json.marshal({
			"before": sprintf("%d", [resource.deletion_window_in_days]),
			"after": "30"
		}),
		"remediationType": "replacement",
	}
}
