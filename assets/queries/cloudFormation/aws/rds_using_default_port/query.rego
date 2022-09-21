package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	enginePort := common_lib.engines[e]

	lower(resource.Properties.Engine) == e
	resource.Properties.Port == enginePort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.Port", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Port' should not be set to %d", [name, enginePort]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Port' is set to %d", [name, enginePort]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "Port"]),
	}
}
