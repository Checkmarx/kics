package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_oss_bucket[name]
    not common_lib.valid_key(resource,"logging")
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s has logging enabled",[name]),
		"keyActualValue": sprintf("%s does not have logging enabled",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_oss_bucket[name]
    resource.logging_isenable == false
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].logging_isenable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s 'logging_isenable' argument should be set to true",[name]),
		"keyActualValue": sprintf("%s 'logging_isenable' argument is set to false",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "logging_isenable"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
