package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.ssl_action == "Close"


	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s].ssl_action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ssl_action' value should be 'Open'",
		"keyActualValue": "'ssl_action' value is 'Close'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "ssl_action"], []),
		"remediation": json.marshal({
            "before": "Close",
            "after": "Open"
        }),
        "remediationType": "replacement",	
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	not common_lib.valid_key(resource, "ssl_action")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ssl_action' value should be 'Open'",
		"keyActualValue": "'ssl_action' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
		"remediation": "ssl_action = \"Open\"",
        "remediationType": "addition",	
	}
}
