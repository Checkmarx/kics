package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_kms_key[name]

	resource.is_enabled == false

	remediation := {"before": "false", "after": "true"}

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_kms_key[%s].is_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_kms_key[%s].is_enabled should be set to true", [name]),
		"keyActualValue": sprintf("alicloud_kms_key[%s].is_enabled is set to false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_kms_key", name, "is_enabled"], []),
		"remediation": json.marshal(remediation),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_kms_key[name]

	not common_lib.valid_key(resource, "is_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_kms_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_kms_key[%s].is_enabled should be set to true", [name]),
		"keyActualValue": sprintf("alicloud_kms_key[%s].is_enabled is not set", [name]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_kms_key", name], []),
		"remediation": "is_enabled = true",
		"remediationType": "addition",
	}
}
