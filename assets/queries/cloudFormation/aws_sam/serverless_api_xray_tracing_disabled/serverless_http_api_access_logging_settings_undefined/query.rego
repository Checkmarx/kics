package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Serverless::HttpApi"
	properties := resource.Properties
	not common_lib.valid_key(properties, "AccessLogSettings")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
