package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_api_gateway_api[name]
	request_config := resource.request_config
    request_config.protocol != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_api_gateway_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_api_gateway_api[%s].request_config.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'protocol' value should be 'HTTPS'",
		"keyActualValue": "'protocol' value is 'HTTP' or 'HTTP,HTTPS'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_api_gateway_api", name, "request_config","protocol"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_api_gateway_api[name]
	request_config := resource.request_config[index]
    request_config.protocol != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_api_gateway_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_api_gateway_api[%s].request_config.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'protocol' value should be 'HTTPS'",
		"keyActualValue": "'protocol' value is 'HTTP' or 'HTTP,HTTPS'",	
		"searchLine": common_lib.build_search_line(["resource", "alicloud_api_gateway_api", name, "request_config", index, "protocol" ], []),
	}
}
