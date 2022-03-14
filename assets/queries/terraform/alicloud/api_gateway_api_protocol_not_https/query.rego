package Cx
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_api_gateway_api[name]
	request_config := resource.request_config
    request_config.protocol != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_api_gateway_api[%s].request_config.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'protocol' value should be 'HTTPS'",
		"keyActualValue": "'protocol' value is 'HTTP' or 'HTTP,HTTPS'",
		
	}
}

