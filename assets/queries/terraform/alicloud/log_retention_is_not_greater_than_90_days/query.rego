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
		"keyExpectedValue": "For attribute 'retention_period' to be set and over 90 days.",
		"keyActualValue": "The attribute 'retention_period' is undefined. The default duration when undefined is 30 days, which is too short.",
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
		"keyExpectedValue": "For the attribite 'retention_period' to be set to 90+ days",
		"keyActualValue": "The attribute 'retention_period' is not set to 90+ days",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_log_store", name, "retention_period"], []),
	}
}
