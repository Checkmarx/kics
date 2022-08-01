package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

valid_types := ["aws:apigateway:Stage","aws:apigatewayv2:Stage"]

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == valid_types[_]

	not common_lib.valid_key(resource.properties, "accessLogSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'accessLogSettings' should be defined",
		"keyActualValue": "Attribute 'accessLogSettings' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}
