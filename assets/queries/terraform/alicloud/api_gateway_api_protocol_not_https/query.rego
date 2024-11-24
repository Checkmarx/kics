package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_api_gateway_api[name]
	request_config := resource.request_config
	request_config.protocol != "HTTPS"

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_api_gateway_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_api_gateway_api[%s].request_config.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'protocol' value should be 'HTTPS'",
		"keyActualValue": "'protocol' value is 'HTTP' or 'HTTP,HTTPS'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_api_gateway_api", name, "request_config", "protocol"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_api_gateway_api[name]
	request_config := resource.request_config[index]
	request_config.protocol != "HTTPS"

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_api_gateway_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_api_gateway_api[%s].request_config.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'protocol' value should be 'HTTPS'",
		"keyActualValue": "'protocol' value is 'HTTP' or 'HTTP,HTTPS'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_api_gateway_api", name, "request_config", index, "protocol"], []),
	}
}
