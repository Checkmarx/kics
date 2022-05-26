package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	resource.Properties.PubliclyAccessible == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PubliclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is set to false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PubliclyAccessible"], []),
	}
}
