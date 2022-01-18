package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Function"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Tags")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Tags' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Tags' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
