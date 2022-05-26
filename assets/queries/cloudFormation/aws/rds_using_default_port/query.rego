package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	
	enginePort := common_lib.engines[e]

	lower(resource.Properties.Engine) == e
	resource.Properties.Port == enginePort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Port' is not set to %d", [name, enginePort]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Port' is set to %d", [name, enginePort]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Port"], []),
	}
}
