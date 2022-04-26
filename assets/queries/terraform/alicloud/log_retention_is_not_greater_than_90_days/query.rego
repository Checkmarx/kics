package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_log_store[name]
    not common_lib.valid_key(resource, "retention_period")
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_log_store[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("For a log storing resource to exist and have retetion period set to 90+ days.", [name]),
		"keyActualValue": sprintf("The retention period for the resource %s is not over 90 days", [name]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_log_store", name], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_log_store[name]
    rperiod := resource.retention_period
    to_number(rperiod) < 90
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_log_store[%s].retention_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("For a log storing resource to exist and have retetion period set to 90+ days.", [name]),
		"keyActualValue": sprintf("The retention period for the resource %s is not over 90 days", [name]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_disk", name, "encrypted"], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource
    not common_lib.valid_key(resource, "alicloud_log_store")
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": "alicloud_log_store",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "For a log storing resource to exist",
		"keyActualValue": "There is no log storing resource",
        "searchLine": common_lib.build_search_line(["resource"], []),
	}
}
