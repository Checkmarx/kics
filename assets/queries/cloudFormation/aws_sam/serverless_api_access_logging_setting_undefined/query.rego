package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

info := {"AWS::Serverless::HttpApi": "AccessLogSettings", "AWS::Serverless::Api": "AccessLogSetting"}

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	field := info[type]
	resource.Type == type
	properties := resource.Properties
	not common_lib.valid_key(properties, field)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.%d should be defined and not null", [name, field]),
		"keyActualValue": sprintf("Resources.%s.Properties.%d is undefined or null", [name, field]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
