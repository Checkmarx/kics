package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    resource.versioning.status == "Suspended"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].versioning.status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.status' should be enabled",
		"keyActualValue": "'versioning.status' is suspended",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "versioning", "status"], []),
		"remediation": json.marshal({
            "before": "Suspended",
            "after": "Enabled"
        }),
        "remediationType": "replacement",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    not common_lib.valid_key(resource, "versioning")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning.status' should be defined and set to enabled",
		"keyActualValue": "'versioning' is missing",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
		"remediation": "versioning {\n\t\tstatus = \"Enabled\"\n\t}",
        "remediationType": "addition",
	}
}
