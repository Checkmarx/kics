package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_actiontrail_trail[name]
    not common_lib.valid_key(resource, "oss_bucket_name")


	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_actiontrail_trail",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_actiontrail_trail", name),
		"searchKey": sprintf("alicloud_actiontrail_trail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "oss_bucket_name should be set.",
		"keyActualValue": "oss_bucket_name is not set.",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_actiontrail_trail", name], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_actiontrail_trail[name]

    possibilities := {"event_rw", "trail_region"}
    not common_lib.valid_key(resource, possibilities[p])


	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_actiontrail_trail",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_actiontrail_trail", name),
		"searchKey": sprintf("alicloud_actiontrail_trail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be set.",[possibilities[p]]),
		"keyActualValue": sprintf("'%s' is not set.",[possibilities[p]]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_actiontrail_trail", name], []),
		"remediation": sprintf("%s= \"ALL\"", [p]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_actiontrail_trail[name]

    p := {"event_rw", "trail_region"}
    resource[p[f]] != "All"

    remediation := {"before":resource[p[f]] , "after": "All" }
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_actiontrail_trail",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_actiontrail_trail", name),
		"searchKey": sprintf("alicloud_actiontrail_trail[%s].%s", [name, p[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be set to All", [p[f]]),
		"keyActualValue": sprintf("'%s' is not set to All", [p[f]]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_actiontrail_trail", name, p[f]], []),
		"remediation": json.marshal(remediation),
		"remediationType": "replacement",
	}
}
