package Cx

import data.generic.common as common_lib

info := {"AWS::Serverless::HttpApi": "AccessLogSettings", "AWS::Serverless::Api": "AccessLogSetting"}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	field := info[type]
	resource.Type == type
	properties := resource.Properties
	not common_lib.valid_key(properties, field)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.%d is defined and not null", [name, field]),
		"keyActualValue": sprintf("Resources.%s.Properties.%d is undefined or null", [name, field]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
