package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	resource.Properties.PubliclyAccessible == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PubliclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is set to false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PubliclyAccessible"], []),
	}
}
