package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_kms_key[name]
	seconds_in_a_year := 31536000
	getSeconds(resource) > seconds_in_a_year

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_kms_key[%s].rotation_interval", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'rotation_interval' value should not be higher than a year",
		"keyActualValue": "'rotation_interval' value is higher than a year",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_kms_key", name, "rotation_interval"], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_kms_key[name]
	not common_lib.valid_key(resource, "automatic_rotation") 

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_kms_key[%s].rotation_interval", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'automatic_rotation' should be defined and set to Enabled",
		"keyActualValue": "'automatic_rotation' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_kms_key", name], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_kms_key[name]
	resource.automatic_rotation == "Disabled" 

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_kms_key[%s].rotation_interval", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'automatic_rotation' should be set to Enabled",
		"keyActualValue": "'automatic_rotation' is set to Disabled",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_kms_key", name, "automatic_rotation"], []),
	}
}

getSeconds(resource) = value{
	contains(resource.rotation_interval, "s")
	value := to_number(trim_suffix(resource.rotation_interval, "s"))   
}else = value {
	contains(resource.rotation_interval, "m")
	value := to_number(trim_suffix(resource.rotation_interval, "m"))*60   
}else = value {
	contains(resource.rotation_interval, "h")
	value := to_number(trim_suffix(resource.rotation_interval, "h"))*3600  
}else = value {
	contains(resource.rotation_interval, "d")
	value := to_number(trim_suffix(resource.rotation_interval, "d"))*86400  
}
